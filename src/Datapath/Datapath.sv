module Datapath(
// Inputs
    input   logic   clk, rst
);

    logic   [127:0] rd_;
    logic   [31:0]  PC_in_, PC_out_, inst, jmp_b_addr_, inst_;
    logic           rd_en_out_, rd_va_, jmp_b_va_, empty_;

// Valores temporales

    I_Cache I_Cache(   
        // Inputs
            .clk(clk), .rd_en(rd_en_out_), .PC_in(PC_in_>>4),
        // Outputs
            .rd_va(rd_va_), .rd(rd_)
    );


    IFQ IFQu(
        // Inputs
            .clk(clk), .rst(rst), .rd_va(rd_va_), .rd_en_in(rd_en_), .jmp_b_va(jmp_b_va_), .wd(rd_), .jmp_b_addr(jmp_b_addr_), 
        // Outputs
            .rd_en_out(rd_en_out_), .empty(empty_), .inst(inst_), .PC_in(PC_in_), .PC_out(PC_out_)
    );


    Dispatch_Unit DU(
        // Inputs
            .clk(clk), .rst(rst), .empty(empty_), .cdb_b(), .cdb_b_taken(), .cdb_va(), .PrC_4(PC_out_), .inst(inst_), .cdb_data(), .cdb_tag(),
        //Outputs
            .jmp_b_addr(jmp_b_addr_), .jmp_b_va(jmp_b_va_), .rd_en(rd_en_)
    );
    
endmodule