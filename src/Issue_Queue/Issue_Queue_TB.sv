module Issue_Queue_TB(
);

    logic           clk, rst;
// Input Dispatcher
    logic   [31:0]  disp_rs1_data, disp_rs2_data;
    logic   [5:0]   disp_rs1_tag, disp_rs2_tag, disp_rd_tag;
    logic   [2:0]   disp_opcode;
    logic   [1:0]   disp_branch;
    logic           disp_rs1_tag_va, disp_rs2_tag_va, disp_valid_int;

// Input CDB
    logic   [31:0]  cdb_data;
    logic   [5:0]   cdb_tag;
    logic           cdb_va;

// Output to Dispatcher
    logic           issue_full;

// Output to CDB
    logic   [31:0]  issue_a, issue_b;
    logic   [5:0]   issue_rd_tag;
    logic   [2:0]   issue_opcode;

    Issue_Queue UUT (.*);


    initial begin
        cdb_tag = 0;
        cdb_va = 0;
        cdb_data = 0;

        disp_rs1_data = 0; 
        disp_rs2_data = 0;
        disp_rs1_tag = 0;
        disp_rs2_tag = 0;
        disp_rd_tag = 0;
        disp_opcode = 0;
        disp_branch = 0;
        disp_rs1_tag_va = 0; 
        disp_rs2_tag_va = 0;
        disp_valid_int = 0;

        clk = 1'b1;
        rst = 1'b0;
        #10 rst = 1'b1;    
    end

    always
        #10 clk = ~clk; 

    always begin
        cdb_tag = $random;
        cdb_va = $random;
        cdb_data = $random;
        disp_rs1_data = $random;
        disp_rs2_data = $random;
        disp_rs1_tag = $random;
        disp_rs2_tag = $random;
        disp_rd_tag = $random;
        disp_opcode = $random;
        disp_branch = $random;
        disp_rs1_tag_va = $random;
        disp_rs2_tag_va = $random;
        disp_valid_int = $random;

        #20;
        
    end
    
endmodule