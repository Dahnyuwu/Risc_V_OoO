module Register #(parameter LENGTH = 32, RSTVALUE = 32'b0)(
// Inputs
    input   logic    [(LENGTH-1):0]      in,
    input   logic                        clk, rst, ena,
    
// Outputs    
    output  logic     [(LENGTH-1):0]      out
);

    always_ff @(posedge clk) begin
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
    input   logic    [(LENGTH-1):0]      in_1, in_2,
    input   logic                        clk, rst, ena_1, ena_2,
    
// Outputs    
    output  logic     [(LENGTH-1):0]      out
);

    always_ff @(posedge clk) begin
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