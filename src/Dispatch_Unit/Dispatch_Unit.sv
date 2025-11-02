module Dispatch_Unit(
    input   logic           clk, rst,

// Input IFQ
    input   logic   [31:0]  ifq_pc4, ifq_inst,
    input   logic           ifq_empty,

// Input CDB
    input   logic   [31:0]  cdb_data,
    input   logic   [5:0]   cdb_tag,
    input   logic           cdb_b, cdb_b_taken, cdb_va,

// Input Issue
    input   logic           issue_full,

// Output to IFQ    
    output  logic   [31:0]  disp_jmp_b_addr,
    output  logic           disp_jmp_b_va, disp_rd_en,

// Output to Issue Queue
    output  logic   [31:0]  disp_rs1_data, disp_rs2_data, disp_imm,
    output  logic   [5:0]   disp_rd_tag, disp_rs1_tag, disp_rs2_tag, 
    output  logic   [9:0]   disp_opcode,
    output  logic   [1:0]   disp_branch,
    output  logic           disp_rs1_tag_va, disp_rs2_tag_va, disp_valid_int
);

// Internal variables
    logic   [31:0]  rs1_data_, rs2_data_, WEROut_, jmp_add_, inst_;
    logic   [5:0]   tag_out_;
    logic   [4:0]   rd_add_, rd_add__, rs1_add_, rs2_add_;
    logic           rd_va_, rs1_tag_va_, rs2_tag_va_, imm_f_, branch_ena_;

// Assigns
    assign  disp_jmp_b_va   = (disp_opcode[9] | cdb_b_taken);
    assign  disp_jmp_b_addr = ~cdb_b ? jmp_add_ : cdb_data;
    assign  disp_rd_tag     = tag_out_;
    assign  disp_rs1_tag_va = (~rs1_tag_va_);
    assign  disp_rs1_data   = (~rs1_tag_va_) ? rs1_data_ : cdb_data;

    // assign  disp_rs2_tag_va = (~rs2_tag_va_);
        assign  disp_rs2_tag_va = disp_opcode[8] ? 1'b1 : (~rs2_tag_va_);

    // assign  disp_rs2_data   = (~rs2_tag_va_) ? rs2_data_ : cdb_data; 
        assign  disp_rs2_data   = disp_opcode[8] ? disp_imm : ((~rs2_tag_va_) ? rs2_data_ : cdb_data); 

    assign  branch_ena_     = (|disp_opcode[7:6]);
    assign  inst_           = disp_rd_en ? ifq_inst : 32'b0;
    assign  disp_valid_int  = ~(|disp_opcode[4:3] | disp_opcode[9]);    // Int queue and not jump
    assign  disp_branch     = disp_opcode[7:6];

// Instancias
    Register_File RF(
    // Inputs
        .clk(clk), .rst(rst),
        .rs1_add(rs1_add_), .rs2_add(rs2_add_), .rd_add(rd_add__), .WEROut(WEROut_), 
    // Outputs
        .rd_data(cdb_data), .rs1_data(rs1_data_), .rs2_data(rs2_data_)
    );

    Dec_Jmp_Bra DJB(
    // Inputs
        .inst(inst_), .pc(ifq_pc4),
    // Outputs
        .rs1_add(rs1_add_), .rs2_add(rs2_add_), .rd_add(rd_add_), .opcode_out(disp_opcode), .imm_f(imm_f_), .se(disp_imm), .jmp_add(jmp_add_)
    );

    Dispatch_Control DC(
    // Inputs
        .clk(clk), .rst(rst),
        .branch_ena(branch_ena_), .cdb_b(cdb_b), .issue_full(1'b0),
    // Outpus 
        .rd_en(disp_rd_en)
    );

    TAG_FIFO TF(
    // Inputs
        .clk(clk), .rst(rst), 
        .rd(rd_add_), .cdb_tag_va(cdb_va), .cdb_tag(cdb_tag), 
    // Outputs
        .full(), .empty(), .rd_va(rd_va_), .tag_out(tag_out_)
    );

    RST RST_I(
    // Inputs
        .clk(clk), .rst(rst), 
        .w_data1({rd_va_, tag_out_}), .cdb_token({cdb_va, cdb_tag}), .rs1_add(rs1_add_), .rs2_add(rs2_add_), .rd_add_in(rd_add_), .w_data_ena1(rd_va_), 
    // Outputs
        .w_ena_2(WEROut_),   .rs1_tag(disp_rs1_tag), .rs2_tag(disp_rs2_tag), .rd_add_out(rd_add__), .rs1_tag_va(rs1_tag_va_), .rs2_tag_va(rs2_tag_va_)
    );



endmodule
