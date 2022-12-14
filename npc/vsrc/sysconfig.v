
// 仅仅用于仿真加快速度，替换多周期乘除法
// `define MUL_SIM
//`define DIV_SIM
//`define ysyx_041514_YSYX_SOC          // ysyxSOC 仿真环境

`define ysyx_041514_XLEN 64             //cpu 位数
`define ysyx_041514_INST_LEN 32         //指令长度
`define ysyx_041514_IMM_LEN 64          //立即数长度
`define ysyx_041514_REG_NUM 32          //寄存器个数
`define ysyx_041514_REG_ADDRWIDTH 5     //寄存器地址宽度

`ifndef ysyx_041514_YSYX_SOC  // 不同仿真环境下 PC 的初始值不同
`define ysyx_041514_PC_RESET_ADDR `ysyx_041514_XLEN'h0000_0000_8000_0000
`else
`define ysyx_041514_PC_RESET_ADDR `ysyx_041514_XLEN'h0000_0000_3000_0000
`endif


`define ysyx_041514_NPC_ADDR_LEN 32
`define ysyx_041514_NPC_ADDR_BUS `ysyx_041514_NPC_ADDR_LEN-1:0

`define ysyx_041514_INST_NOP 32'h00000013           //ADDI x0, x0, 0
`define ysyx_041514_TRUE 1'b1
`define ysyx_041514_FALSE 1'b0


`define ysyx_041514_MMIO_BASE 32'h0000_0000_a000_0000

/* BUS */
`define ysyx_041514_XLEN_BUS `ysyx_041514_XLEN-1:0


/* exc 操作码 */
`define ysyx_041514_EXCOP_LEN 5

`define ysyx_041514_EXCOP_NONE `ysyx_041514_EXCOP_LEN'd0
`define ysyx_041514_EXCOP_AUIPC `ysyx_041514_EXCOP_LEN'd1
`define ysyx_041514_EXCOP_LUI `ysyx_041514_EXCOP_LEN'd2
`define ysyx_041514_EXCOP_JAL `ysyx_041514_EXCOP_LEN'd3
`define ysyx_041514_EXCOP_JALR `ysyx_041514_EXCOP_LEN'd4
`define ysyx_041514_EXCOP_LOAD `ysyx_041514_EXCOP_LEN'd5
`define ysyx_041514_EXCOP_STORE `ysyx_041514_EXCOP_LEN'd6
`define ysyx_041514_EXCOP_BRANCH `ysyx_041514_EXCOP_LEN'd7
`define ysyx_041514_EXCOP_OPIMM `ysyx_041514_EXCOP_LEN'd8
`define ysyx_041514_EXCOP_OPIMM32 `ysyx_041514_EXCOP_LEN'd9
`define ysyx_041514_EXCOP_OP `ysyx_041514_EXCOP_LEN'd10
`define ysyx_041514_EXCOP_OP32 `ysyx_041514_EXCOP_LEN'd11
`define ysyx_041514_EXCOP_CSR `ysyx_041514_EXCOP_LEN'd12

`define ysyx_041514_EXCOP_EBREAK `ysyx_041514_EXCOP_LEN'd13


