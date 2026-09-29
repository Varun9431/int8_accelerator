module matrix_mult_2x2 (
    input logic clk,
    input logic rst,
    input logic en,
    input logic clr_acc,
    input logic signed [9:0] addr_a,
    input logic signed [9:0] addr_b,
    output logic signed [7:0] a_out_01,
    output logic signed [7:0] a_out_11,
    output logic signed [7:0] b_out_10,
    output logic signed [7:0] b_out_11,
    output logic signed [31:0] acc_00,
    output logic signed [31:0] acc_01,
    output logic signed [31:0] acc_10,
    output logic signed [31:0] acc_11
);

    // Wires between BRAM and 2x2 Multiplier
    logic signed [15:0] bram_dout_a;
    logic signed [15:0] bram_dout_b;

    logic signed [7:0] a_00_01, a_10_11;
    logic signed [7:0] b_00_10, b_01_11;
    
    logic signed [7:0] a_row1_d1; // 1-cycle delay for Row 1 activation
    logic signed [7:0] b_col1_d1; // 1-cycle delay for Col 1 weight

    // 1. Instantiate BRAM for Matrix A
    bram_sync ram_a (
        .clk(clk), .we(1'b0), .addr(addr_a), .din(16'h0), .dout(bram_dout_a)
    );

    // 2. Instantiate BRAM for Matrix B
    bram_sync ram_b (
        .clk(clk), .we(1'b0), .addr(addr_b), .din(16'h0), .dout(bram_dout_b)
    );

    // Hardware delay registers for input timing alignment
    always_ff @(posedge clk) begin
        if (rst) begin
            a_row1_d1 <= '0;
            b_col1_d1 <= '0;
        end else if (en) begin
            a_row1_d1 <= bram_dout_a[15:8];
            b_col1_d1 <= bram_dout_b[15:8];
        end
    end

    int8_mac_pe mac_00 (
        .clk(clk),
        .rst(rst),
        .en(en),
        .clr_acc(clr_acc),
        .a(bram_dout_a[7:0]),
        .b(bram_dout_b[7:0]),
        .a_out(a_00_01),
        .b_out(b_00_10),
        .acc(acc_00)
    );

    int8_mac_pe mac_01 (
        .clk(clk),
        .rst(rst),
        .en(en),
        .clr_acc(clr_acc),
        .a(a_00_01),
        .b(b_col1_d1),
        .a_out(a_out_01),
        .b_out(b_01_11),
        .acc(acc_01)
    );

    int8_mac_pe mac_10 (
        .clk(clk),
        .rst(rst),
        .en(en),
        .clr_acc(clr_acc),
        .a(a_row1_d1),
        .b(b_00_10),
        .a_out(a_10_11),
        .b_out(b_out_10),
        .acc(acc_10)    
    );

    int8_mac_pe mac_11 (
        .clk(clk),
        .rst(rst),
        .en(en),
        .clr_acc(clr_acc),
        .a(a_10_11),
        .b(b_01_11),
        .a_out(a_out_11),
        .b_out(b_out_11),
        .acc(acc_11)
    );


endmodule