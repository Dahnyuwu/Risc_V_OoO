module Dispatch_Unit_TB();

    logic   clk, rst;

    Dispatch_Unit   UUT(.clk(clk), .rst(rst));

    initial begin
        clk = 1'b1;
        rst = 1'b0;
        #20 rst = 1'b1;
    end

    always
        #10 clk = ~clk; 
    
endmodule