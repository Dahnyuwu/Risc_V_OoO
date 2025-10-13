module Dispatch_Unit(
    input   logic   [31:0]  PrC_4, inst, cdb_data,
    input   logic   [5:0]   cdb_tag,
    input   logic           empty, cdb_b, cdb_b_taken, cdb_va, clk, rst,
    output  logic   [31:0]  jmp_b_add,
    output  logic           jmp_b_va, rd_en
);

    Register_File   RF      (.clk(clk), .rst(rst), .Rr1(), .Rr2(), .RdAdd(), .rw(), .RdDat(), .Rd1(), .Rd2());
    RST             RST_I   (.clk(clk), .rst(rst), .rs1_add(), .rs2_add(), .w_data_ena1(), .w_data_ena2(), .w_data1(), .w_data2(), .rs1_tag(), .rs2_tag(), .rs1_tag_va(), .rs2_tag_va());
    TAG_FIFO        TF      (.clk(clk), .rst(rst), .r_ena(r_ena_), .cdb_tag_va(), .cdb_tag(), .full(), .empty(), .tag_out());
    Dec_Jmp_Bra     DJB     (.inst(), .rs1(), .rs2(), .rd(), .funct3(), .funct7(), .opcode(), .r_ena(r_ena_));

endmodule