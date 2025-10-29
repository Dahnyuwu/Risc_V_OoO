module Datapath(
// Inputs
    input   logic   clk, rst, cdb_va, cdb_b_taken, cdb_b,

    input   logic   [5:0] cdb_tag,
    input   logic   [31:0] cdb_data
);

    logic   [127:0] icache_rd;
    logic   [31:0]  ifq_pc_in, ifq_pc_out, disp_jmp_b_addr, ifq_inst;
    logic           ifq_rd_en, disp_jmp_b_va, ifq_empty, disp_rd_en;
    

// Valores temporales

    I_Cache I_Cache(   
        // Inputs
            .clk(clk),
        // Inputs I-cache 
            .ifq_rd_en(ifq_rd_en), .ifq_PC_in(ifq_pc_in[11:4]),
        // Outputs
            .icache_rd(icache_rd)
    );


    IFQ IFQu(
        // Inputs
            .clk(clk), .rst(rst), 
        // Inputs I-cache
            .icache_rd(icache_rd),
        // Inputs Dispatcher 
            .disp_rd_en(disp_rd_en), .disp_jmp_b_va(disp_jmp_b_va), .disp_jmp_b_addr(disp_jmp_b_addr), 
        // Outputs to Dispatcher
            .ifq_rd_en(ifq_rd_en), .ifq_empty(ifq_empty), .ifq_inst(ifq_inst), .ifq_PC_in(ifq_pc_in), .ifq_PC_out(ifq_pc_out)
    );


    Dispatch_Unit DU(
        // Inputs
            .clk(clk), .rst(rst), 
        // Inputs IFQ
            .ifq_pc4(ifq_pc_out), .ifq_inst(ifq_inst), .ifq_empty(ifq_empty),
        // Input CDB
            .cdb_b(cdb_b), .cdb_b_taken(cdb_b_taken), .cdb_va(cdb_va), .cdb_data(cdb_data), .cdb_tag(cdb_tag),
        // Outputs to IFQ
            .disp_jmp_b_addr(disp_jmp_b_addr), .disp_jmp_b_va(disp_jmp_b_va), .disp_rd_en(disp_rd_en),
        // Output to issue queue
            .disp_rs1_data(), .disp_rs2_data(), .disp_rd_tag(), .disp_rs1_tag(), .disp_rs2_tag(), .disp_opcode(), .disp_rs1_tag_va(), .disp_rs2_tag_va()

    );
    
endmodule