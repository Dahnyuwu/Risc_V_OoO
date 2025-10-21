module RST(
// Input
    input   logic   [4:0]   rs1_add, rs2_add, rd_add,
    input   logic           w_data_ena1, w_data_ena2, clk, rst,
    input   logic   [6:0]   w_data1, w_data2,               // No estoy seguro si este incluya los bit de valido o alguien más lo modifica
    
// Output
    output  logic   [5:0]   rs1_tag, rs2_tag, 
    output  logic           rs1_tag_va, rs2_tag_va 

);
    
    logic   [6:0]   token [31:0];
    logic   [31:0]  wer_en1, wer_en2;

    assign rs1_tag      = token[rs1_add][5:0];
    assign rs1_tag_va   = token[rs1_add][6];
    assign wer_en1      = (w_data_ena1 && rd_add < 32) ? (32'b1 << rd_add) : 32'b0;


    assign rs2_tag      = token[rs2_add][5:0];
    assign rs2_tag_va   = token[rs2_add][6];
    assign wer_en2      = (w_data_ena2 && rd_add < 32) ? (32'b1 << rd_add) : 32'b0;

// Registers generation with doble write data, write data 1 priority
    generate
        genvar i;
        for (i = 0; i < 32; i = i + 1) begin
            Register_DW #(.LENGTH(7)) Token(
                .clk(clk),
                .rst(rst),
                .ena_1(wer_en1[i]),
                .ena_2(wer_en2[i]),
                .in_1(w_data1),         // Token CDB
                .in_2(w_data2),         // Token TAG FIFO
                .out(token[i])
            );

        end
    endgenerate
endmodule