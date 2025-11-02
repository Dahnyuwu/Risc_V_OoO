module Issue_Queue(
    input   logic           clk, rst,
// Input Dispatcher
    input   logic   [31:0]  disp_rs1_data, disp_rs2_data,
    input   logic   [5:0]   disp_rs1_tag, disp_rs2_tag, disp_rd_tag,
    input   logic   [2:0]   disp_opcode,
    input   logic   [1:0]   disp_branch,
    input   logic           disp_rs1_tag_va, disp_rs2_tag_va, disp_valid_int,

// Input CDB
    input   logic   [31:0]  cdb_data,
    input   logic   [5:0]   cdb_tag,
    input   logic           cdb_va,

// Output to Dispatcher
    output  logic           issue_full,

// Output to CDB
    output  logic   [31:0]  issue_a, issue_b,
    output  logic   [5:0]   issue_rd_tag,
    output  logic   [2:0]   issue_opcode
);

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
    logic   [2:0]   opcode_out3_, opcode_out2_, opcode_out1_, opcode_out0_;

// Valid out
    logic           valid_out3_, valid_out2_, valid_out1_, valid_out0_;

// RD TAG out
    logic   [5:0]   rd_tag_out3_, rd_tag_out2_, rd_tag_out1_, rd_tag_out0_;

// RS ready
    logic           rs3_ready_, rs2_ready_, rs1_ready_, rs0_ready_;

// Enables
    logic           s_ena3_, u_ena3_, s_ena2_, u_ena2_, s_ena1_, u_ena1_, s_ena0_, u_ena0_;

// Dont care value
    logic   [31:0]  dONTCARE_;
    assign          dONTCARE_ = 32'b0;

// RS ready detector
    assign  rs3_ready_ = (rs1_va_out3_ && rs2_va_out3_ & valid_out3_) ? 1'b1 : 1'b0;
    assign  rs2_ready_ = (rs1_va_out2_ && rs2_va_out2_ & valid_out2_) ? 1'b1 : 1'b0;
    assign  rs1_ready_ = (rs1_va_out1_ && rs2_va_out1_ & valid_out1_) ? 1'b1 : 1'b0;
    assign  rs0_ready_ = (rs1_va_out0_ && rs2_va_out0_ & valid_out0_) ? 1'b1 : 1'b0;

// Full detector
    assign  issue_full = (valid_out3_ & valid_out2_ & valid_out1_ & valid_out0_);        // Falta agregar lo de done xd

