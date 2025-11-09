module Issue_Queue_LS(
    input   logic           clk, rst,
// Input Dispatcher
    input   logic   [31:0]  disp_rs1_data, disp_rs2_data, disp_imm,
    input   logic   [5:0]   disp_rs1_tag, disp_rs2_tag, disp_rd_tag,
    input   logic           disp_opcode,
    input   logic   [1:0]   disp_branch,
    input   logic           disp_rs1_tag_va, disp_rs2_tag_va, disp_valid,

// Input CDB
    input   logic   [31:0]  cdb_data,
    input   logic   [5:0]   cdb_tag,
    input   logic           cdb_va,

// Input Issue unit
    input   logic           i_unit_take,

// Output to Dispatcher
    output  logic           issue_full,

// Output to CDB
    output  logic   [31:0]  issue_rs1, issue_rs2, issue_addr,
    output  logic   [5:0]   issue_rd_tag,
    output  logic           issue_opcode,
    output  logic           issue_va
);

// Immediate Data in/out
    logic   [31:0]  imm_in3_, imm_in2_, imm_in1_, imm_in0_;
    logic   [31:0]  imm_out3_, imm_out2_, imm_out1_, imm_out0_;

// Address Data in/out
    logic   [31:0]  addr_in3_, addr_in2_, addr_in1_, addr_in0_;
    logic   [31:0]  addr_out3_, addr_out2_, addr_out1_, addr_out0_;

// RS1 Data in/out
    logic   [31:0]  rs1_data_in3_, rs1_data_in2_, rs1_data_in1_, rs1_data_in0_;
    logic   [31:0]  rs1_data_out3_, rs1_data_out2_, rs1_data_out1_, rs1_data_out0_;

// RS1 va in/out
    logic           rs1_va_in3_, rs1_va_in2_, rs1_va_in1_, rs1_va_in0_;
    logic           rs1_va_out3_, rs1_va_out2_, rs1_va_out1_, rs1_va_out0_;

// RS2 Data in/out
    logic   [31:0]  rs2_data_in3_, rs2_data_in2_, rs2_data_in1_, rs2_data_in0_;
    logic   [31:0]  rs2_data_out3_, rs2_data_out2_, rs2_data_out1_, rs2_data_out0_;

// RS2 va in/out
    logic           rs2_va_in3_, rs2_va_in2_, rs2_va_in1_, rs2_va_in0_;
    logic           rs2_va_out3_, rs2_va_out2_, rs2_va_out1_, rs2_va_out0_;

// RS1 TAG in/out
    logic   [5:0]   rs1_tag_out3_, rs1_tag_out2_, rs1_tag_out1_, rs1_tag_out0_;

// RS2 TAG in/out
    logic   [5:0]   rs2_tag_out3_, rs2_tag_out2_, rs2_tag_out1_, rs2_tag_out0_;

// Opcode out
    logic           opcode_out3_, opcode_out2_, opcode_out1_, opcode_out0_;

// Valid out
    logic           valid_out3_, valid_out2_, valid_out1_, valid_out0_;

// RD TAG out
    logic   [5:0]   rd_tag_out3_, rd_tag_out2_, rd_tag_out1_, rd_tag_out0_;

// RS ready
    logic           rs3_ready_, rs2_ready_, rs1_ready_, rs0_ready_;

// Enables
    logic           s_ena3_, u_ena3_, s_ena2_, u_ena2_, s_ena1_, u_ena1_, s_ena0_, u_ena0_, rst3_, rst2_, rst1_, rst0_;

// Dont care value
    logic   [31:0]  dONTCARE_;
    assign          dONTCARE_ = 32'b0;

// RS ready detector
    assign  rs3_ready_ = (rs1_va_out3_ && rs2_va_out3_ && valid_out3_) ? 1'b1 : 1'b0;
    assign  rs2_ready_ = (rs1_va_out2_ && rs2_va_out2_ && valid_out2_) ? 1'b1 : 1'b0;
    assign  rs1_ready_ = (rs1_va_out1_ && rs2_va_out1_ && valid_out1_) ? 1'b1 : 1'b0;
    assign  rs0_ready_ = (rs1_va_out0_ && rs2_va_out0_ && valid_out0_) ? 1'b1 : 1'b0;

