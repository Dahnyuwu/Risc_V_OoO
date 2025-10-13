module Dec_Jmp_Bra(
// Inputs
    input   logic   [31:0]  instr,

// Outputs    
    output  logic   [4:0]   rs1, rs2, rd,
    output  logic   [2:0]   funct3,
    output  logic   [6:0]   funct7, opcode
);

// Decoder
    logic [2:0] i_type; // Instruction type assignation

    logic   [31:0] SE;  // Sign extend

    localparam [2:0] R = 3'b000;    // Instruction type constant
    localparam [2:0] I = 3'b001;    // Instruction type constant
    localparam [2:0] S = 3'b010;    // Instruction type constant
    localparam [2:0] B = 3'b011;    // Instruction type constant
    localparam [2:0] U = 3'b100;    // Instruction type constant
    localparam [2:0] J = 3'b101;    // Instruction type constant

    assign  opcode = instr[6:0];    // Opcode

    assign  i_type  =   (opcode == 7'b0110011)                                                                                  ? R :
                        (opcode == 7'b0010011) || (opcode == 7'b0000011) || (opcode == 7'b1100111) || (opcode == 7'b1110011)    ? I :
                        (opcode == 7'b0100011)                                                                                  ? S :
                        (opcode == 7'b1100011)                                                                                  ? B :
                        (opcode == 7'b0110111) || (opcode == 7'b0010111)                                                        ? U :
                        (opcode == 7'b1101111)                                                                                  ? J :
                                                                                                                                3'b0;
    
    assign  rd      =   (i_type == R) || (i_type == I) || (i_type == U) || (i_type == J)    ? instr[11:7]  : 5'b0;
    assign  rs1     =   (i_type == R) || (i_type == I) || (i_type == S) || (i_type == B)    ? instr[19:15] : 5'b0;
    assign  rs2     =   (i_type == R) || (i_type == S) || (i_type == B)                     ? instr[24:20] : 5'b0;
    assign  funct3  =   (i_type == R) || (i_type == I) || (i_type == S) || (i_type == B)    ? instr[14:12] : 3'b0;
    assign  funct7  =   (i_type == R) ? instr[31:25] : 7'b0;

    // Conditional assignment based on instruction opcode (bits 6:0)
    assign  SE      =   (i_type == R)                               ? 32'b0 :                                                                       // R-type (no immediate)
                        (i_type == I)                               ? {{20{instr[31]}}, instr[31:20]} :                                             // I-type: Sign extends bit 31 and concatenates with bits 31:20
                        (i_type == S)                               ? {{20{instr[31]}}, instr[31:25], instr[11:7]} :                                // S-type: Sign extends and combines bits 31:25 and 11:7
                        (i_type == B)                               ? {{19{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0} :     // B-type: Branch format with LSB set to 0
                        (i_type == U)                               ? {instr[31:12], 12'b0} :                                                       // U-type: Upper immediate (LUI/AUIPC)
                        (i_type == I)                               ? {{11{instr[31]}}, instr[31], instr[19:12], instr[20], instr[30:21], 1'b0} :   // J-type: Jump format with LSB set to 0
                                                                      32'b0;                                                                        // Default: Return 0 for invalid opcodes


endmodule