//  RS data selector
    assign  {issue_opcode, issue_rd_tag, issue_a, issue_b} =    ({rs3_ready_, rs2_ready_, rs1_ready_, rs0_ready_} == 4'b0001) ? {opcode_out0_, rd_tag_out0_, rs1_data_out0_, rs2_data_out0_} :
                                                                ({rs3_ready_, rs2_ready_, rs1_ready_, rs0_ready_} == 4'b0010) ? {opcode_out1_, rd_tag_out1_, rs1_data_out1_, rs2_data_out1_} :
                                                                ({rs3_ready_, rs2_ready_, rs1_ready_, rs0_ready_} == 4'b0100) ? {opcode_out2_, rd_tag_out2_, rs1_data_out2_, rs2_data_out2_} :
                                                                ({rs3_ready_, rs2_ready_, rs1_ready_, rs0_ready_} == 4'b1000) ? {opcode_out3_, rd_tag_out3_, rs1_data_out3_, rs2_data_out3_} :
                                                                                                                                73'b0;


// Update and shift sr3
    assign  {rs1_va_in3_, rs1_data_in3_, rs2_va_in3_, rs2_data_in3_, s_ena3_, u_ena3_} =    ({disp_valid_int, cdb_va} == 2'b00) ? {dONTCARE_[0], dONTCARE_, dONTCARE_[0], dONTCARE_, 2'b00}                                                                                     :       // Keep

                                                                                            ({disp_valid_int, cdb_va} == 2'b01) ? ((((~rs1_va_out3_) && (rs1_tag_out3_ == cdb_tag)) && (~rs2_va_out3_) && (rs2_tag_out3_ == cdb_tag))   ? {cdb_va, cdb_data, cdb_va, cdb_data, 2'b01}                               :           // Update Rs1, Rs2
                                                                                                                                    ((~rs1_va_out3_) && (rs1_tag_out3_ == cdb_tag))                                                     ? {cdb_va, cdb_data, rs2_va_out3_, rs2_data_out3_, 2'b01}                   :           // Update Rs1
                                                                                                                                    ((~rs2_va_out3_) && (rs2_tag_out3_ == cdb_tag))                                                     ? {rs1_va_out3_, rs1_data_out3_, cdb_va, cdb_data, 2'b01}                   :           // Update Rs2
                                                                                                                                                                                                                                          {dONTCARE_[0], dONTCARE_, dONTCARE_[0], dONTCARE_, 2'b00})                    :       // Keep (No TAG match)

                                                                                            ({disp_valid_int, cdb_va} == 2'b10) ? ((~issue_full)                                                ? {disp_rs1_tag_va, disp_rs1_data, disp_rs2_tag_va, disp_rs2_data, 2'b11}   :           // Shift SR3
                                                                                                                                                                                                  {dONTCARE_[0], dONTCARE_, dONTCARE_[0], dONTCARE_, 2'b00})                    :       // Keep (No space to shift)

                                                                                            ({disp_valid_int, cdb_va} == 2'b11) ? ((~issue_full)                                                ? ((((~rs1_va_out3_) && (rs1_tag_out3_ == cdb_tag)) && (~rs2_va_out3_) && (rs2_tag_out3_ == cdb_tag))       ? {cdb_va, cdb_data, cdb_va, cdb_data, 2'b11}                                :           // Update Rs1, Rs2
                                                                                                                                                                                                    ((~rs1_va_out3_) && (rs1_tag_out3_ == cdb_tag))                                                         ? {cdb_va, cdb_data, disp_rs2_tag_va, disp_rs2_data, 2'b11}                  :           // Shift and Update Rs1
                                                                                                                                                                                                    ((~rs2_va_out3_) && (rs2_tag_out3_ == cdb_tag))                                                         ? {disp_rs1_tag_va, disp_rs1_data, cdb_va, cdb_data, 2'b11}                  :           // Shift and Update Rs2
                                                                                                                                                                                                                                                                                                              {disp_rs1_tag_va, disp_rs1_data, disp_rs2_tag_va, disp_rs2_data, 2'b11})    : 
                                                                                                                                
                                                                                                                                                                                                  ((((~rs1_va_out3_) && (rs1_tag_out3_ == cdb_tag)) && (~rs2_va_out3_) && (rs2_tag_out3_ == cdb_tag))      ? {cdb_va, cdb_data, cdb_va, cdb_data, 2'b01}                              :             // Update Rs1, Rs2
                                                                                                                                                                                                    ((~rs1_va_out3_) && (rs1_tag_out3_ == cdb_tag))                                                        ? {cdb_va, cdb_data, rs2_va_out3_, rs2_data_out3_, 2'b01}                  :             // Update and Update Rs1
                                                                                                                                                                                                    ((~rs2_va_out3_) && (rs2_tag_out3_ == cdb_tag))                                                        ? {rs1_va_out3_, rs1_data_out3_, cdb_va, cdb_data, 2'b01}                  :             // Update and Update Rs2
                                                                                                                                                                                                                                                                                                             {dONTCARE_[0], dONTCARE_, dONTCARE_[0], dONTCARE_, 2'b00})): 68'b0;

// Update and shift sr2
    assign  {rs1_va_in2_, rs1_data_in2_, rs2_va_in2_, rs2_data_in2_, s_ena2_, u_ena2_} =    ({disp_valid_int, cdb_va} == 2'b00) ? {dONTCARE_[0], dONTCARE_, dONTCARE_[0], dONTCARE_, 2'b00}                                                                                     :       // Keep

                                                                                            ({disp_valid_int, cdb_va} == 2'b01) ? ((((~rs1_va_out2_) && (rs1_tag_out2_ == cdb_tag)) && (~rs2_va_out2_) && (rs2_tag_out2_ == cdb_tag))   ? {cdb_va, cdb_data, cdb_va, cdb_data, 2'b01}                               :           // Update Rs1, Rs2
                                                                                                                                    ((~rs1_va_out2_) && (rs1_tag_out2_ == cdb_tag))                                                     ? {cdb_va, cdb_data, rs2_va_out2_, rs2_data_out2_, 2'b01}                   :           // Update Rs1
                                                                                                                                    ((~rs2_va_out2_) && (rs2_tag_out2_ == cdb_tag))                                                     ? {rs1_va_out2_, rs1_data_out2_, cdb_va, cdb_data, 2'b01}                   :           // Update Rs2
                                                                                                                                                                                                                                          {dONTCARE_[0], dONTCARE_, dONTCARE_[0], dONTCARE_, 2'b00})                    :       // Keep (No TAG match)

                                                                                            ({disp_valid_int, cdb_va} == 2'b10) ? ((~&(valid_out2_ & valid_out1_ & valid_out0_))                ? {rs1_va_out3_, rs1_data_out3_, rs2_va_out3_, rs2_data_out3_, 2'b11}               :           // Shift SR2
                                                                                                                                                                                                  {dONTCARE_[0], dONTCARE_, dONTCARE_[0], dONTCARE_, 2'b00})                    :       // Keep (No space to shift)

                                                                                            ({disp_valid_int, cdb_va} == 2'b11) ? ((~&(valid_out2_ & valid_out1_ & valid_out0_))                ? ((((~rs1_va_out2_) && (rs1_tag_out2_ == cdb_tag)) && (~rs2_va_out2_) && (rs2_tag_out2_ == cdb_tag))       ? {cdb_va, cdb_data, cdb_va, cdb_data, 2'b11}                                :           // Update Rs1, Rs2
                                                                                                                                                                                                    ((~rs1_va_out2_) && (rs1_tag_out2_ == cdb_tag))                                                         ? {cdb_va, cdb_data, rs2_va_out3_, rs2_data_out3_, 2'b11}                  :           // Shift and Update Rs1
                                                                                                                                                                                                    ((~rs2_va_out2_) && (rs2_tag_out2_ == cdb_tag))                                                         ? {rs1_va_out3_, rs1_data_out3_, cdb_va, cdb_data, 2'b11}                  :           // Shift and Update Rs2
                                                                                                                                                                                                                                                                                                              {rs1_va_out3_, rs1_data_out3_, rs2_va_out3_, rs2_data_out3_, 2'b11})    : 
                                                                                                                                
                                                                                                                                                                                                  ((((~rs1_va_out2_) && (rs1_tag_out2_ == cdb_tag)) && (~rs2_va_out2_) && (rs2_tag_out2_ == cdb_tag))      ? {cdb_va, cdb_data, cdb_va, cdb_data, 2'b01}                              :             // Update Rs1, Rs2
                                                                                                                                                                                                    ((~rs1_va_out2_) && (rs1_tag_out2_ == cdb_tag))                                                        ? {cdb_va, cdb_data, rs2_va_out2_, rs2_data_out2_, 2'b01}                  :             // Update and Update Rs1
                                                                                                                                                                                                    ((~rs2_va_out2_) && (rs2_tag_out2_ == cdb_tag))                                                        ? {rs1_va_out2_, rs1_data_out2_, cdb_va, cdb_data, 2'b01}                  :             // Update and Update Rs2
                                                                                                                                                                                                                                                                                                             {dONTCARE_[0], dONTCARE_, dONTCARE_[0], dONTCARE_, 2'b00})): 68'b0;

// Update and shift sr1
    assign  {rs1_va_in1_, rs1_data_in1_, rs2_va_in1_, rs2_data_in1_, s_ena1_, u_ena1_} =    ({disp_valid_int, cdb_va} == 2'b00) ? {dONTCARE_[0], dONTCARE_, dONTCARE_[0], dONTCARE_, 2'b00}                                                                                     :       // Keep

                                                                                            ({disp_valid_int, cdb_va} == 2'b01) ? ((((~rs1_va_out1_) && (rs1_tag_out1_ == cdb_tag)) && (~rs2_va_out1_) && (rs2_tag_out1_ == cdb_tag))   ? {cdb_va, cdb_data, cdb_va, cdb_data, 2'b01}                               :           // Update Rs1, Rs2
                                                                                                                                    ((~rs1_va_out1_) && (rs1_tag_out1_ == cdb_tag))                                                     ? {cdb_va, cdb_data, rs2_va_out1_, rs2_data_out1_, 2'b01}                   :           // Update Rs1
                                                                                                                                    ((~rs2_va_out1_) && (rs2_tag_out1_ == cdb_tag))                                                     ? {rs1_va_out1_, rs1_data_out1_, cdb_va, cdb_data, 2'b01}                   :           // Update Rs2
                                                                                                                                                                                                                                          {dONTCARE_[0], dONTCARE_, dONTCARE_[0], dONTCARE_, 2'b00})                    :       // Keep (No TAG match)

                                                                                            ({disp_valid_int, cdb_va} == 2'b10) ? ((~&(valid_out1_ & valid_out0_))                ? {rs1_va_out2_, rs1_data_out2_, rs2_va_out2_, rs2_data_out2_, 2'b11}               :           // Shift SR1
                                                                                                                                                                                                  {dONTCARE_[0], dONTCARE_, dONTCARE_[0], dONTCARE_, 2'b00})                    :       // Keep (No space to shift)

                                                                                            ({disp_valid_int, cdb_va} == 2'b11) ? ((~&(valid_out1_ & valid_out0_))                ? ((((~rs1_va_out1_) && (rs1_tag_out1_ == cdb_tag)) && (~rs2_va_out1_) && (rs2_tag_out1_ == cdb_tag))       ? {cdb_va, cdb_data, cdb_va, cdb_data, 2'b11}                                :           // Update Rs1, Rs2
                                                                                                                                                                                                    ((~rs1_va_out1_) && (rs1_tag_out1_ == cdb_tag))                                                         ? {cdb_va, cdb_data, rs2_va_out2_, rs2_data_out2_, 2'b11}                  :           // Shift and Update Rs1
                                                                                                                                                                                                    ((~rs2_va_out1_) && (rs2_tag_out1_ == cdb_tag))                                                         ? {rs1_va_out2_, rs1_data_out2_, cdb_va, cdb_data, 2'b11}                  :           // Shift and Update Rs2
                                                                                                                                                                                                                                                                                                              {rs1_va_out2_, rs1_data_out2_, rs2_va_out2_, rs2_data_out2_, 2'b11})    : 
                                                                                                                                
                                                                                                                                                                                                  ((((~rs1_va_out1_) && (rs1_tag_out1_ == cdb_tag)) && (~rs2_va_out1_) && (rs2_tag_out1_ == cdb_tag))      ? {cdb_va, cdb_data, cdb_va, cdb_data, 2'b01}                              :             // Update Rs1, Rs2
                                                                                                                                                                                                    ((~rs1_va_out1_) && (rs1_tag_out1_ == cdb_tag))                                                        ? {cdb_va, cdb_data, rs2_va_out1_, rs2_data_out1_, 2'b01}                  :             // Update and Update Rs1
                                                                                                                                                                                                    ((~rs2_va_out1_) && (rs2_tag_out1_ == cdb_tag))                                                        ? {rs1_va_out1_, rs1_data_out1_, cdb_va, cdb_data, 2'b01}                  :             // Update and Update Rs2
                                                                                                                                                                                                                                                                                                             {dONTCARE_[0], dONTCARE_, dONTCARE_[0], dONTCARE_, 2'b00})): 68'b0;

// Update and shift sr0
    assign  {rs1_va_in0_, rs1_data_in0_, rs2_va_in0_, rs2_data_in0_, s_ena0_, u_ena0_} =    ({disp_valid_int, cdb_va} == 2'b00) ? {dONTCARE_[0], dONTCARE_, dONTCARE_[0], dONTCARE_, 2'b00}                                                                                     :       // Keep

                                                                                            ({disp_valid_int, cdb_va} == 2'b01) ? ((((~rs1_va_out0_) && (rs1_tag_out0_ == cdb_tag)) && (~rs2_va_out0_) && (rs2_tag_out0_ == cdb_tag))   ? {cdb_va, cdb_data, cdb_va, cdb_data, 2'b01}                               :           // Update Rs1, Rs2
                                                                                                                                    ((~rs1_va_out0_) && (rs1_tag_out0_ == cdb_tag))                                                     ? {cdb_va, cdb_data, rs2_va_out0_, rs2_data_out0_, 2'b01}                   :           // Update Rs1
                                                                                                                                    ((~rs2_va_out0_) && (rs2_tag_out0_ == cdb_tag))                                                     ? {rs1_va_out0_, rs1_data_out0_, cdb_va, cdb_data, 2'b01}                   :           // Update Rs2
                                                                                                                                                                                                                                          {dONTCARE_[0], dONTCARE_, dONTCARE_[0], dONTCARE_, 2'b00})                    :       // Keep (No TAG match)

                                                                                            ({disp_valid_int, cdb_va} == 2'b10) ? ((~valid_out0_)                ? {rs1_va_out1_, rs1_data_out1_, rs2_va_out1_, rs2_data_out1_, 2'b11}               :           // Shift SR1
                                                                                                                                                                                                  {dONTCARE_[0], dONTCARE_, dONTCARE_[0], dONTCARE_, 2'b00})                    :       // Keep (No space to shift)

                                                                                            ({disp_valid_int, cdb_va} == 2'b11) ? ((~valid_out0_)                ? ((((~rs1_va_out0_) && (rs1_tag_out0_ == cdb_tag)) && (~rs2_va_out0_) && (rs2_tag_out0_ == cdb_tag))       ? {cdb_va, cdb_data, cdb_va, cdb_data, 2'b11}                                :           // Update Rs1, Rs2
                                                                                                                                                                                                    ((~rs1_va_out0_) && (rs1_tag_out0_ == cdb_tag))                                                         ? {cdb_va, cdb_data, rs2_va_out1_, rs2_data_out1_, 2'b11}                  :           // Shift and Update Rs1
                                                                                                                                                                                                    ((~rs2_va_out0_) && (rs2_tag_out0_ == cdb_tag))                                                         ? {rs1_va_out1_, rs1_data_out1_, cdb_va, cdb_data, 2'b11}                  :           // Shift and Update Rs2
                                                                                                                                                                                                                                                                                                              {rs1_va_out1_, rs1_data_out1_, rs2_va_out1_, rs2_data_out1_, 2'b11})    : 
                                                                                                                                
                                                                                                                                                                                                  ((((~rs1_va_out0_) && (rs1_tag_out0_ == cdb_tag)) && (~rs2_va_out0_) && (rs2_tag_out0_ == cdb_tag))      ? {cdb_va, cdb_data, cdb_va, cdb_data, 2'b01}                              :             // Update Rs1, Rs2
                                                                                                                                                                                                    ((~rs1_va_out0_) && (rs1_tag_out0_ == cdb_tag))                                                        ? {cdb_va, cdb_data, rs2_va_out0_, rs2_data_out0_, 2'b01}                  :             // Update and Update Rs1
                                                                                                                                                                                                    ((~rs2_va_out0_) && (rs2_tag_out0_ == cdb_tag))                                                        ? {rs1_va_out0_, rs1_data_out0_, cdb_va, cdb_data, 2'b01}                  :             // Update and Update Rs2
                                                                                                                                                                                                                                                                                                             {dONTCARE_[0], dONTCARE_, dONTCARE_[0], dONTCARE_, 2'b00})): 68'b0;
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
// Issue queues
    Shift_Register  SR3 (
    // Inputs
        .clk(clk), .rst(rst),
        .s_ena(s_ena3_), .u_ena(u_ena3_), .opcode_in(disp_opcode), .rd_tag_in(disp_rd_tag), .rs1_tag_in(disp_rs1_tag), .rs1_data_in(rs1_data_in3_), .rs1_va_in(rs1_va_in3_), .rs2_tag_in(disp_rs2_tag), .rs2_data_in(rs2_data_in3_), .rs2_va_in(rs2_va_in3_), .valid_in(disp_valid_int),
    // Outputs
        .opcode_out(opcode_out3_), .rd_tag_out(rd_tag_out3_), .rs1_tag_out(rs1_tag_out3_), .rs1_data_out(rs1_data_out3_), .rs1_va_out(rs1_va_out3_), .rs2_tag_out(rs2_tag_out3_), .rs2_data_out(rs2_data_out3_), .rs2_va_out(rs2_va_out3_), .valid_out(valid_out3_)
    );

    Shift_Register  SR2 (
    // Inputs
        .clk(clk), .rst(rst),
        .s_ena(s_ena2_), .u_ena(u_ena2_), .opcode_in(opcode_out3_), .rd_tag_in(rd_tag_out3_), .rs1_tag_in(rs1_tag_out3_), .rs1_data_in(rs1_data_in2_), .rs1_va_in(rs1_va_in2_), .rs2_tag_in(rs2_tag_out3_), .rs2_data_in(rs2_data_in2_), .rs2_va_in(rs2_va_in2_), .valid_in(valid_out3_),
    // Outputs
        .opcode_out(opcode_out2_), .rd_tag_out(rd_tag_out2_), .rs1_tag_out(rs1_tag_out2_), .rs1_data_out(rs1_data_out2_), .rs1_va_out(rs1_va_out2_), .rs2_tag_out(rs2_tag_out2_), .rs2_data_out(rs2_data_out2_), .rs2_va_out(rs2_va_out2_), .valid_out(valid_out2_)
    );

    Shift_Register  SR1 (
    // Inputs
        .clk(clk), .rst(rst),
        .s_ena(s_ena1_), .u_ena(u_ena1_), .opcode_in(opcode_out2_), .rd_tag_in(rd_tag_out2_), .rs1_tag_in(rs1_tag_out2_), .rs1_data_in(rs1_data_in1_), .rs1_va_in(rs1_va_in1_), .rs2_tag_in(rs2_tag_out2_), .rs2_data_in(rs2_data_in1_), .rs2_va_in(rs2_va_in1_), .valid_in(valid_out2_),
    // Outputs
        .opcode_out(opcode_out1_), .rd_tag_out(rd_tag_out1_), .rs1_tag_out(rs1_tag_out1_), .rs1_data_out(rs1_data_out1_), .rs1_va_out(rs1_va_out1_), .rs2_tag_out(rs2_tag_out1_), .rs2_data_out(rs2_data_out1_), .rs2_va_out(rs2_va_out1_), .valid_out(valid_out1_)
    );

    Shift_Register  SR0 (
    // Inputs
        .clk(clk), .rst(rst),
        .s_ena(s_ena0_), .u_ena(u_ena0_), .opcode_in(opcode_out1_), .rd_tag_in(rd_tag_out1_), .rs1_tag_in(rs1_tag_out1_), .rs1_data_in(rs1_data_in0_), .rs1_va_in(rs1_va_in0_), .rs2_tag_in(rs2_tag_out1_), .rs2_data_in(rs2_data_in0_), .rs2_va_in(rs2_va_in0_), .valid_in(valid_out1_),
    // Outputs
        .opcode_out(opcode_out0_), .rd_tag_out(rd_tag_out0_), .rs1_tag_out(rs1_tag_out0_), .rs1_data_out(rs1_data_out0_), .rs1_va_out(rs1_va_out0_), .rs2_tag_out(rs2_tag_out0_), .rs2_data_out(rs2_data_out0_), .rs2_va_out(rs2_va_out0_), .valid_out(valid_out0_)
    );



endmodule