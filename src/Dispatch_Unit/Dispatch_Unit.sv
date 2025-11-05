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
    output  logic   [2:0]   disp_opcode,
    output  logic   [1:0]   disp_branch,
    output  logic           disp_rs1_tag_va, disp_rs2_tag_va, disp_valid_int, disp_valid_mul, disp_valid_div, disp_valid_ls
);

// Internal variables
    logic   [31:0]  rs1_data_, rs2_data_, WEROut_, jmp_add_, inst_, jmpb_add;
    logic   [9:0]   opcode_;
    logic   [5:0]   tag_out_;
    logic   [4:0]   rd_add_, rd_add__, rs1_add_, rs2_add_;
    logic           rd_va_, rs1_tag_va_, rs2_tag_va_, branch_ena_, rst_wflush;

// Assigns
    assign  rst_wflush = rst & ~disp_jmp_b_va;
    assign  disp_jmp_b_va   = (opcode_[9] | cdb_b_taken);
    assign  disp_jmp_b_addr = ~cdb_b ? jmp_add_ : jmpb_add;
    assign  disp_rd_tag     = tag_out_;
    assign  disp_rs1_tag_va = (cdb_va && disp_rs1_tag == cdb_tag) ? 1'b1: (~rs1_tag_va_);
    assign  disp_rs1_data   = ~|rs1_add_ ? 32'b0 : ((~rs1_tag_va_) ? rs1_data_ : cdb_data);
    assign  disp_opcode     = opcode_[2:0];

    // assign  disp_rs2_tag_va = (~rs2_tag_va_);
        assign  disp_rs2_tag_va = (cdb_va && disp_rs2_tag == cdb_tag) ? 1'b1 : (opcode_[8] ? 1'b1 : (~rs2_tag_va_));

    // assign  disp_rs2_data   = (~rs2_tag_va_) ? rs2_data_ : cdb_data; 
        assign  disp_rs2_data   = opcode_[8] ? disp_imm : ~|rs1_add_ ? 32'b0 : (((~rs2_tag_va_) ? rs2_data_ : cdb_data)); 

        assign  branch_ena_     = (|opcode_[7:6]);
        assign  inst_           = (disp_rd_en || branch_ena_) ? ifq_inst : 32'b0;
        assign  disp_branch     = opcode_[7:6];

    // Issue queue selector
        assign  {disp_valid_int, disp_valid_mul, disp_valid_div, disp_valid_ls}    = (disp_rd_en && {opcode_[9], opcode_[4:3]} == 3'b0_00)                    ?   4'b1000 :       // Int queue
                                                                                     (disp_rd_en && {opcode_[9], opcode_[7:6], opcode_[4:3]} == 5'b0_00_01)   ?   4'b0100 :       // Mul queue
                                                                                     (disp_rd_en && {opcode_[9], opcode_[7:6], opcode_[4:3]} == 5'b0_00_10)   ?   4'b0010 :       // Div queue
                                                                                     (disp_rd_en && {opcode_[9], opcode_[7:6], opcode_[4:3]} == 5'b0_00_11)   ?   4'b0001 :       // SW-LW queue
                                                                                                                                                    4'b0;

// Instancias
    Register_File RF(
    // Inputs
        .clk(clk), .rst(rst),
        .rs1_add(rs1_add_), .rs2_add(rs2_add_), .rd_add(rd_add__), .WEROut(WEROut_), 
    // Outputs
        .rd_data(cdb_data), .rs1_data(rs1_data_), .rs2_data(rs2_data_)
    );

    Register    BJMP(
        .clk(clk), .rst(rst), 
        .in(jmp_add_),  .ena(branch_ena_), 
        .out(jmpb_add));

    Dec_Jmp_Bra DJB(
    // Inputs
        .inst(inst_), .pc(ifq_pc4),
    // Outputs
        .rs1_add(rs1_add_), .rs2_add(rs2_add_), .rd_add(rd_add_), .opcode_out(opcode_), .se(disp_imm), .jmp_add(jmp_add_)
    );

    Dispatch_Control DC(
    // Inputs
        .clk(clk), .rst(rst),
        .branch_ena(branch_ena_), .cdb_b(cdb_b), .issue_full(issue_full),
    // Outpus 
        .rd_en(disp_rd_en)
    );

    TAG_FIFO TF(
    // Inputs
        .clk(clk), .rst(rst_wflush), 
        .rd(rd_add_), .cdb_tag_va(cdb_va), .cdb_tag(cdb_tag), .rd_en(disp_rd_en),
    // Outputs
        .full(), .empty(), .rd_va(rd_va_), .tag_out(tag_out_)
    );

    RST RST_I(
    // Inputs
        .clk(clk), .rst(rst_wflush), 
        .w_data1({rd_va_, tag_out_}), .cdb_token({cdb_va, cdb_tag}), .rs1_add(rs1_add_), .rs2_add(rs2_add_), .rd_add_in(rd_add_), .w_data_ena1(rd_va_), 
    // Outputs
        .w_ena_2(WEROut_),   .rs1_tag(disp_rs1_tag), .rs2_tag(disp_rs2_tag), .rd_add_out(rd_add__), .rs1_tag_va(rs1_tag_va_), .rs2_tag_va(rs2_tag_va_)
    );



endmodule
