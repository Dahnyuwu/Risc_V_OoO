module Datapath_TB();

    logic   clk, rst, cdb_va, cdb_b_taken, cdb_b;
    logic   [5:0] cdb_tag;
    logic   [31:0] cdb_data;
    integer i;

    Datapath   UUT(.clk(clk), .rst(rst), .cdb_data(cdb_data), .cdb_va(cdb_va), .cdb_tag(cdb_tag), .cdb_b_taken(cdb_b_taken), .cdb_b(cdb_b));

    initial begin
        cdb_tag = 0;
        cdb_va = 0;
        cdb_data = 0;
        cdb_b = 0;
        cdb_b_taken = 1'b0;
        clk = 1'b1;
        rst = 1'b0;
        #10 rst = 1'b1;
    end

    always
        #10 clk = ~clk; 

    always begin
        for (i=0; i<20; i++) begin
            #20 
            cdb_tag = i;
            cdb_va = 1;
            cdb_data = i*$random;
        end

    end
    
endmodule