// Full detector
    assign  issue_full = (valid_out3_ & valid_out2_ & valid_out1_ & valid_out0_ & ~i_unit_take);        // Falta agregar lo de done xd

//  RS data selector
    assign  {issue_opcode, issue_rd_tag, issue_rs1, issue_rs2, issue_addr, issue_va} =  (rs0_ready_)    ? {opcode_out0_, rd_tag_out0_, rs1_data_out0_, rs2_data_out0_, addr_out0_, rs0_ready_} :
                                                                                    (rs1_ready_)    ? {opcode_out1_, rd_tag_out1_, rs1_data_out1_, rs2_data_out1_, addr_out1_, rs1_ready_} :
                                                                                    (rs2_ready_)    ? {opcode_out2_, rd_tag_out2_, rs1_data_out2_, rs2_data_out2_, addr_out2_, rs2_ready_} :
                                                                                    (rs3_ready_)    ? {opcode_out3_, rd_tag_out3_, rs1_data_out3_, rs2_data_out3_, addr_out3_, rs3_ready_} :
                                                                                                    106'b0;


// Update and shift sr3
    assign  {rs1_va_in3_, rs1_data_in3_, rs2_va_in3_, rs2_data_in3_, s_ena3_, u_ena3_} =    ({disp_valid, cdb_va} == 2'b00) ? {dONTCARE_[0], dONTCARE_, dONTCARE_[0], dONTCARE_, 2'b00}                                                                                     :       // Keep

                                                                                            ({disp_valid, cdb_va} == 2'b01) ? ((((~rs1_va_out3_) && (rs1_tag_out3_ == cdb_tag)) && (~rs2_va_out3_) && (rs2_tag_out3_ == cdb_tag))   ? {cdb_va, cdb_data, cdb_va, cdb_data, 2'b01}                               :           // Update Rs1, Rs2
                                                                                                                                    ((~rs1_va_out3_) && (rs1_tag_out3_ == cdb_tag))                                                     ? {cdb_va, cdb_data, rs2_va_out3_, rs2_data_out3_, 2'b01}                   :           // Update Rs1
                                                                                                                                    ((~rs2_va_out3_) && (rs2_tag_out3_ == cdb_tag))                                                     ? {rs1_va_out3_, rs1_data_out3_, cdb_va, cdb_data, 2'b01}                   :           // Update Rs2
                                                                                                                                                                                                                                          {dONTCARE_[0], dONTCARE_, dONTCARE_[0], dONTCARE_, 2'b00})                    :       // Keep (No TAG match)

                                                                                            ({disp_valid, cdb_va} == 2'b10) ? ((~issue_full)                                                ? {disp_rs1_tag_va, disp_rs1_data, disp_rs2_tag_va, disp_rs2_data, 2'b11}   :           // Shift SR3
                                                                                                                                                                                                  {dONTCARE_[0], dONTCARE_, dONTCARE_[0], dONTCARE_, 2'b00})                    :       // Keep (No space to shift)

                                                                                            ({disp_valid, cdb_va} == 2'b11) ? ((~issue_full)                                                ? ((((~rs1_va_out3_) && (rs1_tag_out3_ == cdb_tag)) && (~rs2_va_out3_) && (rs2_tag_out3_ == cdb_tag))       ? {cdb_va, cdb_data, cdb_va, cdb_data, 2'b11}                                :           // Update Rs1, Rs2
                                                                                                                                                                                                    ((~rs1_va_out3_) && (rs1_tag_out3_ == cdb_tag))                                                         ? {cdb_va, cdb_data, disp_rs2_tag_va, disp_rs2_data, 2'b11}                  :           // Shift and Update Rs1
                                                                                                                                                                                                    ((~rs2_va_out3_) && (rs2_tag_out3_ == cdb_tag))                                                         ? {disp_rs1_tag_va, disp_rs1_data, cdb_va, cdb_data, 2'b11}                  :           // Shift and Update Rs2
                                                                                                                                                                                                                                                                                                              {disp_rs1_tag_va, disp_rs1_data, disp_rs2_tag_va, disp_rs2_data, 2'b11})    : 
                                                                                                                                
                                                                                                                                                                                                  ((((~rs1_va_out3_) && (rs1_tag_out3_ == cdb_tag)) && (~rs2_va_out3_) && (rs2_tag_out3_ == cdb_tag))      ? {cdb_va, cdb_data, cdb_va, cdb_data, 2'b01}                              :             // Update Rs1, Rs2
                                                                                                                                                                                                    ((~rs1_va_out3_) && (rs1_tag_out3_ == cdb_tag))                                                        ? {cdb_va, cdb_data, rs2_va_out3_, rs2_data_out3_, 2'b01}                  :             // Update and Update Rs1
                                                                                                                                                                                                    ((~rs2_va_out3_) && (rs2_tag_out3_ == cdb_tag))                                                        ? {rs1_va_out3_, rs1_data_out3_, cdb_va, cdb_data, 2'b01}                  :             // Update and Update Rs2
                                                                                                                                                                                                                                                                                                             {dONTCARE_[0], dONTCARE_, dONTCARE_[0], dONTCARE_, 2'b00})): 68'b0;

// Update and shift sr2
    assign  {rs1_va_in2_, rs1_data_in2_, rs2_va_in2_, rs2_data_in2_, s_ena2_, u_ena2_} =    ({disp_valid, cdb_va} == 2'b00) ? {dONTCARE_[0], dONTCARE_, dONTCARE_[0], dONTCARE_, 2'b00}                                                                                     :       // Keep

                                                                                            ({disp_valid, cdb_va} == 2'b01) ? ((((~rs1_va_out2_) && (rs1_tag_out2_ == cdb_tag)) && (~rs2_va_out2_) && (rs2_tag_out2_ == cdb_tag))   ? {cdb_va, cdb_data, cdb_va, cdb_data, 2'b01}                               :           // Update Rs1, Rs2
                                                                                                                                    ((~rs1_va_out2_) && (rs1_tag_out2_ == cdb_tag))                                                     ? {cdb_va, cdb_data, rs2_va_out2_, rs2_data_out2_, 2'b01}                   :           // Update Rs1
                                                                                                                                    ((~rs2_va_out2_) && (rs2_tag_out2_ == cdb_tag))                                                     ? {rs1_va_out2_, rs1_data_out2_, cdb_va, cdb_data, 2'b01}                   :           // Update Rs2
                                                                                                                                                                                                                                          {dONTCARE_[0], dONTCARE_, dONTCARE_[0], dONTCARE_, 2'b00})                    :       // Keep (No TAG match)

                                                                                            ({disp_valid, cdb_va} == 2'b10) ? ((~&(valid_out2_ & valid_out1_ & valid_out0_))                ? {rs1_va_out3_, rs1_data_out3_, rs2_va_out3_, rs2_data_out3_, 2'b11}               :           // Shift SR2
                                                                                                                                                                                                  {dONTCARE_[0], dONTCARE_, dONTCARE_[0], dONTCARE_, 2'b00})                    :       // Keep (No space to shift)

                                                                                            ({disp_valid, cdb_va} == 2'b11) ? ((~&(valid_out2_ & valid_out1_ & valid_out0_))                ? ((((~rs1_va_out2_) && (rs1_tag_out2_ == cdb_tag)) && (~rs2_va_out2_) && (rs2_tag_out2_ == cdb_tag))       ? {cdb_va, cdb_data, cdb_va, cdb_data, 2'b11}                                :           // Update Rs1, Rs2
                                                                                                                                                                                                    ((~rs1_va_out2_) && (rs1_tag_out2_ == cdb_tag))                                                         ? {cdb_va, cdb_data, rs2_va_out3_, rs2_data_out3_, 2'b11}                  :           // Shift and Update Rs1
                                                                                                                                                                                                    ((~rs2_va_out2_) && (rs2_tag_out2_ == cdb_tag))                                                         ? {rs1_va_out3_, rs1_data_out3_, cdb_va, cdb_data, 2'b11}                  :           // Shift and Update Rs2
                                                                                                                                                                                                                                                                                                              {rs1_va_out3_, rs1_data_out3_, rs2_va_out3_, rs2_data_out3_, 2'b11})    : 
                                                                                                                                
                                                                                                                                                                                                  ((((~rs1_va_out2_) && (rs1_tag_out2_ == cdb_tag)) && (~rs2_va_out2_) && (rs2_tag_out2_ == cdb_tag))      ? {cdb_va, cdb_data, cdb_va, cdb_data, 2'b01}                              :             // Update Rs1, Rs2
                                                                                                                                                                                                    ((~rs1_va_out2_) && (rs1_tag_out2_ == cdb_tag))                                                        ? {cdb_va, cdb_data, rs2_va_out2_, rs2_data_out2_, 2'b01}                  :             // Update and Update Rs1
                                                                                                                                                                                                    ((~rs2_va_out2_) && (rs2_tag_out2_ == cdb_tag))                                                        ? {rs1_va_out2_, rs1_data_out2_, cdb_va, cdb_data, 2'b01}                  :             // Update and Update Rs2
                                                                                                                                                                                                                                                                                                             {dONTCARE_[0], dONTCARE_, dONTCARE_[0], dONTCARE_, 2'b00})): 68'b0;

// Update and shift sr1
    assign  {rs1_va_in1_, rs1_data_in1_, rs2_va_in1_, rs2_data_in1_, s_ena1_, u_ena1_} =    ({disp_valid, cdb_va} == 2'b00) ? {dONTCARE_[0], dONTCARE_, dONTCARE_[0], dONTCARE_, 2'b00}                                                                                     :       // Keep

                                                                                            ({disp_valid, cdb_va} == 2'b01) ? ((((~rs1_va_out1_) && (rs1_tag_out1_ == cdb_tag)) && (~rs2_va_out1_) && (rs2_tag_out1_ == cdb_tag))   ? {cdb_va, cdb_data, cdb_va, cdb_data, 2'b01}                               :           // Update Rs1, Rs2
                                                                                                                                    ((~rs1_va_out1_) && (rs1_tag_out1_ == cdb_tag))                                                     ? {cdb_va, cdb_data, rs2_va_out1_, rs2_data_out1_, 2'b01}                   :           // Update Rs1
                                                                                                                                    ((~rs2_va_out1_) && (rs2_tag_out1_ == cdb_tag))                                                     ? {rs1_va_out1_, rs1_data_out1_, cdb_va, cdb_data, 2'b01}                   :           // Update Rs2
                                                                                                                                                                                                                                          {dONTCARE_[0], dONTCARE_, dONTCARE_[0], dONTCARE_, 2'b00})                    :       // Keep (No TAG match)

                                                                                            ({disp_valid, cdb_va} == 2'b10) ? ((~&(valid_out1_ & valid_out0_))                ? {rs1_va_out2_, rs1_data_out2_, rs2_va_out2_, rs2_data_out2_, 2'b11}               :           // Shift SR1
                                                                                                                                                                                                  {dONTCARE_[0], dONTCARE_, dONTCARE_[0], dONTCARE_, 2'b00})                    :       // Keep (No space to shift)

                                                                                            ({disp_valid, cdb_va} == 2'b11) ? ((~&(valid_out1_ & valid_out0_))                ? ((((~rs1_va_out1_) && (rs1_tag_out1_ == cdb_tag)) && (~rs2_va_out1_) && (rs2_tag_out1_ == cdb_tag))       ? {cdb_va, cdb_data, cdb_va, cdb_data, 2'b11}                                :           // Update Rs1, Rs2
                                                                                                                                                                                                    ((~rs1_va_out1_) && (rs1_tag_out1_ == cdb_tag))                                                         ? {cdb_va, cdb_data, rs2_va_out2_, rs2_data_out2_, 2'b11}                  :           // Shift and Update Rs1
                                                                                                                                                                                                    ((~rs2_va_out1_) && (rs2_tag_out1_ == cdb_tag))                                                         ? {rs1_va_out2_, rs1_data_out2_, cdb_va, cdb_data, 2'b11}                  :           // Shift and Update Rs2
                                                                                                                                                                                                                                                                                                              {rs1_va_out2_, rs1_data_out2_, rs2_va_out2_, rs2_data_out2_, 2'b11})    : 
                                                                                                                                
                                                                                                                                                                                                  ((((~rs1_va_out1_) && (rs1_tag_out1_ == cdb_tag)) && (~rs2_va_out1_) && (rs2_tag_out1_ == cdb_tag))      ? {cdb_va, cdb_data, cdb_va, cdb_data, 2'b01}                              :             // Update Rs1, Rs2
                                                                                                                                                                                                    ((~rs1_va_out1_) && (rs1_tag_out1_ == cdb_tag))                                                        ? {cdb_va, cdb_data, rs2_va_out1_, rs2_data_out1_, 2'b01}                  :             // Update and Update Rs1
                                                                                                                                                                                                    ((~rs2_va_out1_) && (rs2_tag_out1_ == cdb_tag))                                                        ? {rs1_va_out1_, rs1_data_out1_, cdb_va, cdb_data, 2'b01}                  :             // Update and Update Rs2
                                                                                                                                                                                                                                                                                                             {dONTCARE_[0], dONTCARE_, dONTCARE_[0], dONTCARE_, 2'b00})): 68'b0;

// Update and shift sr0
    assign  {rs1_va_in0_, rs1_data_in0_, rs2_va_in0_, rs2_data_in0_, s_ena0_, u_ena0_} =    ({disp_valid, cdb_va} == 2'b00) ? {dONTCARE_[0], dONTCARE_, dONTCARE_[0], dONTCARE_, 2'b00}                                                                                     :       // Keep

                                                                                            ({disp_valid, cdb_va} == 2'b01) ? ((((~rs1_va_out0_) && (rs1_tag_out0_ == cdb_tag)) && (~rs2_va_out0_) && (rs2_tag_out0_ == cdb_tag))   ? {cdb_va, cdb_data, cdb_va, cdb_data, 2'b01}                               :           // Update Rs1, Rs2
                                                                                                                                    ((~rs1_va_out0_) && (rs1_tag_out0_ == cdb_tag))                                                     ? {cdb_va, cdb_data, rs2_va_out0_, rs2_data_out0_, 2'b01}                   :           // Update Rs1
                                                                                                                                    ((~rs2_va_out0_) && (rs2_tag_out0_ == cdb_tag))                                                     ? {rs1_va_out0_, rs1_data_out0_, cdb_va, cdb_data, 2'b01}                   :           // Update Rs2
                                                                                                                                                                                                                                          {dONTCARE_[0], dONTCARE_, dONTCARE_[0], dONTCARE_, 2'b00})                    :       // Keep (No TAG match)

                                                                                            ({disp_valid, cdb_va} == 2'b10) ? ((~valid_out0_)                ? {rs1_va_out1_, rs1_data_out1_, rs2_va_out1_, rs2_data_out1_, 2'b11}               :           // Shift SR1
                                                                                                                                                                                                  {dONTCARE_[0], dONTCARE_, dONTCARE_[0], dONTCARE_, 2'b00})                    :       // Keep (No space to shift)

                                                                                            ({disp_valid, cdb_va} == 2'b11) ? ((~valid_out0_)                ? ((((~rs1_va_out0_) && (rs1_tag_out0_ == cdb_tag)) && (~rs2_va_out0_) && (rs2_tag_out0_ == cdb_tag))       ? {cdb_va, cdb_data, cdb_va, cdb_data, 2'b11}                                :           // Update Rs1, Rs2
                                                                                                                                                                                                    ((~rs1_va_out0_) && (rs1_tag_out0_ == cdb_tag))                                                         ? {cdb_va, cdb_data, rs2_va_out1_, rs2_data_out1_, 2'b11}                  :           // Shift and Update Rs1
                                                                                                                                                                                                    ((~rs2_va_out0_) && (rs2_tag_out0_ == cdb_tag))                                                         ? {rs1_va_out1_, rs1_data_out1_, cdb_va, cdb_data, 2'b11}                  :           // Shift and Update Rs2
                                                                                                                                                                                                                                                                                                              {rs1_va_out1_, rs1_data_out1_, rs2_va_out1_, rs2_data_out1_, 2'b11})    : 
                                                                                                                                
                                                                                                                                                                                                  ((((~rs1_va_out0_) && (rs1_tag_out0_ == cdb_tag)) && (~rs2_va_out0_) && (rs2_tag_out0_ == cdb_tag))      ? {cdb_va, cdb_data, cdb_va, cdb_data, 2'b01}                              :             // Update Rs1, Rs2
                                                                                                                                                                                                    ((~rs1_va_out0_) && (rs1_tag_out0_ == cdb_tag))                                                        ? {cdb_va, cdb_data, rs2_va_out0_, rs2_data_out0_, 2'b01}                  :             // Update and Update Rs1
                                                                                                                                                                                                    ((~rs2_va_out0_) && (rs2_tag_out0_ == cdb_tag))                                                        ? {rs1_va_out0_, rs1_data_out0_, cdb_va, cdb_data, 2'b01}                  :             // Update and Update Rs2
                                                                                                                                                                                                                                                                                                             {dONTCARE_[0], dONTCARE_, dONTCARE_[0], dONTCARE_, 2'b00})): 68'b0;

// Clear completed queues
    assign  rst3_ = (i_unit_take && valid_out3_ && rs1_va_out3_ && rs2_va_out3_ && ~disp_valid)             ? 1'b0: 1'b1;
    assign  rst2_ = (i_unit_take && valid_out2_ && rs1_va_out2_ && rs2_va_out2_ && ~disp_valid) ||  rst3_   ? 1'b0: 1'b1;
    assign  rst1_ = (i_unit_take && valid_out1_ && rs1_va_out1_ && rs2_va_out1_ && ~disp_valid) ||  rst2_   ? 1'b0: 1'b1;
    assign  rst0_ = (i_unit_take && valid_out0_ && rs1_va_out0_ && rs2_va_out0_ && ~disp_valid) ||  rst1_   ? 1'b0: 1'b1;
// Addr
    assign  addr_in3_ = disp_valid ? (disp_rs1_data + disp_imm) : (rs1_data_out3_ + imm_out3_);
    assign  addr_in2_ = disp_valid ? (rs1_data_out3_ + imm_out3_) : (rs1_data_out2_ + imm_out2_);
    assign  addr_in1_ = disp_valid ? (rs1_data_out2_ + imm_out2_) : (rs1_data_out1_ + imm_out1_);
    assign  addr_in0_ = disp_valid ? (rs1_data_out1_ + imm_out1_) : (rs1_data_out0_ + imm_out0_);

// Issue queues
    Shift_Register_LW  SR3 (
    // Inputs
        .clk(clk), .rst(rst), .arst(rst && rst3_),
        .s_ena(s_ena3_ & (cdb_va || disp_valid)), .u_ena(u_ena3_ && (cdb_va || disp_valid)), .imm_in(disp_imm), .addr_in(addr_in3_), .opcode_in(disp_opcode), .rd_tag_in(disp_rd_tag), .rs1_tag_in(disp_rs1_tag), .rs1_data_in(rs1_data_in3_), .rs1_va_in(rs1_va_in3_), .rs2_tag_in(disp_rs2_tag), .rs2_data_in(rs2_data_in3_), .rs2_va_in(rs2_va_in3_), .valid_in(disp_valid),
    // Outputs
       .imm_out(imm_out3_), .addr_out(addr_out3_), .opcode_out(opcode_out3_), .rd_tag_out(rd_tag_out3_), .rs1_tag_out(rs1_tag_out3_), .rs1_data_out(rs1_data_out3_), .rs1_va_out(rs1_va_out3_), .rs2_tag_out(rs2_tag_out3_), .rs2_data_out(rs2_data_out3_), .rs2_va_out(rs2_va_out3_), .valid_out(valid_out3_)
    );

    Shift_Register_LW  SR2 (
    // Inputs
        .clk(clk), .rst(rst), .arst(rst && rst2_),
        .s_ena(s_ena2_), .u_ena(u_ena2_), .imm_in(imm_out3_), .addr_in(addr_in2_), .opcode_in(opcode_out3_), .rd_tag_in(rd_tag_out3_), .rs1_tag_in(rs1_tag_out3_), .rs1_data_in(rs1_data_in2_), .rs1_va_in(rs1_va_in2_), .rs2_tag_in(rs2_tag_out3_), .rs2_data_in(rs2_data_in2_), .rs2_va_in(rs2_va_in2_), .valid_in(valid_out3_),
    // Outputs
       .imm_out(imm_out2_), .addr_out(addr_out2_), .opcode_out(opcode_out2_), .rd_tag_out(rd_tag_out2_), .rs1_tag_out(rs1_tag_out2_), .rs1_data_out(rs1_data_out2_), .rs1_va_out(rs1_va_out2_), .rs2_tag_out(rs2_tag_out2_), .rs2_data_out(rs2_data_out2_), .rs2_va_out(rs2_va_out2_), .valid_out(valid_out2_)
    );

    Shift_Register_LW  SR1 (
    // Inputs
        .clk(clk), .rst(rst), .arst(rst && rst1_),
        .s_ena(s_ena1_), .u_ena(u_ena1_), .imm_in(imm_out2_), .addr_in(addr_in1_), .opcode_in(opcode_out2_), .rd_tag_in(rd_tag_out2_), .rs1_tag_in(rs1_tag_out2_), .rs1_data_in(rs1_data_in1_), .rs1_va_in(rs1_va_in1_), .rs2_tag_in(rs2_tag_out2_), .rs2_data_in(rs2_data_in1_), .rs2_va_in(rs2_va_in1_), .valid_in(valid_out2_),
    // Outputs
       .imm_out(imm_out1_), .addr_out(addr_out1_), .opcode_out(opcode_out1_), .rd_tag_out(rd_tag_out1_), .rs1_tag_out(rs1_tag_out1_), .rs1_data_out(rs1_data_out1_), .rs1_va_out(rs1_va_out1_), .rs2_tag_out(rs2_tag_out1_), .rs2_data_out(rs2_data_out1_), .rs2_va_out(rs2_va_out1_), .valid_out(valid_out1_)
    );

    Shift_Register_LW  SR0 (
    // Inputs
        .clk(clk), .rst(rst), .arst(rst && rst0_),
        .s_ena(s_ena0_), .u_ena(u_ena0_), .imm_in(imm_out1_), .addr_in(addr_in0_), .opcode_in(opcode_out1_), .rd_tag_in(rd_tag_out1_), .rs1_tag_in(rs1_tag_out1_), .rs1_data_in(rs1_data_in0_), .rs1_va_in(rs1_va_in0_), .rs2_tag_in(rs2_tag_out1_), .rs2_data_in(rs2_data_in0_), .rs2_va_in(rs2_va_in0_), .valid_in(valid_out1_),
    // Outputs
       .imm_out(imm_out0_), .addr_out(addr_out0_), .opcode_out(opcode_out0_), .rd_tag_out(rd_tag_out0_), .rs1_tag_out(rs1_tag_out0_), .rs1_data_out(rs1_data_out0_), .rs1_va_out(rs1_va_out0_), .rs2_tag_out(rs2_tag_out0_), .rs2_data_out(rs2_data_out0_), .rs2_va_out(rs2_va_out0_), .valid_out(valid_out0_)
    );



endmodule