module Dec_Jmp_Bra(
// Inputs
    input   logic   [31:0]  inst,
    input   logic   [31:0]  pc,

// Outputs    
    output  logic   [31:0]  se, jmp_add,
    output  logic   [9:0]   opcode_out,
    output  logic   [4:0]   rs1_add, rs2_add, rd_add,
    output  logic           r_ena, imm_f
);

// Decoder

    logic [16:0]    op_functs;
    logic [6:0]     opcode, funct7;
    logic [2:0]     funct3;

    logic [2:0] i_type; // Instruction type assignation

    localparam [2:0] R = 3'b000;    // Instruction type constant
    localparam [2:0] I = 3'b001;    // Instruction type constant
    localparam [2:0] S = 3'b010;    // Instruction type constant
    localparam [2:0] B = 3'b011;    // Instruction type constant
    localparam [2:0] U = 3'b100;    // Instruction type constant
    localparam [2:0] J = 3'b101;    // Instruction type constant

    assign  opcode  = inst[6:0];    // Opcode
    // assign  r_ena   = ((i_type == R) || (i_type == I) || (i_type == U) || (i_type == J)) ? 1'b1 : 1'b0;
    assign  r_ena   = ((i_type == R) || (i_type == I) || (i_type == U)) ? 1'b1 : 1'b0;
    assign  jmp_add = se + pc;

    assign  i_type  =   (opcode == 7'b0110011)                                                                                  ? R :
                        ((opcode == 7'b0010011) || (opcode == 7'b0000011) || (opcode == 7'b1100111) || (opcode == 7'b1110011))  ? I :
                        (opcode == 7'b0100011)                                                                                  ? S :
                        (opcode == 7'b1100011)                                                                                  ? B :
                        ((opcode == 7'b0110111) || (opcode == 7'b0010111))                                                      ? U :
                        (opcode == 7'b1101111)                                                                                  ? J :
                                                                                                                                3'b0;
    assign  imm_f   =   (i_type == I) ? 1'b1: 1'b0;

    // assign  rd_add  =   ((i_type == R) || (i_type == I) || (i_type == U) || (i_type == J))    ? inst[11:7]  : 5'b0;
    assign  rd_add  =   (i_type == R) || (i_type == I) || (i_type == U)                       ? inst[11:7]  : 5'b0;
    assign  rs1_add =   ((i_type == R) || (i_type == I) || (i_type == S) || (i_type == B))    ? inst[19:15] : 5'b0;
    assign  rs2_add =   ((i_type == R) || (i_type == S) || (i_type == B))                     ? inst[24:20] : 5'b0;
    assign  funct3  =   ((i_type == R) || (i_type == I) || (i_type == S) || (i_type == B))    ? inst[14:12] : 3'b0;
    assign  funct7  =   (i_type == R) ? inst[31:25] : 7'b0;

    // Conditional assignment based on instruction opcode (bits 6:0)
    assign  se      =   (i_type == R)                               ? 32'b0 :                                                                       // R-type (no immediate)
                        (i_type == I)                               ? {{20{inst[31]}}, inst[31:20]} :                                               // I-type: Sign extends bit 31 and concatenates with bits 31:20
                        (i_type == S)                               ? {{20{inst[31]}}, inst[31:25], inst[11:7]} :                                   // S-type: Sign extends and combines bits 31:25 and 11:7
                        (i_type == B)                               ? {{19{inst[31]}}, inst[31], inst[7], inst[30:25], inst[11:8], 1'b0} :          // B-type: Branch format with LSB set to 0
                        (i_type == U)                               ? {inst[31:12], 12'b0} :                                                        // U-type: Upper immediate (LUI/AUIPC)
                        (i_type == J)                               ? {{11{inst[31]}}, inst[31], inst[19:12], inst[20], inst[30:21], 1'b0} :        // J-type: Jump format with LSB set to 0
                                                                      32'b0;                                                                        // Default: Return 0 for invalid opcodes

    assign  op_functs =  {opcode, funct3, funct7};

    // opcode_out assignation --> {Jmp[1], I-Type[1], Branch[2], Sign(SLTI, SLT...)[1], Issue select[2], Operation[3]}
    assign opcode_out      =    // R - Type
                                ((op_functs & 17'h1FFFF) == 17'b0110011_000_0000000) ? 10'b0_0_00_0_00_000 :      // ADD +
                                ((op_functs & 17'h1FFFF) == 17'b0110011_000_0100000) ? 10'b0_0_00_0_00_001 :      // SUB -
                                ((op_functs & 17'h1FFFF) == 17'b0110011_111_0000000) ? 10'b0_0_00_0_00_010 :      // AND &
                                ((op_functs & 17'h1FF80) == 17'b0010011_110_0000000) ? 10'b0_0_00_0_00_011 :      // OR  |
                                ((op_functs & 17'h1FF80) == 17'b0110011_010_0000000) ? 10'b0_0_00_1_00_001 :      // SLT <
                                    // MUL/DIV - Extension0
                                    ((op_functs & 17'h1FFFF) == 17'b0110011_000_0000001) ? 10'b0_0_00_0_01_000 :  // MUL *
                                    ((op_functs & 17'h1FFFF) == 17'b0110011_100_0000001) ? 10'b0_0_00_0_10_000 :  // DIV /

                                // I - Type         
                                ((op_functs & 17'h1FF80) == 17'b0010011_000_0000000) ? 10'b0_1_00_0_00_000 :      // ADDI +
                                ((op_functs & 17'h1FF80) == 17'b0010011_111_0000000) ? 10'b0_1_00_0_00_010 :      // ANDI &
                                ((op_functs & 17'h1FFFF) == 17'b0110011_110_0000000) ? 10'b0_1_00_0_00_011 :      // ORI  |
                                ((op_functs & 17'h1FF80) == 17'b0010011_010_0000000) ? 10'b0_1_00_1_00_001 :      // SLTI <
                                ((op_functs & 17'h1FFFF) == 17'b0010011_001_0000000) ? 10'b0_1_00_0_00_100 :      // SLLI <<

                                // Store/Load - Type
                                ((op_functs & 17'h1FF80) == 17'b0000011_010_0000000) ? 10'b0_1_00_0_11_000 :      // LW
                                ((op_functs & 17'h1FF80) == 17'b0100011_010_0000000) ? 10'b0_0_00_0_11_001 :      // SW

                                // Branch - Type
                                ((op_functs & 17'h1FF80) == 17'b1100011_000_0000000) ? 10'b0_0_01_1_00_001 :      // BEQ
                                ((op_functs & 17'h1FF80) == 17'b1100011_001_0000000) ? 10'b0_0_10_1_00_001 :      // BNE

                                // Jump - Type     
                                ((op_functs & 17'h1FF80) == 17'b1100111_000_0000000) ? 10'b1_0_00_0_00_000 :      // JALR
                                ((op_functs & 17'h1FC00) == 17'b1101111_000_0000000) ? 10'b1_0_00_0_00_000 :      // JAL
                                                                                       10'h0 ;                   // Default case: all signals inactive

endmodule