/* ALU 操作码 */
`define ysyx_041514_ALUOP_LEN 6

`define ysyx_041514_ALUOP_NONE `ysyx_041514_ALUOP_LEN'd0
`define ysyx_041514_ALUOP_ADD `ysyx_041514_ALUOP_LEN'd1
`define ysyx_041514_ALUOP_SUB `ysyx_041514_ALUOP_LEN'd2
/* 逻辑操作 */
`define ysyx_041514_ALUOP_XOR `ysyx_041514_ALUOP_LEN'd3
`define ysyx_041514_ALUOP_OR `ysyx_041514_ALUOP_LEN'd4
`define ysyx_041514_ALUOP_AND `ysyx_041514_ALUOP_LEN'd5
/* 移位操作 */
`define ysyx_041514_ALUOP_SLL `ysyx_041514_ALUOP_LEN'd6
`define ysyx_041514_ALUOP_SRL `ysyx_041514_ALUOP_LEN'd7
`define ysyx_041514_ALUOP_SRA `ysyx_041514_ALUOP_LEN'd8
//忽略高32位的移位操作
`define ysyx_041514_ALUOP_SLLW `ysyx_041514_ALUOP_LEN'd9
`define ysyx_041514_ALUOP_SRLW `ysyx_041514_ALUOP_LEN'd10
`define ysyx_041514_ALUOP_SRAW `ysyx_041514_ALUOP_LEN'd11
/* 比较操作 */
`define ysyx_041514_ALUOP_SLT `ysyx_041514_ALUOP_LEN'd12
`define ysyx_041514_ALUOP_SLTU `ysyx_041514_ALUOP_LEN'd13

`define ysyx_041514_ALUOP_BEQ `ysyx_041514_ALUOP_LEN'd14
`define ysyx_041514_ALUOP_BNE `ysyx_041514_ALUOP_LEN'd15
`define ysyx_041514_ALUOP_BLT `ysyx_041514_ALUOP_LEN'd16
`define ysyx_041514_ALUOP_BGE `ysyx_041514_ALUOP_LEN'd17
`define ysyx_041514_ALUOP_BLTU `ysyx_041514_ALUOP_LEN'd18
`define ysyx_041514_ALUOP_BGEU `ysyx_041514_ALUOP_LEN'd19

/* 乘除法 */
`define ysyx_041514_ALUOP_MUL `ysyx_041514_ALUOP_LEN'd20
`define ysyx_041514_ALUOP_MULH `ysyx_041514_ALUOP_LEN'd21
`define ysyx_041514_ALUOP_MULHSU `ysyx_041514_ALUOP_LEN'd22
`define ysyx_041514_ALUOP_MULHU `ysyx_041514_ALUOP_LEN'd23
`define ysyx_041514_ALUOP_MULW `ysyx_041514_ALUOP_LEN'd24

`define ysyx_041514_ALUOP_DIV `ysyx_041514_ALUOP_LEN'd25
`define ysyx_041514_ALUOP_DIVU `ysyx_041514_ALUOP_LEN'd26
`define ysyx_041514_ALUOP_REM `ysyx_041514_ALUOP_LEN'd27
`define ysyx_041514_ALUOP_REMU `ysyx_041514_ALUOP_LEN'd28
`define ysyx_041514_ALUOP_DIVW `ysyx_041514_ALUOP_LEN'd29
`define ysyx_041514_ALUOP_DIVUW `ysyx_041514_ALUOP_LEN'd30
`define ysyx_041514_ALUOP_REMW `ysyx_041514_ALUOP_LEN'd31
`define ysyx_041514_ALUOP_REMUW `ysyx_041514_ALUOP_LEN'd32

/* mem操作码 */
`define ysyx_041514_MEMOP_LEN 4

/* 读取 */

`define ysyx_041514_MEMOP_NONE `ysyx_041514_MEMOP_LEN'd0 //空操作

`define ysyx_041514_MEMOP_LB `ysyx_041514_MEMOP_LEN'd1
`define ysyx_041514_MEMOP_LH `ysyx_041514_MEMOP_LEN'd2
`define ysyx_041514_MEMOP_LW `ysyx_041514_MEMOP_LEN'd3
`define ysyx_041514_MEMOP_LBU `ysyx_041514_MEMOP_LEN'd4
`define ysyx_041514_MEMOP_LHU `ysyx_041514_MEMOP_LEN'd5
`define ysyx_041514_MEMOP_LD `ysyx_041514_MEMOP_LEN'd6
`define ysyx_041514_MEMOP_LWU `ysyx_041514_MEMOP_LEN'd7

/* 写入 */
`define ysyx_041514_MEMOP_SB `ysyx_041514_MEMOP_LEN'd8
`define ysyx_041514_MEMOP_SH `ysyx_041514_MEMOP_LEN'd9
`define ysyx_041514_MEMOP_SW `ysyx_041514_MEMOP_LEN'd10
`define ysyx_041514_MEMOP_SD `ysyx_041514_MEMOP_LEN'd11

`define ysyx_041514_MEMOP_FENCEI `ysyx_041514_MEMOP_LEN'd12


/* writeback 操作码 */
`define ysyx_041514_WBOP_LEN 4

/* 读取 */
`define ysyx_041514_WBOP_RD `ysyx_041514_WBOP_LEN'd0
`define ysyx_041514_WBOP_NONE `ysyx_041514_WBOP_LEN'd1

/* PC操作码 */
`define ysyx_041514_PCOP_LEN 4

