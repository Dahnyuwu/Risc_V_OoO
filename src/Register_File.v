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
    input   wire    [4:0]   Rr1, Rr2, RdAdd,   
    input   wire            rw, rst, clk,
    input   wire    [31:0]  RdDat,   

// Outputs
    output  wire    [31:0]  Rd1, Rd2                                                              
);
    wire    [31:0]  registerOut[31:0];                                                                      
    wire    [31:0]  WEROut;                                                                                 

    assign  Rd1 = registerOut[Rr1];                                                                  
    assign  Rd2 = registerOut[Rr2];                                                                  

    assign  WEROut = (rw && RdAdd < 32) ? (32'b1 << RdAdd) : 32'b0;

    generate
        genvar i;
        for (i = 0; i < 32; i = i + 1) begin
            if (i == 0) begin
                // Register 0 (x0) - Hardwired to zero, write disabled
                Register RegisterZero(
                    .clk(clk),
                    .rst(rst),
                    .in(32'b0),
                    .ena(1'b0),
                    .out(registerOut[i])
                );
            end
            else if (i == 2) begin
                // Special case: Register 2 (x2) - Stack Pointer
                // Initialized to 0xFFFF_FFF0
                Register #(.RSTVALUE(32'hFFFF_FFF0)) RegisterSP(
                    .clk(clk),
                    .rst(rst),
                    .in(RdDat),
                    .ena(WEROut[i]),
                    .out(registerOut[i])
                );
            end
            else begin
                // Standard registers
                Register Register_file(
                    .clk(clk),
                    .rst(rst),
                    .in(RdDat),
                    .ena(WEROut[i]),
                    .out(registerOut[i])
                );
            end
        end
    endgenerate
    
endmodule
