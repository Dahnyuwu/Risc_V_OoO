module Datapath_TB();

    logic   clk, rst;
    integer i;

    Datapath   UUT(.clk(clk), .rst(rst));

    initial begin
        clk = 1'b1;
        rst = 1'b0;
        #10 rst = 1'b1;
    end

    always
        #10 clk = ~clk; 

    // always begin
    //     #200
    //     cdb_tag = 3;
    //     cdb_va = 1;
    //     cdb_data = $random;
    //     cdb_b_taken = 1'b0;
    //     cdb_b = 1'b0;
    //     #20;
    //     cdb_tag = $random;
    //     cdb_va = 0;
    //     cdb_data = $random;
    //     cdb_b_taken = 1'b0;
    //     cdb_b = 1'b0;
    //     #20;
    //     cdb_tag = 0;
    //     cdb_va = 1;
    //     cdb_data = $random;
    //     cdb_b_taken = 1'b0;
    //     cdb_b = 1'b0;
    //     #20;
    //     cdb_tag = 2;
    //     cdb_va = 1;
    //     cdb_data = $random;
    //     cdb_b_taken = 1'b0;
    //     cdb_b = 1'b0;
    //     #20;
    //     cdb_tag = $random;
    //     cdb_va = 0;
    //     cdb_data = $random;
    //     cdb_b_taken = 1'b0;
    //     cdb_b = 1'b0;
    //     #20;
    //     #20;
    //     cdb_tag = 1;
    //     cdb_va = 1;
    //     cdb_data = $random;
    //     cdb_b_taken = 1'b0;
    //     cdb_b = 1'b0;
    //     #20;
        
    // end
    
endmodule