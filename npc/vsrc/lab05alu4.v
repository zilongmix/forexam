module lab05alu4 (
  //ALU PORT
  input      [3:0] a, b  ,
  output reg [3:0] out   ,
  //PSW寄存器中的一些标志位
  output     [0:0] CF, PF, AF, ZF, SF, OF,
  input      [2:0] sel   ,
  // SEG PORT
  output     [7:0] segout
);
  alu4 alu (
    .a  (a  ),
    .b  (b  ),
    .out(out),
    .sel(sel),
    .CF (CF ),
    .PF (PF ),
    .AF (AF ),
    .ZF (ZF ),
    .SF (SF ),
    .OF (OF )
  );
  seg38 seg38a (.in(out[2:0]), .out(segout));
endmodule



module alu4 (
  input      [3:0] a, b,
  output reg [3:0] out,
  output     [0:0] CF, PF, AF, ZF, SF, OF,
  input      [2:0] sel
);
  wire [7:0] d38out ;
  wire [4:0] subb   ; //减法补码转换
  wire [3:0] outps,outn,outand,outor,outxor; //各种结果
  reg        subflag; //减法标志位
  wire       psflag ; //扩展的符号位

  assign subb = (subflag) ? {{1{~b[3]}},~b}+1:{{1{b[3]}},b}; //减法补码转换,b符号扩展
  assign {psflag,outps} = {{1{a[3]}},a} + subb  ; //符号扩展，两位符号位，a符号扩展
  assign CF   = psflag; //借位标志位
  assign OF   = psflag^outps[3];//溢出标志位
  assign ZF   = (outps==4'd0)?1'b1:1'b0;//0标志位
  assign SF   = outps[3];//符号标志位


  assign outn   = ~a;
  assign outand = a&b;
  assign outor  = a|b;
  assign outxor = a^b;

  dcode38 d38 (.in(sel), .out(d38out));
//选择最终输出
  always @(*) begin
    subflag = 0;
    case (d38out)
      8'b0000_0001 : out = outps; //0:加法
      8'b0000_0010 : begin subflag = 1;out = outps; end//1：减法
      8'b0000_0100 : out = outn;  //2：a取反
      8'b0000_1000 : out = outand;//3:与
      8'b0001_0000 : out = outor;//4：或
      8'b0010_0000 : out = outxor;//5：异或
      8'b0100_0000 : begin subflag = 1;out = outps; end//6：比较大小，利用减法
      8'b1000_0000 : begin subflag = 1;out = outps; end//7：判断相等，利用减法
      default      : out[3:0]=4'b0000;
    endcase
  end
endmodule


module dcode38 (
  input [2:0] in,
  output[7:0] out
);
  always @(*) begin
    casez (in)
      3'd0    : out[7:0]=8'b0000_0001;
      3'd1    : out[7:0]=8'b0000_0010;
      3'd2    : out[7:0]=8'b0000_0100;
      3'd3    : out[7:0]=8'b0000_1000;
      3'd4    : out[7:0]=8'b0001_0000;
      3'd5    : out[7:0]=8'b0010_0000;
      3'd6    : out[7:0]=8'b0100_0000;
      3'd7    : out[7:0]=8'b1000_0000;
      default : out[7:0]=8'b0000_0000;
    endcase
  end
endmodule


module seg38 (
  input [2:0] in,
  output[7:0] out
);
//共阳极数码管字符表
  always @(*) begin
    casez (in)
      3'd0    : out[7:0]=8'hc0;
      3'd1    : out[7:0]=8'hf9;
      3'd2    : out[7:0]=8'ha4;
      3'd3    : out[7:0]=8'hb0;
      3'd4    : out[7:0]=8'h99;
      3'd5    : out[7:0]=8'h92;
      3'd6    : out[7:0]=8'h82;
      3'd7    : out[7:0]=8'hf8;
      default : out[7:0]=8'hff;
    endcase
  end
endmodule