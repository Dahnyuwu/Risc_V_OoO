//////////////////////////////////////////////////////////////////////
//  Company :   ITESO                                               //
//                                                                  //
//  Enginner:   José Daniel Huerta Álvarez                          //
//                                                                  //
//  Module  :   Este módulo nos ayuda a generar los registros       //
//              necesarios para las señales de entrada y sal-       //
//              ida de la ALU, con un parámetro de entrada L-       //
//              ENGTH que nos ayuda a determinar su tamaño.         //
//                                                                  //
//  Date    :   20/Feb/2024                                         //
//////////////////////////////////////////////////////////////////////

module Register #(parameter LENGTH = 32, RSTVALUE = 32'b0)(
// Inputs
    input   wire    [(LENGTH-1):0]      in,
    input   wire                        clk, rst, ena,
    
// Outputs    
    output  wire     [(LENGTH-1):0]      out
);

    always @(posedge clk) begin
        if (!rst)                                                   // Reset condition: set register to RSTVALUE
            out <= RSTVALUE;

        else
            if (ena)                                                // When enabled: load input value
                out <= in;
					 
            else                                                    // When disabled: maintain current value
                out <= out;
        
    end

endmodule

// Double write
module Register_DW #(parameter LENGTH = 32, RSTVALUE = 32'b0)(
// Inputs
    input   wire    [(LENGTH-1):0]      in_1, in_2
    input   wire                        clk, rst, ena_1, ena_2,
    
// Outputs    
    output  wire     [(LENGTH-1):0]      out
);

    always @(posedge clk) begin
        if (!rst)                                                   
            out <= RSTVALUE;

        else
            if (ena_1)                                                
                out <= in_1;
					 
            else
                if (ena_2) 
                    out <= in_2;

                else
                    out <= out;
        
    end

endmodule