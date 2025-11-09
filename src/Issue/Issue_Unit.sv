module Issue_Unit(
    input   logic   clk, rst,

// Input int issue queue
    input   logic   [31:0]  issue_rs1_int, issue_rs2_int,
    input   logic   [5:0]   issue_rd_tag_int,
    input   logic   [2:0]   issue_opcode_int,
    input   logic           issue_va_int,

// Input mul issue queue
    input   logic   [31:0]  issue_rs1_mul, issue_rs2_mul,
    input   logic   [5:0]   issue_rd_tag_mul,
    input   logic   [2:0]   issue_opcode_mul,
    input   logic           issue_va_mul,

// Input div issue queue
    input   logic   [31:0]  issue_rs1_div, issue_rs2_div,
    input   logic   [5:0]   issue_rd_tag_div,
    input   logic   [2:0]   issue_opcode_div,
    input   logic           issue_va_div,

// Input ls issue queue
    input   logic   [31:0]  issue_rs1_ls, issue_rs2_ls, issue_addr,
    input   logic   [5:0]   issue_rd_tag_ls,
    input   logic           issue_opcode_ls,
    input   logic           issue_va_ls,

// Output to CDB
    output  logic   [31:0]  cdb_data,  
    output  logic   [5:0]   cdb_tag,
    output  logic           cdb_b_taken, cdb_va, cdb_b,

// Output to issue queues
    output  logic           i_unit_take_int, i_unit_take_mul, i_unit_take_div, i_unit_take_ls
);
    logic   [31:0]  int_cdb_data_, mul_cdb_data_, div_cdb_data_, ls_cdb_data_;
    logic   [31:0]  mul_data_out0_, mul_data_out1_, mul_data_in0_;
    logic   [31:0]  div_data_out0_, div_data_out1_, div_data_out2_, div_data_out3_, div_data_out4_, div_data_in0_;
    logic   [5:0]   mul_tag_out0_, mul_tag_out1_, mul_tag_out2_;
    logic   [5:0]   div_tag_out0_, div_tag_out1_, div_tag_out2_, div_tag_out3_, div_tag_out4_, div_tag_out5_;
    logic   [6:0]   cdb_slot_out_, cdb_slot_in_;
    logic   [5:0]   i_unit_take_div_out_;
    logic   [3:0]   mux_sel;
    logic   [2:0]   i_unit_take_mul_out_;
    logic           int_cdb_b_taken_, int_cdb_b_, iol_out_;

     
// CDB Slot 
    assign i_unit_take_int = ~cdb_slot_out_[1] & issue_va_int & (~iol_out_ | ~i_unit_take_ls)       ? 1'b1 : 1'b0;
    assign i_unit_take_mul = ~cdb_slot_out_[4] & issue_va_mul                                       ? 1'b1 : 1'b0;
    assign i_unit_take_div = ~|i_unit_take_div_out_ & issue_va_div                                  ? 1'b1 : 1'b0;
    assign i_unit_take_ls  = ~cdb_slot_out_[1] & issue_va_ls & (iol_out_ | ~i_unit_take_int)        ? 1'b1 : 1'b0;

    assign cdb_slot_in_[0]      = cdb_slot_out_[1] | i_unit_take_int;
    assign cdb_slot_in_[2:1]    = cdb_slot_out_[3:2];
    assign cdb_slot_in_[3]      = cdb_slot_out_[4] | i_unit_take_mul;
    assign cdb_slot_in_[5:4]    = cdb_slot_out_[6:5];
    assign cdb_slot_in_[6]      = i_unit_take_div;

    Register #(.LENGTH(7)) CDB_S(.clk(clk), .rst(rst), .ena(1'b1), .in(cdb_slot_in_), .out(cdb_slot_out_));
    Register #(.LENGTH(1))   IOL(.clk(clk), .rst(rst), .ena(i_unit_take_int | i_unit_take_ls), .in(~iol_out_), .out(iol_out_));     // Prioridad a int o lw

// Mux selector
    assign  mux_sel = {i_unit_take_int, i_unit_take_mul_out_[0],i_unit_take_div_out_[0], i_unit_take_ls};

// Multiplication pipe
    Register #(.LENGTH(3)) MP (.clk(clk), .rst(rst), .ena(1'b1), .in({i_unit_take_mul, i_unit_take_mul_out_[2:1]}), .out(i_unit_take_mul_out_)); 
    
// Division pipe
    Register #(.LENGTH(6)) DP (.clk(clk), .rst(rst), .ena(1'b1), .in({i_unit_take_div, i_unit_take_div_out_[5:1]}), .out(i_unit_take_div_out_)); 

