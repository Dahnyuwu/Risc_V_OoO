module Dispatch_Unit(
    input   logic           clk, rst,

// Input IFQ
    input   logic   [31:0]  PrC_4, inst,
    input   logic           empty,

// Output IFQ    
    output  logic   [31:0]  jmp_b_addr,
    output  logic           jmp_b_va, rd_en,

// Input CDB
    input   logic   [31:0]  cdb_data,
    input   logic   [5:0]   cdb_tag,
    input   logic           cdb_b, cdb_b_taken, cdb_va,

// Output Issue Queue
    output  logic   [5:0]   rd_tag, rs1_tag, rs2_tag, 
    output  logic           rs1_tag_va, rs2_tag_va, 
    output  logic   [31:0]  rs1_data, rs2_data,
    output  logic   [2:0]   opcode
);


    logic   [31:0]  rs1_data_, rs2_data_, rs1_data_m_, rs2_data_m_, se_, rs1_data__, rs2_data__, cdb_data_, WEROut_;
    logic   [6:0]   opcode_;
    logic   [5:0]   tag_out_, rs1_tag_, rs2_tag_, rd_tag_;
    logic   [4:0]   rd_add_, rd_add__, rs1_add_, rs2_add_;
    logic           rd_va_, rs1_tag_va_, rs2_tag_va_, rw_rf_, imm_f_;

    assign  rd_en = 1'b1;
    assign  jmp_b_va = 1'b0;

    assign  rs1_data_m_ = (~rs1_tag_va_) ? rs1_data_ : cdb_data;
    assign  rs2_data_m_ = (imm_f_) ? se_ : ((~rs2_tag_va_) ? rs2_data_ : cdb_data); 


    assign  rd_tag  = tag_out_;
    
    assign  rs1_tag = rs1_tag_;
    assign  rs1_tag_va = ~rs1_tag_va_;
    assign  rs1_data   = rs1_data_m_;

    assign  rs2_tag = rs2_tag_;
    assign  rs2_tag_va = ~rs2_tag_va_;
    assign  rs2_data   = rs2_data_m_;

    assign  opcode = opcode_;

    Register_File   RF      (.clk(clk), .rst(rst), .rs1_add(rs1_add_), .rs2_add(rs2_add_), .rd_add(rd_add__), .WEROut(WEROut_), .rd_data(cdb_data), .rs1_data(rs1_data_), .rs2_data(rs2_data_));
    Dec_Jmp_Bra     DJB     (.inst(inst), .rs1_add(rs1_add_), .rs2_add(rs2_add_), .rd_add(rd_add_), .funct3(), .funct7(), .opcode(opcode_), .r_ena(r_ena_), .imm_f(imm_f_), .se(se_));
    TAG_FIFO        TF      (.clk(clk), .rst(rst), .rd(rd_add_), .cdb_tag_va(cdb_va), .cdb_tag(cdb_tag), .full(), .empty(), .rd_va(rd_va_), .tag_out(tag_out_));
    RST             RST_I   (.clk(clk), .rst(rst), .rs1_add(rs1_add_), .rs2_add(rs2_add_), .rd_add_in(rd_add_), .w_data_ena1(rd_va_), .w_ena_2(WEROut_), .cdb_token({cdb_va, cdb_tag}), .w_data1({rd_va_, tag_out_}), .rs1_tag(rs1_tag_), .rs2_tag(rs2_tag_), .rs1_tag_va(rs1_tag_va_), .rs2_tag_va(rs2_tag_va_), .rd_add_out(rd_add__));



endmodule