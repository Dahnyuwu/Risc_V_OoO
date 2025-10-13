module RST(
    input   logic   [4:0]   rs1_add, rs2_add,
    input   logic           w_data_ena1, w_data_ena2,
    input   logic   [6:0]   w_data1, w_data2,               // No estoy seguro si este incluya los bit de valido o alguien más lo modifica
    output  logic   [5:0]   rs1_tag, rs2_tag, 
    output  logic           rs1_tag_va, rs2_tag_va, 

);
    
    logic   [6:0]   token [31:0];

    assign rs1_tag      = token[rs1_add][5:0]
    assign rs1_tag_va   = token[rs1_add][6]
    
    assign rs2_tag      = token[rs2_add][5:0]
    assign rs2_tag_va   = token[rs2_add][6]

// Registers generation with doble write data, write data 1 priority
    generate
        genvar i;
        for (i = 0; i < 32; i = i + 1) begin
            Register_DW #(LENGTH(7)) Token(
                .clk(clk),
                .rst(rst),
                .ena_1(w_data_ena1),
                .ena_2(w_data_ena2),
                .in_1(w_data1),
                .in_2(w_data2),
                .out(token[i])
            );

        end
    endgenerate
endmodule