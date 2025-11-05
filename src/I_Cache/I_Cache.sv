//////////////////////////////////////////////////////////////////////
//  Company :   ITESO                                               //
//                                                                  //
//  Enginner:   José Daniel Huerta Álvarez                          //
//                                                                  //
//  Module  :   Este módulo es la implementación de la instruction  // 
//              memory, la cual consta de una memoria ROM           //
//                                                                  //
//  Date    :   07/Feb/2025                                         //
//////////////////////////////////////////////////////////////////////

module I_Cache (
// Inputs
    input   logic          clk,

// Inputs IFQ
    input   logic   [7:0]  ifq_PC_in,
    input   logic          ifq_rd_en,

// Outputs to IFQ
    output  logic   [127:0] icache_rd
);

    logic [16:0] inst_0, inst_1, inst_2, inst_3;  
    logic        inst_0_va, inst_1_va, inst_2_va, inst_3_va;;  
    
    logic [127:0] rom[2**7:0];                   // Memory matrix 32 x 8

    initial
        $readmemh("test2.txt", rom);                             // Load binary data from UART_RXTX.txt file
    
    assign icache_rd       = ifq_rd_en ? rom[ifq_PC_in] : 128'h0;

    assign inst_0 = {icache_rd[6:0],       icache_rd[14:12],       icache_rd[31:25]};
    assign inst_1 = {icache_rd[6+32:0+32], icache_rd[14+32:12+32], icache_rd[31+32:25+32]};
    assign inst_2 = {icache_rd[6+64:0+64], icache_rd[14+64:12+64], icache_rd[31+64:25+64]};
    assign inst_3 = {icache_rd[6+96:0+96], icache_rd[14+96:12+96], icache_rd[31+96:25+96]};

endmodule