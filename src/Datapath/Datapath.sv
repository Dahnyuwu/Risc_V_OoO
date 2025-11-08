module Datapath(
// Inputs
    input   logic   clk, rst
);

    // Internal i-cache
        logic   [127:0] icache_rd;

    // Internal CDB
    logic   [31:0]  cdb_data;
    logic   [5:0]   cdb_tag;
    logic           cdb_va, cdb_b_taken, cdb_b;

    // Internal IFQ
    logic   [31:0]  ifq_pc_in, ifq_pc_out, ifq_inst;
    logic           ifq_rd_en, ifq_empty, disp_rd_en;
    // Internal dispatch
    logic   [31:0]  disp_rs1_data, disp_rs2_data, disp_jmp_b_addr, disp_imm;
    logic   [5:0]   disp_rd_tag, disp_rs1_tag, disp_rs2_tag;
    logic   [2:0]   disp_opcode;
    logic   [1:0]   disp_branch;
    logic           disp_jmp_b_va, disp_rs1_tag_va, disp_rs2_tag_va, disp_valid_int, disp_valid_mul, disp_valid_div, disp_valid_lw_sw;
    // Internal Issue int
    logic   [31:0]  issue_rs1_int, issue_rs2_int;
    logic   [5:0]   issue_rd_tag_int;
    logic   [2:0]   issue_opcode_int;
    logic           issue_full_int, issue_va_int;
    // Internal Issue mul
    logic   [31:0]  issue_rs1_mul, issue_rs2_mul;
    logic   [5:0]   issue_rd_tag_mul;
    logic   [2:0]   issue_opcode_mul;
    logic           issue_full_mul, issue_va_mul;
    // Internal Issue div
    logic   [31:0]  issue_rs1_div, issue_rs2_div;
    logic   [5:0]   issue_rd_tag_div;
    logic   [2:0]   issue_opcode_div;
    logic           issue_full_div, issue_va_div;
    // Internal Issue LS
    logic   [31:0]  issue_rs1_ls, issue_rs2_ls, issue_addr;
    logic   [5:0]   issue_rd_tag_ls;
    logic           issue_opcode_ls;
    logic           issue_full_ls, issue_va_ls;
    // Internal Issue unit
    logic           i_unit_take_int, i_unit_take_mul, i_unit_take_div, i_unit_take_ls; 
    

// Valores temporales

    // I_Cache I_Cache(   
    //     // Inputs
    //         .clk(clk),
    //     // Inputs I-cache 
    //         .ifq_rd_en(ifq_rd_en), .ifq_PC_in(ifq_pc_in[11:4]),
    //     // Outputs
    //         .icache_rd(icache_rd)
    // );

    I_Cache I_Cache(.ifq_PC_in(ifq_pc_in[11:4]), .*);

    // IFQ IFQu(
    //     // Inputs
    //         .clk(clk), .rst(rst), 
    //     // Inputs I-cache
    //         .icache_rd(icache_rd),
    //     // Inputs Dispatcher 
    //         .disp_rd_en(disp_rd_en), .disp_jmp_b_va(disp_jmp_b_va), .disp_jmp_b_addr(disp_jmp_b_addr), 
    //     // Outputs to Dispatcher
    //         .ifq_rd_en(ifq_rd_en), .ifq_empty(ifq_empty), .ifq_inst(ifq_inst), .ifq_PC_in(ifq_pc_in), .ifq_PC_out(ifq_pc_out)
    // );

    IFQ IFQu(.*);

    // Dispatch_Unit DU(
    //     // Inputs
    //         .clk(clk), .rst(rst), 
    //     // Inputs IFQ
    //         .ifq_pc4(ifq_pc_out), .ifq_inst(ifq_inst), .ifq_empty(ifq_empty),
    //     // Input CDB
    //         .cdb_b(cdb_b), .cdb_b_taken(cdb_b_taken), .cdb_va(cdb_va), .cdb_data(cdb_data), .cdb_tag(cdb_tag),
    //     // Input Issue
    //         .issue_full(issue_full),
    //     // Outputs to IFQ
    //         .disp_jmp_b_addr(disp_jmp_b_addr), .disp_jmp_b_va(disp_jmp_b_va), .disp_rd_en(disp_rd_en),
    //     // Output to issue queue
    //         .disp_rs1_data(disp_rs1_data), .disp_rs2_data(disp_rs2_data), .disp_rd_tag(disp_rd_tag), .disp_rs1_tag(disp_rs1_tag), .disp_rs2_tag(disp_rs2_tag), .disp_opcode(disp_opcode), .disp_rs1_tag_va(disp_rs1_tag_va), .disp_rs2_tag_va(disp_rs2_tag_va), .disp_branch(disp_branch)
    // );

    Dispatch_Unit DU(.ifq_pc4(ifq_pc_out), .issue_full(issue_full_int || issue_full_mul || issue_full_div || issue_full_ls), .*);

    // Issue_Queue IQI(
    //     // Inputs
    //         .clk(clk), .rst(rst),
    //     // Inputs Dispatch
    //         .disp_rs1_data(disp_rs1_data), .disp_rs2_data(disp_rs2_data), .disp_rs1_tag(disp_rs1_tag), .disp_rs2_tag(disp_rs2_tag), .disp_rd_tag(disp_rd_tag), .disp_opcode(disp_opcode), .disp_branch(disp_branch), .disp_rs1_tag_va(disp_rs1_tag_va), .disp_rs2_tag_va(disp_rs2_tag_va), .disp_valid(disp_valid),
    //     // Input CDB
    //         .cdb_va(cdb_va), .cdb_data(cdb_data), .cdb_tag(cdb_tag),
    //     // Output to Dispatcher
    //         .issue_full(issue_full),
    //     // Output to CDB?
    //         .issue_rs1(issue_a), .issue_rs2(issue_b), .issue_rd_tag(issue_rd_tag), .issue_opcode(issue_opcode)
    // );

    Issue_Queue     IQI (.disp_valid(disp_valid_int),                               .issue_full(issue_full_int),    .issue_rs1(issue_rs1_int),  .issue_rs2(issue_rs2_int),  .issue_rd_tag(issue_rd_tag_int),    .issue_opcode(issue_opcode_int), .issue_va(issue_va_int),   .i_unit_take(i_unit_take_int), .*);
    Issue_Queue     IQM (.disp_valid(disp_valid_mul), .disp_opcode(3'b0),           .issue_full(issue_full_mul),    .issue_rs1(issue_rs1_mul),  .issue_rs2(issue_rs2_mul),  .issue_rd_tag(issue_rd_tag_mul),    .issue_opcode(issue_opcode_mul), .issue_va(issue_va_mul),   .i_unit_take(i_unit_take_mul), .*);
    Issue_Queue     IQD (.disp_valid(disp_valid_div), .disp_opcode(3'b0),           .issue_full(issue_full_div),    .issue_rs1(issue_rs1_div),  .issue_rs2(issue_rs2_div),  .issue_rd_tag(issue_rd_tag_div),    .issue_opcode(issue_opcode_div), .issue_va(issue_va_div),   .i_unit_take(i_unit_take_div), .*);
    Issue_Queue_LS  IQLS(.disp_valid(disp_valid_ls),  .disp_opcode(disp_opcode[0]), .issue_full(issue_full_ls),     .issue_rs1(issue_rs1_ls),   .issue_rs2(issue_rs2_ls),   .issue_rd_tag(issue_rd_tag_ls),     .issue_opcode(issue_opcode_ls),  .issue_va(issue_va_ls),    .i_unit_take(i_unit_take_ls), .*);

    Issue_Unit      ISU (.*);



    
endmodule