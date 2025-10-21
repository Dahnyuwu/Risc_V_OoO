module Dispatch_Unit(
    input   logic   [31:0]  PrC_4, inst, cdb_data,
    input   logic   [5:0]   cdb_tag,
    input   logic           empty, cdb_b, cdb_b_taken, cdb_va, clk, rst,
    output  logic   [31:0]  jmp_b_addr,
    output  logic           jmp_b_va, rd_en
);

    logic   [4:0]   rd_;
    logic   [5:0]   tag_out_;
    logic           rd_va_;

    assign  rd_en = 1'b1;
    assign  jmp_b_va = 1'b0;

    Register_File   RF      (.clk(clk), .rst(rst), .Rr1(), .Rr2(), .RdAdd(), .rw(), .RdDat(), .Rd1(), .Rd2());
    RST             RST_I   (.clk(clk), .rst(rst), .rs1_add(), .rs2_add(), .rd_add(rd_), .w_data_ena1(), .w_data_ena2(rd_va_), .w_data1(), .w_data2({rd_va_, tag_out_}), .rs1_tag(), .rs2_tag(), .rs1_tag_va(), .rs2_tag_va());
    TAG_FIFO        TF      (.clk(clk), .rst(rst), .rd(rd_), .cdb_tag_va(), .cdb_tag(), .full(), .empty(), .rd_va(rd_va_), .tag_out(tag_out_));
    Dec_Jmp_Bra     DJB     (.inst(inst), .rs1(), .rs2(), .rd(rd_), .funct3(), .funct7(), .opcode(), .r_ena(r_ena_));

endmodule