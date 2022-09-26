`include "sysconfig.v"


module alu_div_slow (

    input clk,
    input rst,
    input div_signed_valid_i,// 有符号树除法
    input div32_valid_i,     // 32 位除法
    input [`XLEN-1:0] dividented_i, // 被除数 rs1
    input [`XLEN-1:0] divisor_i,// 除数 rs2
    input div_vliad_i,
    output [`XLEN-1:0] div_data_o,
    output [`XLEN-1:0] rem_data_o,
    output div_ready_o

);
  localparam STATE_LEN = 3;
  localparam DIV_RST = 3'd0;
  localparam DIV_IDLE = 3'd1;
  localparam DIV_START = 3'd2;
  localparam DIV_COUNT32 = 3'd3;
  localparam DIV_COUNT64 = 3'd4;
  localparam DIV_CORECT32 = 3'd5;
  localparam DIV_CORECT64 = 3'd6;
  localparam DIV_FINISH = 3'd7;

  /* 符号扩展 */
  wire div64_rs1_sign = div_signed_valid_i ? dividented_i[63] : 1'b0;
  wire div64_rs2_sign = div_signed_valid_i ? divisor_i[63] : 1'b0;
  wire div32_rs1_sign = div_signed_valid_i ? dividented_i[31] : 1'b0;
  wire div32_rs2_sign = div_signed_valid_i ? divisor_i[31] : 1'b0;


  wire [64:0] div64_dividented = {div64_rs1_sign, dividented_i};
  wire [64:0] div64_divisor = {div64_rs2_sign, divisor_i};
  wire [64:0] div64_divisor_neg = ~div64_divisor + 1;

  wire [32:0] div32_dividented = {div32_rs1_sign, dividented_i[31:0]};
  wire [32:0] div32_divisor = {div32_rs2_sign, divisor_i[31:0]};
  wire [32:0] div32_divisor_neg = ~div32_divisor + 1;


  wire [129:0] div64_z = {{65{div64_rs1_sign}}, div64_dividented};  // 被除数
  wire [64:0] div64_d = div64_divisor;  // 除数，运算时，与 div64_z 左对齐
  wire [64:0] div64_d_neg = div64_divisor_neg; // 除数的相反数（补码）,与 div64_z 左对齐


  wire [65:0] div32_z = {{33{div32_rs1_sign}}, div32_dividented};  // 被除数
  wire [32:0] div32_d = div32_divisor;  // 除数,与 div32_z 左对齐
  wire [32:0] div32_d_neg = div32_divisor_neg;  // 除数的相反数（补码）,与 div32_z 左对齐

  // wire []

  reg [STATE_LEN-1:0] div_state;
  reg [`XLEN_BUS] div_data;
  reg [`XLEN_BUS] rem_data;
  reg [129:0] s_reg;
  reg [64:0] d_reg;
  reg [64:0] d_neg_reg;
  reg [31:0] div_count;
  reg div_reday;


  wire s_sign_64 = s_reg[129];
  wire s_sign_32 = s_reg[65];
  wire d_sign_64 = d_reg[64];
  wire d_sign_32 = d_reg[32];
  wire z_sign_64 = div64_rs1_sign;
  wire z_sign_32 = div32_rs1_sign;



  wire add_d_64 = s_sign_64 ^ d_sign_64;  // 符号异：加有效，符号同：减有效
  wire add_d_32 = s_sign_32 ^ d_sign_32;  // 符号异：加有效，符号同：减有效
  wire [64:0] d_switch_64 = add_d_64 ? d_reg : d_neg_reg;
  wire [64:0] d_switch_32 = add_d_32 ? d_reg : d_neg_reg;
  wire q_temp_64 = add_d_64 ? 1'b0 : 1'b0;  // 每一次计算的商
  wire q_temp_32 = add_d_32 ? 1'b0 : 1'b0;  // 每一次计算的商

  wire [129:0] s_reg_next64 = {{s_reg[128:64] + d_switch_64}, s_reg[63:0], q_temp_64};
  wire [129:0] s_reg_next32 = {64'b0, s_reg[64:32] + d_switch_32[32:0], s_reg[31:0], q_temp_32};

  wire need_correct_64 = s_sign_64 ^ z_sign_64;  // 结果需要修正
  wire need_coreect_32 = s_sign_32 ^ z_sign_32;  // 结果需要修正


  wire [65:0] q_correct_plus_64 = {66{need_correct_64}}&(add_d_64 ? (~66'b0) : 66'b1);  // 1 或 -1
  wire [33:0] q_correct_plus_32 = {34{need_coreect_32}}&(add_d_32 ? (~34'b0) : 34'b1);  // 1 或 -1

  wire [65:0] q_correct_64 = {~s_reg[64], s_reg[63:0], 1'b1} + q_correct_plus_64;
  wire [33:0] q_correct_32 = {~s_reg[32], s_reg[31:0], 1'b1} + q_correct_plus_32;

  wire [64:0] s_correct_plus_64 = {65{need_correct_64}}&(add_d_64? d_reg:d_neg_reg);
  wire [32:0] s_correct_plus_32 = {33{need_coreect_32}}&(add_d_32?d_reg[32:0]:d_neg_reg[32:0]);

  wire [64:0] s_correct_64 = s_reg[129:65]+s_correct_plus_64;
  wire [32:0]s_correct_32 = s_reg[65:33]+s_correct_plus_32;


  always @(posedge clk) begin
    if (rst) begin
      div_state <= DIV_RST;
      div_data  <= 0;
      rem_data  <= 0;
      div_reday <= `FALSE;
    end else begin
      case (div_state)
        DIV_RST: begin
          div_state <= DIV_IDLE;
        end
        DIV_IDLE: begin
          div_reday <= `FALSE;
          case ({
            div_vliad_i, div32_valid_i
          })
            2'b11: begin : div32_begin
              s_reg <= {64'b0, div32_z};  // 只使用低位
              d_reg <= {32'b0, div32_d};
              d_neg_reg <= {32'b0, div32_d_neg};
              div_count <= 32'd33;
              div_state <= DIV_COUNT32;
            end
            2'b10: begin : div64_begin
              s_reg <= div64_z;
              d_reg <= div64_d;
              d_neg_reg <= div64_d_neg;
              div_count <= 32'd65;
              div_state <= DIV_COUNT64;
            end
            default: begin
              div_state <= DIV_IDLE;
            end
          endcase
        end
        DIV_COUNT32: begin
          if (div_count == 0) begin
            div_state <= DIV_CORECT32;
          end else begin
            div_count <= div_count - 1;
            s_reg <= s_reg_next32;
          end
        end
        DIV_COUNT64: begin
          if (div_count == 0) begin
            div_state <= DIV_CORECT64;
          end else begin
            div_count <= div_count - 1;
            s_reg <= s_reg_next64;
          end
        end
        DIV_CORECT32: begin
          div_data<={32'b0,q_correct_32[31:0]};
          rem_data<={32'b0,s_correct_32[31:0]};
          div_reday<=`TRUE;
          div_state <= DIV_IDLE;
        end
        DIV_CORECT64: begin
          div_data<=q_correct_64[63:0];
          rem_data<=s_correct_64[63:0];
          div_reday<=`TRUE;
          div_state <= DIV_IDLE;
        end
        default: begin
          div_state <= DIV_IDLE;
        end
      endcase
    end
  end

assign div_data_o = div_data;
assign rem_data_o = rem_data;
assign div_ready_o = div_reday;


endmodule
