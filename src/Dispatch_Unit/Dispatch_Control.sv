module Dispatch_Control(
// Inputs
    input   logic   clk, rst,

// Inputs
    input   logic   branch_ena, issue_full, cdb_b,

// Outputs
    output  logic   rd_en
);

    logic   state;

    localparam keep  = 1'b0;    // State
    localparam stall = 1'b1;

    always_ff @(posedge clk) begin
        if (!rst)
            state <= keep;

        case (state)
            keep:
                if (branch_ena && !issue_full)
                    state <= stall;
                else 
                    state <= keep;

            stall:
                if (cdb_b)
                    state <= keep;

                else
                    state <= stall; 
            
            default:
                state <= keep; 
        
        endcase

    end 

    always_ff @(state) begin
        case (state)
            keep:
                rd_en <= 1'b1;

            stall:
                rd_en <= 1'b0;

            default: 
                rd_en <= 1'b1;

        endcase

    end   

    
endmodule