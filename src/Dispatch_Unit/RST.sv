module RST(
// Input
    input   logic           clk, rst,
    input   logic   [6:0]   w_data1, cdb_token,  
    input   logic   [4:0]   rs1_add, rs2_add, rd_add_in,
    input   logic           w_data_ena1,
    
// Output
    output  logic   [31:0]  w_ena_2,
    output  logic   [5:0]   rs1_tag, rs2_tag,
    output  logic   [4:0]   rd_add_out,
    output  logic           rs1_tag_va, rs2_tag_va

);
    
    logic   [6:0]   token [31:0];
    logic   [31:0]  w_ena_1;


    // assign w_ena_1      = (w_data_ena1 && rd_add_in < 32) ? (32'b1 << rd_add_in) : 32'b0;
    assign w_ena_1      = (w_data_ena1) ? (32'b1 << rd_add_in) : 32'b0;

    genvar j;
    generate
        for (j = 0; j < 32; j++) begin
            assign w_ena_2[j] = (cdb_token[6] && token[j] == cdb_token);
        end
    endgenerate

    assign {rs1_tag_va, rs1_tag} =      ((token[00][6]) && (rs1_add == 5'h00)) ? {1'b1, token[00][5:0]} :
                                        ((token[01][6]) && (rs1_add == 5'h01)) ? token[01] :
                                        ((token[02][6]) && (rs1_add == 5'h02)) ? token[02] :
                                        ((token[03][6]) && (rs1_add == 5'h03)) ? token[03] :
                                        ((token[04][6]) && (rs1_add == 5'h04)) ? token[04] :
                                        ((token[05][6]) && (rs1_add == 5'h05)) ? token[05] :
                                        ((token[06][6]) && (rs1_add == 5'h06)) ? token[06] :
                                        ((token[07][6]) && (rs1_add == 5'h07)) ? token[07] :
                                        ((token[08][6]) && (rs1_add == 5'h08)) ? token[08] :
                                        ((token[09][6]) && (rs1_add == 5'h09)) ? token[09] :
                                        ((token[10][6]) && (rs1_add == 5'h0A)) ? token[10] :
                                        ((token[11][6]) && (rs1_add == 5'h0B)) ? token[11] :
                                        ((token[12][6]) && (rs1_add == 5'h0C)) ? token[12] :
                                        ((token[13][6]) && (rs1_add == 5'h0D)) ? token[13] :
                                        ((token[14][6]) && (rs1_add == 5'h0E)) ? token[14] :
                                        ((token[15][6]) && (rs1_add == 5'h0F)) ? token[15] :
                                        ((token[16][6]) && (rs1_add == 5'h10)) ? token[16] :
                                        ((token[17][6]) && (rs1_add == 5'h11)) ? token[17] :
                                        ((token[18][6]) && (rs1_add == 5'h12)) ? token[18] :
                                        ((token[19][6]) && (rs1_add == 5'h13)) ? token[19] :
                                        ((token[20][6]) && (rs1_add == 5'h14)) ? token[20] :
                                        ((token[21][6]) && (rs1_add == 5'h15)) ? token[21] :
                                        ((token[22][6]) && (rs1_add == 5'h16)) ? token[22] :
                                        ((token[23][6]) && (rs1_add == 5'h17)) ? token[23] :
                                        ((token[24][6]) && (rs1_add == 5'h18)) ? token[24] :
                                        ((token[25][6]) && (rs1_add == 5'h19)) ? token[25] :
                                        ((token[26][6]) && (rs1_add == 5'h1A)) ? token[26] :
                                        ((token[27][6]) && (rs1_add == 5'h1B)) ? token[27] :
                                        ((token[28][6]) && (rs1_add == 5'h1C)) ? token[28] :
                                        ((token[29][6]) && (rs1_add == 5'h1D)) ? token[29] :
                                        ((token[30][6]) && (rs1_add == 5'h1E)) ? token[30] :
                                        ((token[31][6]) && (rs1_add == 5'h1F)) ? token[31] :
                                        7'h00;

    assign {rs2_tag_va, rs2_tag} =      ((token[00][6]) && (rs2_add == 5'h00)) ? {1'b1, token[00][5:0]} :
                                        ((token[01][6]) && (rs2_add == 5'h01)) ? token[01] :
                                        ((token[02][6]) && (rs2_add == 5'h02)) ? token[02] :
                                        ((token[03][6]) && (rs2_add == 5'h03)) ? token[03] :
                                        ((token[04][6]) && (rs2_add == 5'h04)) ? token[04] :
                                        ((token[05][6]) && (rs2_add == 5'h05)) ? token[05] :
                                        ((token[06][6]) && (rs2_add == 5'h06)) ? token[06] :
                                        ((token[07][6]) && (rs2_add == 5'h07)) ? token[07] :
                                        ((token[08][6]) && (rs2_add == 5'h08)) ? token[08] :
                                        ((token[09][6]) && (rs2_add == 5'h09)) ? token[09] :
                                        ((token[10][6]) && (rs2_add == 5'h0A)) ? token[10] :
                                        ((token[11][6]) && (rs2_add == 5'h0B)) ? token[11] :
                                        ((token[12][6]) && (rs2_add == 5'h0C)) ? token[12] :
                                        ((token[13][6]) && (rs2_add == 5'h0D)) ? token[13] :
                                        ((token[14][6]) && (rs2_add == 5'h0E)) ? token[14] :
                                        ((token[15][6]) && (rs2_add == 5'h0F)) ? token[15] :
                                        ((token[16][6]) && (rs2_add == 5'h10)) ? token[16] :
                                        ((token[17][6]) && (rs2_add == 5'h11)) ? token[17] :
                                        ((token[18][6]) && (rs2_add == 5'h12)) ? token[18] :
                                        ((token[19][6]) && (rs2_add == 5'h13)) ? token[19] :
                                        ((token[20][6]) && (rs2_add == 5'h14)) ? token[20] :
                                        ((token[21][6]) && (rs2_add == 5'h15)) ? token[21] :
                                        ((token[22][6]) && (rs2_add == 5'h16)) ? token[22] :
                                        ((token[23][6]) && (rs2_add == 5'h17)) ? token[23] :
                                        ((token[24][6]) && (rs2_add == 5'h18)) ? token[24] :
                                        ((token[25][6]) && (rs2_add == 5'h19)) ? token[25] :
                                        ((token[26][6]) && (rs2_add == 5'h1A)) ? token[26] :
                                        ((token[27][6]) && (rs2_add == 5'h1B)) ? token[27] :
                                        ((token[28][6]) && (rs2_add == 5'h1C)) ? token[28] :
                                        ((token[29][6]) && (rs2_add == 5'h1D)) ? token[29] :
                                        ((token[30][6]) && (rs2_add == 5'h1E)) ? token[30] :
                                        ((token[31][6]) && (rs2_add == 5'h1F)) ? token[31] :
                                        7'h00;

    assign  rd_add_out  =               (cdb_token == token[00]) ? 5'h00 :
                                        (cdb_token == token[01]) ? 5'h01 :
                                        (cdb_token == token[02]) ? 5'h02 :
                                        (cdb_token == token[03]) ? 5'h03 :
                                        (cdb_token == token[04]) ? 5'h04 :
                                        (cdb_token == token[05]) ? 5'h05 :
                                        (cdb_token == token[06]) ? 5'h06 :
                                        (cdb_token == token[07]) ? 5'h07 :
                                        (cdb_token == token[08]) ? 5'h08 :
                                        (cdb_token == token[09]) ? 5'h09 :
                                        (cdb_token == token[10]) ? 5'h0A :
                                        (cdb_token == token[11]) ? 5'h0B :
                                        (cdb_token == token[12]) ? 5'h0C :
                                        (cdb_token == token[13]) ? 5'h0D :
                                        (cdb_token == token[14]) ? 5'h0E :
                                        (cdb_token == token[15]) ? 5'h0F :
                                        (cdb_token == token[16]) ? 5'h10 :
                                        (cdb_token == token[17]) ? 5'h11 :
                                        (cdb_token == token[18]) ? 5'h12 :
                                        (cdb_token == token[19]) ? 5'h13 :
                                        (cdb_token == token[20]) ? 5'h14 :
                                        (cdb_token == token[21]) ? 5'h15 :
                                        (cdb_token == token[22]) ? 5'h16 :
                                        (cdb_token == token[23]) ? 5'h17 :
                                        (cdb_token == token[24]) ? 5'h18 :
                                        (cdb_token == token[25]) ? 5'h19 :
                                        (cdb_token == token[26]) ? 5'h1A :
                                        (cdb_token == token[27]) ? 5'h1B :
                                        (cdb_token == token[28]) ? 5'h1C :
                                        (cdb_token == token[29]) ? 5'h1D :
                                        (cdb_token == token[30]) ? 5'h1E :
                                        (cdb_token == token[31]) ? 5'h1F :
                                        5'h00;

// Registers generation with doble write data, write data 1 priority
    generate
        genvar i;
        for (i = 0; i < 32; i = i + 1) begin
            Register_DW #(.LENGTH(7)) Token(
                .clk(clk),
                .rst(rst),
                .ena_1(w_ena_1[i]),
                .ena_2(w_ena_2[i]),
                .in_1(w_data1),         // Token CDB
                .in_2(7'b0),         // Token TAG FIFO
                .out(token[i])
            );

        end
    endgenerate
endmodule