module CDB(
    input   logic   [31:0]  a,b,
    input   logic   [2:0]   opcode,
    input   logic           va,
    input   logic   [5:0]   rd_tag,
    output  logic   [31:0]  cdb_data,
    output  logic   [31:0]  cdb_va,
    output  logic   [5:0]   cdb_tag,
    output  logic           cdb_b_taken,
    output  logic           cdb_b
);

    assign  cdb_data =  (opcode == 3'b000) ? a+b :
                        (opcode == 3'b001) ? a-b :
                        (opcode == 3'b010) ? a&b :
                        (opcode == 3'b011) ? a|b :
                        (opcode == 3'b100) ? a<b :
                        (opcode == 3'b101) ? (a-b)>>31 :
                        (opcode == 3'b110) ? ~|(a-b) :
                        (opcode == 3'b111) ? |(a-b) :

                        32'b0;

    assign  cdb_tag = rd_tag;
    assign  cdb_va = va;
    assign  cdb_b_taken = (opcode == 3'b110 || opcode == 3'b111) && cdb_data ? 1'b1 : 1'b0;
    assign  cdb_b = (opcode == 3'b110 || opcode == 3'b111) ? 1'b1 : 1'b0;
    
endmodule