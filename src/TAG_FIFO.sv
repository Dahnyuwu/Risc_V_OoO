module TAG_FIFO (
// Inputs
    input   logic           clk, rst, r_ena, cdb_tag_va,
    input   logic   [5:0]   cdb_tag,

// Outputs 
    output  logic           full, empty,
    output  logic   [5:0]   tag_out
);

    logic   [5:0]   tag_table[63:0];
    logic   [6:0]   write_p, read_p;

    assign  WEROut  = (cdb_tag_va && write_p[5:0] < 32) ? (32'b1 << cdb_tag_va) : 32'b0;        // Write enable para el TAG dependiendo si es un cdb valido
    assign  tag_out = r_ena ? tag_table[read_p[5:0]] : 6'b0;                                    // Si r_ena habilita la salida del TAG en read_p 


// Pointers for FIFO (Read & Write)
    // After reset the FIFO is full due to write_p =  ->1<- 00_0000
    always_ff @(posedge clk) begin
        if (!rst)
            write_p <= 7'b100_0000;

        else
            if (cdb_tag_va)
                write_p++;
    end

    always_ff @(posedge clk) begin
        if (!rst)
            read_p <= 7'b000_0000;

        else
            if (r_ena)
                read_p++;
    end

    // Flags full & empty
    assign empty        = (write_p[6:0] == read_p[6:0]);
    assign full         = (write_p[5:0] == read_p[5:0]) && (write_p[6] != read_p[6]);

// Registers generation 
    generate
        genvar i;
        for (i = 0; i < 64; i = i + 1) begin
            Register #(.RSTVALUE(i), .LENGTH(6)) TAG_FIFO(
                .clk(clk),
                .rst(rst),
                .in(cdb_tag),
                .ena(WEROut[i]),
                .out(tag_table[i])
            );

        end
    endgenerate

endmodule