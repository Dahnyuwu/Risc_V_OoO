module Dispatch_Control(
// Inputs
    input   logic   clk, rst,

// Inputs
    input   logic   branch_ena, issue_full, cdb_b,

// Outputs
    output  logic   rd_en
);

    logic   [1:0] state;

    localparam keep  = 2'b00;    // State
    localparam stallb = 2'b01;
    localparam stallf = 2'b10;

    always_ff @(posedge clk) begin
        if (!rst)
            state <= keep;

        case (state)
            keep:
                if (branch_ena)
                    state <= stallb;

                else
                    if (issue_full)
                        state <= stallf;
                
                    else 
                        state <= keep;

            stallb:
                if (cdb_b)
                    state <= keep;

                else
                    state <= stallb;                     

            stallf:
                if (!issue_full)
                    state <= keep;

                else
                    state <= stallf; 

            
            default:
                state <= keep; 
        
        endcase

    end 

    always_ff @(state) begin
        case (state)
            keep:
                rd_en <= 1'b1;

            stallb:
                rd_en <= 1'b0;
            
            stallf:
                rd_en <= 1'b0;

            default: 
                rd_en <= 1'b1;

        endcase

    end   

    
endmodule