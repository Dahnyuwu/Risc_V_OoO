module Datapath_TB();

    logic   clk, rst, cdb_va;
    logic   [5:0] cdb_tag;
    logic   [31:0] cdb_data;

    Datapath   UUT(.clk(clk), .rst(rst), .cdb_data(cdb_data), .cdb_va(cdb_va), .cdb_tag(cdb_tag));

    initial begin
        clk = 1'b0;
        rst = 1'b0;
        #20 rst = 1'b1;
    end

    always
        #10 clk = ~clk; 

    always begin
        #31 cdb_tag = 0;
        cdb_va = 1;
        cdb_data = 234;
        
        #20 cdb_tag = 1;
        cdb_va = 1;
        cdb_data = -531;
    end
    
endmodule