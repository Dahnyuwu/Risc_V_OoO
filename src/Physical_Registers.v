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

module Physical_Registers(
// Inputs
    input   wire    [5:0]   Rr1, Rr2, RdAdd,   
    input   wire            rw, rst, clk,
    input   wire    [31:0]  RdDat,   

// Outputs
    output  wire    [31:0]  Rd1, Rd2                                                              
);
    wire    [31:0]  registerOut[63:0];                                                                      
    wire    [63:0]  WEROut;                                                                                 

    assign  Rd1 = registerOut[Rr1];                                                                  
    assign  Rd2 = registerOut[Rr2];                                                                  

    assign  WEROut = (rw && RdAdd < 64) ? (64'b1 << RdAdd) : 64'b0;

    generate
        genvar i;
        for (i = 0; i < 64; i = i + 1) begin
                Register Register_phy(
                    .clk(clk),
                    .rst(rst),
                    .in(RdDat),
                    .ena(WEROut[i]),
                    .out(registerOut[i])
                );
        end
    endgenerate
    
endmodule
