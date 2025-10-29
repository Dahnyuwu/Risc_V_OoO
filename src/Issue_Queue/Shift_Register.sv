module Shift_Register(
// Input
    input   logic           clk, rst,

    input   logic   [31:0]  rs1_data_in, rs2_data_in,
    input   logic   [5:0]   rs1_tag_in, rs2_tag_in, rd_tag_in, 
    input   logic   [2:0]   opcode_in,
    input   logic           rs1_va_in, rs2_va_in, valid_in,

// Output
    output  logic   [31:0]  rs1_data_out, rs2_data_out
    output  logic   [5:0]   rs1_tag_out, rs2_tag_out, rd_tag_out, 
    output  logic   [2:0]   opcode_out,
    output  logic           rs1_va_out, rs2_va_out, valid_out, 
);
    
    Register    SR_Op   #(.LENGTH(3))   (.clk(clk), .rst(rst), .in(opcode_in),  .ena(1'b1), .out(opcode_out));
    Register    SR_RDT  #(.LENGTH(5))   (.clk(clk), .rst(rst), .in(rd_tag_in),  .ena(1'b1), .out(rd_tag_out));
    Register    SR_RS1T #(.LENGTH(5))   (.clk(clk), .rst(rst), .in(rs1_tag_in), .ena(1'b1), .out(rs1_tag_out));
    Register    SR_RS2T #(.LENGTH(5))   (.clk(clk), .rst(rst), .in(rs2_tag_in), .ena(1'b1), .out(rs2_tag_out));
    Register    SR_RS1D #(.LENGTH(32))  (.clk(clk), .rst(rst), .in(rs1_data_in),.ena(1'b1), .out(rs1_data_out));
    Register    SR_RS2D #(.LENGTH(32))  (.clk(clk), .rst(rst), .in(rs2_data_in),.ena(1'b1), .out(rs2_data_out));
    Register    SR_RS1V #(.LENGTH(1))   (.clk(clk), .rst(rst), .in(rs1_va_in),  .ena(1'b1), .out(rs1_va_out));
    Register    SR_RS2V #(.LENGTH(1))   (.clk(clk), .rst(rst), .in(rs2_va_in),  .ena(1'b1), .out(rs2_va_out));
    Register    SR_RS2V #(.LENGTH(1))   (.clk(clk), .rst(rst), .in(valid_in),  .ena(1'b1), .out(valid_out));

endmodule