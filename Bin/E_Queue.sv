module E_Queue(
// Inputs
    input   logic   [86:0]  disp,
    input   logic   [5:0]   cdb_tag,
    input   logic   [31:0]  cdb_data,
    input   logic           rd_va, cdb_va_in, clk, rst,

// Outputs
    output  logic   [31:0]  rs1_data, rs2_data,
    output  logic   [2:0]   opcode,
    output  logic   [5:0]   rd_tag,
    output  logic           cdb_va_out
);

    logic   [86:0]  registerOut[3:0];
    logic   [86:0]  in_2_0, in_2_1;
    logic   [3:0]   w_ena_1, w_ena_2_0, w_ena_2_1, rst_eq, rst_s;

    assign  rst_eq = ({4{rst}} & (rst_s));


    assign  rst_s =     (cdb_va_in & registerOut[0][0] && registerOut[0][39]) ? 4'b1110 :
                        (cdb_va_in & registerOut[1][0] && registerOut[1][39]) ? 4'b1101 :
                        (cdb_va_in & registerOut[2][0] && registerOut[2][39]) ? 4'b1011 :
                        (cdb_va_in & registerOut[3][0] && registerOut[3][39]) ? 4'b0111 :
                        4'b1111;

    assign  w_ena_1 =   (rd_va && (registerOut[0] == 87'b0)) ? 4'b0001 :
                        (rd_va && (registerOut[1] == 87'b0)) ? 4'b0010 :
                        (rd_va && (registerOut[2] == 87'b0)) ? 4'b0100 :
                        (rd_va && (registerOut[3] == 87'b0)) ? 4'b1000 :
                        4'b0;

    assign  {in_2_0, w_ena_2_0} =       (cdb_va_in && (registerOut[0][6:1] == cdb_tag)) ? {registerOut[0][86:39], cdb_data, registerOut[0][6:1], cdb_va_in, 4'b0001} :
                                        (cdb_va_in && (registerOut[1][6:1] == cdb_tag)) ? {registerOut[1][86:39], cdb_data, registerOut[1][6:1], cdb_va_in, 4'b0010} :
                                        (cdb_va_in && (registerOut[2][6:1] == cdb_tag)) ? {registerOut[2][86:39], cdb_data, registerOut[2][6:1], cdb_va_in, 4'b0100} :
                                        (cdb_va_in && (registerOut[3][6:1] == cdb_tag)) ? {registerOut[3][86:39], cdb_data, registerOut[3][6:1], cdb_va_in, 4'b1000} :
                                        36'b0;

    assign  {in_2_1, w_ena_2_1} =       (cdb_va_in && (registerOut[0][45:40] == cdb_tag)) ? {in_2_0[86:78], cdb_data, in_2_0[45:40], 1'b1, in_2_0[38:0], (w_ena_2_0 | 4'b0001)} :
                                        (cdb_va_in && (registerOut[1][45:40] == cdb_tag)) ? {in_2_0[86:78], cdb_data, in_2_0[45:40], 1'b1, in_2_0[38:0], (w_ena_2_0 | 4'b0010)} :
                                        (cdb_va_in && (registerOut[2][45:40] == cdb_tag)) ? {in_2_0[86:78], cdb_data, in_2_0[45:40], 1'b1, in_2_0[38:0], (w_ena_2_0 | 4'b0100)} :
                                        (cdb_va_in && (registerOut[3][45:40] == cdb_tag)) ? {in_2_0[86:78], cdb_data, in_2_0[45:40], 1'b1, in_2_0[38:0], (w_ena_2_0 | 4'b1000)} :
                                        36'b0;

    assign  {rs1_data, rs2_data, opcode, rd_tag, cdb_va_out} =  (registerOut[0][0] && registerOut[0][39]) ? {registerOut[0][77:46], registerOut[0][38:7], registerOut[0][86:84], registerOut[0][83:78], 1'b1} :
                                                                (registerOut[1][0] && registerOut[1][39]) ? {registerOut[1][77:46], registerOut[1][38:7], registerOut[1][86:84], registerOut[1][83:78], 1'b1} :
                                                                (registerOut[2][0] && registerOut[2][39]) ? {registerOut[2][77:46], registerOut[2][38:7], registerOut[2][86:84], registerOut[2][83:78], 1'b1} :
                                                                (registerOut[3][0] && registerOut[3][39]) ? {registerOut[3][77:46], registerOut[3][38:7], registerOut[3][86:84], registerOut[3][83:78], 1'b1} :
                                                                73'b0;

// Registers generation with doble write data, write data 1 priority
    generate
        genvar i;
        for (i = 0; i < 4; i = i + 1) begin
            Register_DW #(.LENGTH(87)) Int_queue(
                .clk(clk),
                .rst(rst_eq[i]),
                .ena_1(w_ena_1[i]),
                .ena_2(w_ena_2_1[i]),
                .in_1(disp),  
                .in_2(in_2_1),
                .out(registerOut[i])
            );

        end
    endgenerate
    
endmodule