module Shift_Register(
// Input
    input   logic           clk, rst,

    input   logic   [31:0]  rs1_data_in, rs2_data_in,
    input   logic   [5:0]   rs1_tag_in, rs2_tag_in, rd_tag_in, 
    input   logic   [2:0]   opcode_in,
    input   logic           rs1_va_in, rs2_va_in, valid_in, s_ena, u_ena,

// Output
    output  logic   [31:0]  rs1_data_out, rs2_data_out,
    output  logic   [5:0]   rs1_tag_out, rs2_tag_out, rd_tag_out, 
    output  logic   [2:0]   opcode_out,
    output  logic           rs1_va_out, rs2_va_out, valid_out
);
    
    Register    #(.LENGTH(3))   SR_Op     (.clk(clk), .rst(rst), .in(opcode_in),  .ena(s_ena), .out(opcode_out));
    Register    #(.LENGTH(6))   SR_RDT    (.clk(clk), .rst(rst), .in(rd_tag_in),  .ena(s_ena), .out(rd_tag_out));
    Register    #(.LENGTH(6))   SR_RS1T   (.clk(clk), .rst(rst), .in(rs1_tag_in), .ena(s_ena), .out(rs1_tag_out));
    Register    #(.LENGTH(6))   SR_RS2T   (.clk(clk), .rst(rst), .in(rs2_tag_in), .ena(s_ena), .out(rs2_tag_out));
    Register    #(.LENGTH(32))  SR_RS1D   (.clk(clk), .rst(rst), .in(rs1_data_in),.ena(u_ena), .out(rs1_data_out));
    Register    #(.LENGTH(32))  SR_RS2D   (.clk(clk), .rst(rst), .in(rs2_data_in),.ena(u_ena), .out(rs2_data_out));
    Register    #(.LENGTH(1))   SR_RS1V   (.clk(clk), .rst(rst), .in(rs1_va_in),  .ena(u_ena), .out(rs1_va_out));
    Register    #(.LENGTH(1))   SR_RS2V   (.clk(clk), .rst(rst), .in(rs2_va_in),  .ena(u_ena), .out(rs2_va_out));
    Register    #(.LENGTH(1))   SR_VA     (.clk(clk), .rst(rst), .in(valid_in),   .ena(s_ena), .out(valid_out));

endmodule