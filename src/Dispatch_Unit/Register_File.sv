//////////////////////////////////////////////////////////////////////
//  Company :   ITESO                                               //
//                                                                  //
//  Engineer:   José Daniel Huerta Álvarez                          //
//                                                                  //
//  Module  :   This module is the top design, where all            //
//              sub-modules are instantiated to build               //
//              the requested architecture.                         //
//                                                                  //
//  Date    :   17/Apr/2024                                         //
//////////////////////////////////////////////////////////////////////

module Register_File(
// Inputs
    input   wire    [4:0]   rs1_add, rs2_add, rd_add,   
    input   wire            rst, clk,
    input   wire    [31:0]  rd_data, WEROut,   

// Outputs
    output  wire    [31:0]  rs1_data, rs2_data                                                              
);
    wire    [31:0]  registerOut[31:0];                                                                      

    assign  rs1_data = registerOut[rs1_add];                                                                  
    assign  rs2_data = registerOut[rs2_add];                                                                  


    generate
        genvar i;
        for (i = 0; i < 32; i = i + 1) begin : RegisterF
            if (i == 0) begin
                Register RegisterZero(
                    .clk(clk),
                    .rst(rst),
                    .in(32'b0),
                    .ena(1'b0),
                    .out(registerOut[i])
                );
            end
            else if (i == 2) begin
                Register #(.RSTVALUE(32'h7FFF_EFFC)) RegisterSP(
                    .clk(clk),
                    .rst(rst),
                    .in(rd_data),
                    .ena(WEROut[i]),
                    .out(registerOut[i])
                );
            end
            else if (i == 3) begin
                Register #(.RSTVALUE(32'h1000_8000)) RegisterSP(
                    .clk(clk),
                    .rst(rst),
                    .in(rd_data),
                    .ena(WEROut[i]),
                    .out(registerOut[i])
                );
            end
            else begin
                Register Register_file(
                    .clk(clk),
                    .rst(rst),
                    .in(rd_data),
                    .ena(WEROut[i]),
                    .out(registerOut[i])
                );
            end
        end
    endgenerate
    
endmodule
