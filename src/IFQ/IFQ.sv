module IFQ (
// Input
    input   logic   [127:0] wd,
    input   logic   [31:0]  jmp_b_addr,
    input   logic           clk, rst, rd_va, rd_en_in, jmp_b_va, 

//Output
    output  logic           rd_en_out, empty,
    output  logic   [31:0]  inst, PC_in, PC_out
);

    logic [127:0]   I0_out_, I1_out_, I2_out_, I3_out_, row_sel; 
    logic [4:0]     write_p, read_p;
    logic [31:0]    rd_bypass, rd_reg, PC_in_16, PC_out_4, PC_16_jmp, PC_4_jmp;
    logic [3:0]     reg_sel;
    logic           full, rst_wflush, zeros;

// Flushing
    assign rst_wflush = (rst & ~jmp_b_va);

// Reg matrix 
    Register    #(.LENGTH(128))     I0 (.clk(clk), .rst(rst_wflush), .ena(reg_sel[0] & !full), .in(wd), .out(I0_out_));
    Register    #(.LENGTH(128))     I1 (.clk(clk), .rst(rst_wflush), .ena(reg_sel[1] & !full), .in(wd), .out(I1_out_));
    Register    #(.LENGTH(128))     I2 (.clk(clk), .rst(rst_wflush), .ena(reg_sel[2] & !full), .in(wd), .out(I2_out_));
    Register    #(.LENGTH(128))     I3 (.clk(clk), .rst(rst_wflush), .ena(reg_sel[3] & !full), .in(wd), .out(I3_out_));

// PC in/out
    Register    #(.RSTVALUE(32'h0040_0000))     PC_in_u     (.clk(clk), .rst(rst), .ena(1'b1), .in(PC_in_16), .out(PC_in)); 
    Register    #(.RSTVALUE(32'h0040_0000))     PC_out_u    (.clk(clk), .rst(rst), .ena(1'b1), .in(PC_out_4), .out(PC_out)); 
    assign PC_in_16     = (jmp_b_va & rd_en_in) ? jmp_b_addr : ((!full && rd_en_in)              ? (PC_in + 5'b1_0000): PC_in);
    assign PC_out_4     = (jmp_b_va & rd_en_in) ? jmp_b_addr : (((!empty || zeros) && rd_en_in)  ? (PC_out + 3'b1_00) : PC_out);

// Reg matrix selector
    assign reg_sel = (write_p[3:2] == 2'b00) ? 4'b0001 :
                     (write_p[3:2] == 2'b01) ? 4'b0010 :
                     (write_p[3:2] == 2'b10) ? 4'b0100 :
                     (write_p[3:2] == 2'b11) ? 4'b1000 :
                                               4'b0000;

    assign rd_en_out = 1'b1;

// Write pointer
    always_ff @(posedge clk) 
        if (!rst)
            write_p <= 5'b0;

        else
            if (jmp_b_va & rd_en_in)
                write_p <= 5'b0;

            else
                if (!full && rd_va &&  rd_en_in)
                    write_p <= write_p + 3'b100;

// Read pointer
    always_ff @(posedge clk) 
        if (!rst)
            read_p <= 5'b0;

        else
            if (jmp_b_va & rd_en_in)
                read_p <= {3'b000, jmp_b_addr[3:2]};

            else 
                if ((!empty || (PC_out == 32'h0040_0000)) && rd_en_in)
                    read_p <= read_p + 1'b1;
  
// Full and empty flags
    assign empty        = (write_p[4:0] == read_p[4:0]);
    assign full         = (write_p[3:2] == read_p[3:2]) && (write_p[4] != read_p[4]);
    assign zeros        = ~(|I0_out_ | |I1_out_ | |I2_out_ | |I3_out_);

// Instruction selection for first load
    assign inst         = rd_en_in ? ((empty || jmp_b_va) ? rd_bypass : rd_reg) : 32'h0;

// Mux for first load
    assign rd_bypass    =   (read_p[1:0] == 2'b00) ?    wd[127:96]:
                            (read_p[1:0] == 2'b01) ?    wd[95:64] :
                            (read_p[1:0] == 2'b10) ?    wd[63:32] :   
                            (read_p[1:0] == 2'b11) ?    wd[31:0]  :
                                                        128'h0;

// Column selector
    assign rd_reg       =   (read_p[1:0] == 2'b00) ?    row_sel[127:96]:
                            (read_p[1:0] == 2'b01) ?    row_sel[95:64] :
                            (read_p[1:0] == 2'b10) ?    row_sel[63:32] : 
                            (read_p[1:0] == 2'b11) ?    row_sel[31:0]  :
                                                        128'h0;

// Row selector
    assign row_sel      =   (read_p[3:2] == 2'b00) ?    I0_out_ :
                            (read_p[3:2] == 2'b01) ?    I1_out_ :
                            (read_p[3:2] == 2'b10) ?    I2_out_ :
                            (read_p[3:2] == 2'b11) ?    I3_out_ :
                                                        128'h0;

endmodule