`define ysyx_041514_PCOP_NONE `ysyx_041514_PCOP_LEN'd0 //空操作
`define ysyx_041514_PCOP_BRANCH `ysyx_041514_PCOP_LEN'd1
`define ysyx_041514_PCOP_JAL `ysyx_041514_PCOP_LEN'd2
`define ysyx_041514_PCOP_JALR `ysyx_041514_PCOP_LEN'd3
`define ysyx_041514_PCOP_INC4 `ysyx_041514_PCOP_LEN'd4
`define ysyx_041514_PCOP_TRAP `ysyx_041514_PCOP_LEN'd5


/*************CSR************/

`define ysyx_041514_CSROP_LEN 3


`define ysyx_041514_CSROP_NONE `ysyx_041514_CSROP_LEN'd0
`define ysyx_041514_CSROP_READ `ysyx_041514_CSROP_LEN'd1
`define ysyx_041514_CSROP_WRITE `ysyx_041514_CSROP_LEN'd2
`define ysyx_041514_CSROP_SET `ysyx_041514_CSROP_LEN'd3
`define ysyx_041514_CSROP_CLEAR `ysyx_041514_CSROP_LEN'd4


//寄存器地址
`define ysyx_041514_CSR_REG_ADDRWIDTH 12
//Machine Trap Setup
`define ysyx_041514_CSR_MSTATUS 12'h300
`define ysyx_041514_CSR_MISA 12'h301
`define ysyx_041514_CSR_MEDELEG 12'h302
`define ysyx_041514_CSR_MIDELEG 12'h303
`define ysyx_041514_CSR_MIE 12'h304
`define ysyx_041514_CSR_MTVEC 12'h305
`define ysyx_041514_CSR_MCOUNTEREN 12'h306
//Machine Trap Handling
`define ysyx_041514_CSR_MSCRATCH 12'h340
`define ysyx_041514_CSR_MEPC 12'h341
`define ysyx_041514_CSR_MCAUSE 12'h342
`define ysyx_041514_CSR_MTVAL 12'h343
`define ysyx_041514_CSR_MIP 12'h344
`define ysyx_041514_CSR_MTINST 12'h34a
`define ysyx_041514_CSR_MTVAL2 12'h34b


`define ysyx_041514_CSR_MSTATUS_DEFAULT `ysyx_041514_XLEN'ha00001800 


`define ysyx_041514_MTIMECMP_ADDR 32'h2004000
`define ysyx_041514_MTIME_ADDR 32'h200BFF8

/**********tarp**********/




`define ysyx_041514_TRAP_INST_ADDR_MISALIGNED 0
`define ysyx_041514_TRAP_INST_ACCESS_FAULT 1
`define ysyx_041514_TRAP_ILLEGAL_INST 2
`define ysyx_041514_TRAP_BREAKPOINT 3
`define ysyx_041514_TRAP_LOAD_ADDR_MISALIGNED 4
`define ysyx_041514_TRAP_LOAD_ACCESS_FAULT 5
`define ysyx_041514_TRAP_STORE_ADDR_MISALIGNED 6
`define ysyx_041514_TRAP_STORE_ACCESS_FAULT 7
`define ysyx_041514_TRAP_ECALL_U 8
`define ysyx_041514_TRAP_ECALL_S 9 
`define ysyx_041514_TRAP_RESERVED0 10 
`define ysyx_041514_TRAP_ECALL_M 11
`define ysyx_041514_TRAP_INST_PAGE_FAULT 12
`define ysyx_041514_TRAP_LOAD_PAGE_FAULT 13
`define ysyx_041514_TRAP_RESERVED1 14
`define ysyx_041514_TRAP_STORE_PAGE_FAULT 15


`define ysyx_041514_TRAP_MRET 16 // 把 MRET 当成 trap
`define ysyx_041514_TRAP_EBREAK 17 // 把 EBREAK 当成 trap
`define ysyx_041514_TRAP_FENCEI 18 // 把 fencei 当成 trap,复用线路
`define ysyx_041514_TRAP_LEN 19
`define ysyx_041514_TRAP_BUS `ysyx_041514_TRAP_LEN-1:0



