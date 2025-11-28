//////////////////////////////////////////////////////////////////////
//  Company :   ITESO                                               //
//                                                                  //
//  Enginner:   José Daniel Huerta Álvarez                          //
//                                                                  //
//  Module  :  Este módulo hace una traducción de direcciones       //
//             de memoria, recibiendo 32 bits de dirección ad-      //
//             apatarlo a los rangos que se han implementado        //
//             en el mapa de memoria                                //
//                                                                  //
//  Date    :   12/Mar/2025                                         //
//////////////////////////////////////////////////////////////////////

module Memory_Manager(
    input   logic            clk, rst,
// Inputs
    input   logic    [31:0]  addr, wd,
    input   logic            we,

// Outputs
    output  logic    [31:0]  rd
);
    logic   [31:0] ram_; 
    logic          upperRAM;
    assign rd =   upperRAM ? ram_  : 32'h0;
    assign upperRAM = 1'b1;
    // assign upperRAM = (addr >= 32'h1001_0000 && addr <= 32'hFFFF_FFF0)  ? 1'b1 : 1'b0;
    // assign gpio     = (addr >= 32'h1001_0000 && addr < 32'h1001_1000)   ? 1'b1 : 1'b0;
    // assign lowerRAM = (addr >= 32'h1000_0000 && addr < 32'h1001_0000)   ? 1'b1 : 1'b0;
    // assign reserved = (addr >= 32'h0000_0000 && addr < 32'h0040_0000)   ? 1'b1 : 1'b0;

// RAM
    RAM            I1  (.clk(clk), .wd(wd), .we(we), .addr(addr[9:2]), .rd(ram_));


endmodule