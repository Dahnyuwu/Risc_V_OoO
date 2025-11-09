module upperRAM #(parameter DATAW = 32, ADDRW = 8) (
    input   logic    [DATAW-1:0] wd,                
    input   logic    [ADDRW-1:0] addr,              
    input   logic                we, clk,           
    output  logic    [DATAW-1:0] rd                 
);

    logic [DATAW-1:0] ram[2**ADDRW-1:0]; 

    initial                                                // Inicio de memoria RAM (Esta fallará si tu RAM no es posedge o negedge)
        $readmemh("upperRAM_Test.txt", ram);

    always @(posedge clk) begin                                 
        if (we)
            ram[addr] <= wd;

        else
            ram[addr] <= ram[addr];
    end

    assign rd = ram[addr];
    
endmodule