//PC,IF_ID, ID_EX, EX_MEM, MEM_WB
`define ysyx_041514_CTRLBUS_PC 0
`define ysyx_041514_CTRLBUS_IF_ID 1
`define ysyx_041514_CTRLBUS_ID_EX 2
`define ysyx_041514_CTRLBUS_EX_MEM 3
`define ysyx_041514_CTRLBUS_MEM_WB 4



// Burst types
`define ysyx_041514_AXI_BURST_TYPE_FIXED 2'b00               //突发类型  FIFO
`define ysyx_041514_AXI_BURST_TYPE_INCR 2'b01               //ram  
`define ysyx_041514_AXI_BURST_TYPE_WRAP 2'b10
// Access permissions
`define ysyx_041514_AXI_PROT_UNPRIVILEGED_ACCESS 3'b000
`define ysyx_041514_AXI_PROT_PRIVILEGED_ACCESS 3'b001
`define ysyx_041514_AXI_PROT_SECURE_ACCESS 3'b000
`define ysyx_041514_AXI_PROT_NON_SECURE_ACCESS 3'b010
`define ysyx_041514_AXI_PROT_DATA_ACCESS 3'b000
`define ysyx_041514_AXI_PROT_INSTRUCTION_ACCESS 3'b100
// Memory types (AR)
`define ysyx_041514_AXI_ARCACHE_DEVICE_NON_BUFFERABLE 4'b0000
`define ysyx_041514_AXI_ARCACHE_DEVICE_BUFFERABLE 4'b0001
`define ysyx_041514_AXI_ARCACHE_NORMAL_NON_CACHEABLE_NON_BUFFERABLE 4'b0010
`define ysyx_041514_AXI_ARCACHE_NORMAL_NON_CACHEABLE_BUFFERABLE 4'b0011
`define ysyx_041514_AXI_ARCACHE_WRITE_THROUGH_NO_ALLOCATE 4'b1010
`define ysyx_041514_AXI_ARCACHE_WRITE_THROUGH_READ_ALLOCATE 4'b1110
`define ysyx_041514_AXI_ARCACHE_WRITE_THROUGH_WRITE_ALLOCATE 4'b1010
`define ysyx_041514_AXI_ARCACHE_WRITE_THROUGH_READ_AND_WRITE_ALLOCATE 4'b1110
`define ysyx_041514_AXI_ARCACHE_WRITE_BACK_NO_ALLOCATE 4'b1011
`define ysyx_041514_AXI_ARCACHE_WRITE_BACK_READ_ALLOCATE 4'b1111
`define ysyx_041514_AXI_ARCACHE_WRITE_BACK_WRITE_ALLOCATE 4'b1011
`define ysyx_041514_AXI_ARCACHE_WRITE_BACK_READ_AND_WRITE_ALLOCATE 4'b1111
// Memory types (AW)
`define ysyx_041514_AXI_AWCACHE_DEVICE_NON_BUFFERABLE 4'b0000
`define ysyx_041514_AXI_AWCACHE_DEVICE_BUFFERABLE 4'b0001
`define ysyx_041514_AXI_AWCACHE_NORMAL_NON_CACHEABLE_NON_BUFFERABLE 4'b0010
`define ysyx_041514_AXI_AWCACHE_NORMAL_NON_CACHEABLE_BUFFERABLE 4'b0011
`define ysyx_041514_AXI_AWCACHE_WRITE_THROUGH_NO_ALLOCATE 4'b0110
`define ysyx_041514_AXI_AWCACHE_WRITE_THROUGH_READ_ALLOCATE 4'b0110
`define ysyx_041514_AXI_AWCACHE_WRITE_THROUGH_WRITE_ALLOCATE 4'b1110
`define ysyx_041514_AXI_AWCACHE_WRITE_THROUGH_READ_AND_WRITE_ALLOCATE 4'b1110
`define ysyx_041514_AXI_AWCACHE_WRITE_BACK_NO_ALLOCATE 4'b0111
`define ysyx_041514_AXI_AWCACHE_WRITE_BACK_READ_ALLOCATE 4'b0111
`define ysyx_041514_AXI_AWCACHE_WRITE_BACK_WRITE_ALLOCATE 4'b1111
`define ysyx_041514_AXI_AWCACHE_WRITE_BACK_READ_AND_WRITE_ALLOCATE 4'b1111

`define ysyx_041514_AXI_SIZE_BYTES_1 3'b000                //突发宽度一个数据的宽度
`define ysyx_041514_AXI_SIZE_BYTES_2 3'b001
`define ysyx_041514_AXI_SIZE_BYTES_4 3'b010
`define ysyx_041514_AXI_SIZE_BYTES_8 3'b011
`define ysyx_041514_AXI_SIZE_BYTES_16 3'b100
`define ysyx_041514_AXI_SIZE_BYTES_32 3'b101
`define ysyx_041514_AXI_SIZE_BYTES_64 3'b110
`define ysyx_041514_AXI_SIZE_BYTES_128 3'b111








