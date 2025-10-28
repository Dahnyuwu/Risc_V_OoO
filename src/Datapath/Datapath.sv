module Datapath(
// Inputs
    input   logic   clk, rst, cdb_va, cdb_b_taken, cdb_b,

    input   logic   [5:0] cdb_tag,
    input   logic   [31:0] cdb_data
);

    logic   [127:0] rd_;
    logic   [31:0]  PC_in_, PC_out_, inst, jmp_b_addr_, inst_;
    logic           rd_en_out_, rd_va_, jmp_b_va_, empty_;
    

// Valores temporales

    I_Cache I_Cache(   
        // Inputs
            .clk(clk),
        // Inputs I-cache 
            .ifq_rd_en(rd_en_out_), .ifq_PC_in(PC_in_[11:4]),
        // Outputs
            .icache_rd(rd_)
    );


    IFQ IFQu(
        // Inputs
            .clk(clk), .rst(rst), 
        // Inputs I-cache
            .icache_rd(rd_),
        // Inputs Dispatcher 
            .disp_rd_en_in(rd_en_), .disp_jmp_b_va(jmp_b_va_), .disp_jmp_b_addr(jmp_b_addr_), 
        // Outputs to Dispatcher
            .ifq_rd_en_out(rd_en_out_), .ifq_empty(empty_), .ifq_inst(inst_), .ifq_PC_in(PC_in_), .ifq_PC_out(PC_out_)
    );


    Dispatch_Unit DU(
        // Inputs
            .clk(clk), .rst(rst), 
        // Inputs IFQ
            .ifq_pc4(PC_out_), .ifq_inst(inst_), .ifq_empty(empty_),
        // Input CDB
            .cdb_b(cdb_b), .cdb_b_taken(cdb_b_taken), .cdb_va(cdb_va), .cdb_data(cdb_data), .cdb_tag(cdb_tag),
        // Outputs to IFQ
            .disp_jmp_b_addr(jmp_b_addr_), .disp_jmp_b_va(jmp_b_va_), .disp_rd_en(rd_en_),
        // Output to issue queue
            .disp_rs1_data(), .disp_rs2_data(), .disp_rd_tag(), .disp_rs1_tag(), .disp_rs2_tag(), .disp_opcode(), .disp_rs1_tag_va(), .disp_rs2_tag_va()

    );
    
endmodule