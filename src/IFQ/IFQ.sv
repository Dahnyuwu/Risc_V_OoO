module IFQ (
    input   logic           clk, rst,
     
// Input I-cache
    input   logic   [127:0] icache_rd,

// Input CDB
    input   logic           cdb_b_taken,

// Input Dispatcher 
    input   logic   [31:0]  disp_jmp_b_addr,
    input   logic           disp_rd_en, disp_jmp_b_va, 

// Output
    output  logic           ifq_rd_en, ifq_empty,
    output  logic   [31:0]  ifq_inst, ifq_pc_in, ifq_pc_out
);

    logic [127:0]   I0_out_, I1_out_, I2_out_, I3_out_, row_sel; 
    logic [4:0]     write_p, read_p;
    logic [31:0]    rd_bypass, rd_reg, PC_in_16, PC_out_4;
    logic [3:0]     reg_sel;
    logic           full, rst_wflush, zeros, up_by_;

// Flushing
    assign rst_wflush = (rst & ~disp_jmp_b_va);

// Reg matrix 
    Register    #(.LENGTH(128))     I0 (.clk(clk), .rst(rst_wflush), .ena(reg_sel[0] & !full), .in(icache_rd), .out(I0_out_));
    Register    #(.LENGTH(128))     I1 (.clk(clk), .rst(rst_wflush), .ena(reg_sel[1] & !full), .in(icache_rd), .out(I1_out_));
    Register    #(.LENGTH(128))     I2 (.clk(clk), .rst(rst_wflush), .ena(reg_sel[2] & !full), .in(icache_rd), .out(I2_out_));
    Register    #(.LENGTH(128))     I3 (.clk(clk), .rst(rst_wflush), .ena(reg_sel[3] & !full), .in(icache_rd), .out(I3_out_));

// PC in/out
    Register    #(.RSTVALUE(32'h0040_0000))     PC_in_u     (.clk(clk), .rst(rst), .ena(1'b1), .in(PC_in_16), .out(ifq_pc_in)); 
    Register    #(.RSTVALUE(32'h0040_0000))     PC_out_u    (.clk(clk), .rst(rst), .ena(1'b1), .in(PC_out_4), .out(ifq_pc_out)); 
    assign PC_in_16     = (disp_jmp_b_va & (disp_rd_en || cdb_b_taken)) ? disp_jmp_b_addr : ((!full && disp_rd_en)              ? (ifq_pc_in + 5'b1_0000): ifq_pc_in);
    assign PC_out_4     = (disp_jmp_b_va & (disp_rd_en || cdb_b_taken)) ? disp_jmp_b_addr : (((!ifq_empty || zeros) && disp_rd_en)  ? (ifq_pc_out + 3'b1_00) : ifq_pc_out);

// Reg matrix selector
    assign reg_sel = (write_p[3:2] == 2'b00) ? 4'b0001 :
                     (write_p[3:2] == 2'b01) ? 4'b0010 :
                     (write_p[3:2] == 2'b10) ? 4'b0100 :
                     (write_p[3:2] == 2'b11) ? 4'b1000 :
                                               4'b0000;

    assign ifq_rd_en= disp_rd_en;

// Write pointer
    always_ff @(posedge clk) 
        if (!rst)
            write_p <= 5'b0;

        else
            if (disp_jmp_b_va)
                write_p <= 5'b0;

            else
                if (!full)
                    write_p <= write_p + 3'b100;

// Read pointer
    always_ff @(posedge clk) 
        if (!rst)
            read_p <= 5'b0;

        else
            if (disp_jmp_b_va)
                read_p <= {3'b000, disp_jmp_b_addr[3:2]};

            else 
                if ((!ifq_empty && disp_rd_en) || up_by_)
                    read_p++;
  
// Full and ifq_empty flags
    assign ifq_empty    = (write_p[4:0] == read_p[4:0]);
    assign full         = (write_p[3:2] == read_p[3:2]) && (write_p[4] != read_p[4]);
    assign zeros        = ~(I0_out_ || I1_out_ || I2_out_ || I3_out_);

// Instruction selection for first load
    assign {ifq_inst, up_by_}         = (rd_reg == 32'b0) ? {rd_bypass, 1'b1} : {rd_reg, 1'b0};

// Mux for first load
    assign rd_bypass    =   (read_p[1:0] == 2'b00) ?    icache_rd[127:96]:
                            (read_p[1:0] == 2'b01) ?    icache_rd[95:64] :
                            (read_p[1:0] == 2'b10) ?    icache_rd[63:32] :   
                            (read_p[1:0] == 2'b11) ?    icache_rd[31:0]  :
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