// Integer issue
        assign  int_cdb_data_ = (issue_opcode_int == 3'b000) ?   (issue_rs1_int+issue_rs2_int)     :  // Add
                                (issue_opcode_int == 3'b001) ?   (issue_rs1_int-issue_rs2_int)     :  // Sub
                                (issue_opcode_int == 3'b010) ?   (issue_rs1_int&issue_rs2_int)     :  // And
                                (issue_opcode_int == 3'b011) ?   (issue_rs1_int|issue_rs2_int)     :  // Or
                                (issue_opcode_int == 3'b100) ?   (issue_rs1_int<<issue_rs2_int)    :  // Sll
                                (issue_opcode_int == 3'b101) ?   (issue_rs1_int-issue_rs2_int)>>31 :  // SLT
                                (issue_opcode_int == 3'b110) ? ~|(issue_rs1_int-issue_rs2_int)     :  // BEQ
                                (issue_opcode_int == 3'b111) ?  |(issue_rs1_int-issue_rs2_int)     :  // BNE
                                                                  32'b0;

    assign  int_cdb_b_taken_ = (issue_opcode_int == 3'b110 || issue_opcode_int == 3'b111) && int_cdb_data_   ? 1'b1 : 1'b0;
    assign  int_cdb_b_       = (issue_opcode_int == 3'b110 || issue_opcode_int == 3'b111)                    ? 1'b1 : 1'b0;

// Multiplication issue & pipes
    assign  mul_data_in0_ = (issue_rs1_mul * issue_rs2_mul);

    Register    MPD0(.clk(clk), .rst(rst), .ena(i_unit_take_mul), .in(mul_data_in0_), .out(mul_data_out0_));
    Register    MPD1(.clk(clk), .rst(rst), .ena(1'b1), .in(mul_data_out0_), .out(mul_data_out1_));
    Register    MPD2(.clk(clk), .rst(rst), .ena(1'b1), .in(mul_data_out1_), .out(mul_cdb_data_));

    Register  #(.LENGTH(6)) MPT0(.clk(clk), .rst(rst), .ena(i_unit_take_mul), .in(issue_rd_tag_mul), .out(mul_tag_out0_));
    Register  #(.LENGTH(6)) MPT1(.clk(clk), .rst(rst), .ena(1'b1), .in(mul_tag_out0_), .out(mul_tag_out1_));
    Register  #(.LENGTH(6)) MPT2(.clk(clk), .rst(rst), .ena(1'b1), .in(mul_tag_out1_), .out(mul_tag_out2_));

// Division issue & pies
    assign  div_data_in0_   = (|issue_rs2_div) ? (issue_rs1_div / issue_rs2_div) : 32'hFFFF_FFFF;

    Register    DPD0(.clk(clk), .rst(rst), .ena(i_unit_take_div), .in(div_data_in0_), .out(div_data_out0_));
    Register    DPD1(.clk(clk), .rst(rst), .ena(1'b1), .in(div_data_out0_), .out(div_data_out1_));
    Register    DPD2(.clk(clk), .rst(rst), .ena(1'b1), .in(div_data_out1_), .out(div_data_out2_));
    Register    DPD3(.clk(clk), .rst(rst), .ena(1'b1), .in(div_data_out2_), .out(div_data_out3_));
    Register    DPD4(.clk(clk), .rst(rst), .ena(1'b1), .in(div_data_out3_), .out(div_data_out4_));
    Register    DPD5(.clk(clk), .rst(rst), .ena(1'b1), .in(div_data_out4_), .out(div_cdb_data_));

    Register  #(.LENGTH(6)) DPT0(.clk(clk), .rst(rst), .ena(i_unit_take_div), .in(issue_rd_tag_div), .out(div_tag_out0_));
    Register  #(.LENGTH(6)) DPT1(.clk(clk), .rst(rst), .ena(1'b1), .in(div_tag_out0_), .out(div_tag_out1_));
    Register  #(.LENGTH(6)) DPT2(.clk(clk), .rst(rst), .ena(1'b1), .in(div_tag_out1_), .out(div_tag_out2_));
    Register  #(.LENGTH(6)) DPT3(.clk(clk), .rst(rst), .ena(1'b1), .in(div_tag_out2_), .out(div_tag_out3_));
    Register  #(.LENGTH(6)) DPT4(.clk(clk), .rst(rst), .ena(1'b1), .in(div_tag_out3_), .out(div_tag_out4_));
    Register  #(.LENGTH(6)) DPT5(.clk(clk), .rst(rst), .ena(1'b1), .in(div_tag_out4_), .out(div_tag_out5_));

// Load & Store issue
    Memory_Manager  MM (.clk(clk), .rst(rst), .addr(issue_addr), .wd(issue_rs2_ls), .we(issue_opcode_ls), .rd(ls_cdb_data_));

// CDB Selector
    assign  cdb_data =  (mux_sel == 4'b1000) ? int_cdb_data_ :
                        (mux_sel == 4'b0100) ? mul_cdb_data_ :
                        (mux_sel == 4'b0010) ? div_cdb_data_ :
                        (mux_sel == 4'b0001) ? ls_cdb_data_  :
                        32'b0;
    
    assign  cdb_tag =   (mux_sel == 4'b1000) ? issue_rd_tag_int :
                        (mux_sel == 4'b0100) ? mul_tag_out2_ :
                        (mux_sel == 4'b0010) ? div_tag_out5_ :
                        (mux_sel == 4'b0001) ? issue_rd_tag_ls :
                        6'b0;

    assign  cdb_va =    (|mux_sel) ? 1'b1 : 1'b0;

    assign  cdb_b_taken = mux_sel[3] ? (&issue_opcode_int[2:1] & int_cdb_data_[0]) : 1'b0;
    assign  cdb_b       = mux_sel[3] ? (&issue_opcode_int[2:1]) : 1'b0;

endmodule