module CDB(
    input   logic   [31:0]  rs1_data, rs2_data,
    input   logic   [2:0]   opcode,
    input   logic   [5:0]   cdb_tag_in,
    input   logic           cdb_va_in,

    output  logic   [31:0]  cdb_data,
    output  logic   [5:0]   cdb_tag_out,
    output  logic           cdb_va_out
);

    assign  cdb_tag_out = cdb_tag_in;
    assign  cdb_va_out = cdb_va_in;

    assign cdb_data =   (opcode == 3'h0) ?     (rs1_data+rs2_data)       :   // Addition operation
                        (opcode == 3'h1) ?     (rs1_data-rs2_data)       :   // Subtraction operation
                        (opcode == 3'h2) ?     (rs1_data*rs2_data)       :   // Multiplication operation
                        (opcode == 3'h3) ?     (rs1_data/rs2_data)       :   // Division operation
                        (opcode == 3'h4) ?     (rs1_data<<rs2_data)      :   // Left shift operation
                        (opcode == 3'h5) ?     (rs1_data>>rs2_data)      :   // Right shift operation
                        (opcode == 3'h6) ?     (rs1_data&rs2_data)       :   // And
                        (opcode == 3'h7) ?     (rs1_data|rs2_data)       :   // Or
                                                         32'b0;          // Default case: return zero
    
endmodule