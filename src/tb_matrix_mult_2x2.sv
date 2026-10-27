`timescale 1ns / 1ps

module tb_matrix_mult_2x2 ();

    // Internal signals initialized at t=0
    logic clk = 0;
    logic rst = 1;
    logic en = 1;
    logic clr_acc = 1;
    logic signed [9:0] addr_a = 10'd0;
    logic signed [9:0] addr_b = 10'd0;

    logic signed [7:0] a_out_01;
    logic signed [7:0] a_out_11;
    logic signed [7:0] b_out_10;
    logic signed [7:0] b_out_11;
    logic signed [31:0] acc_00;
    logic signed [31:0] acc_01;
    logic signed [31:0] acc_10;
    logic signed [31:0] acc_11;

    // Device Under Test (DUT)
    matrix_mult_2x2 dut (
        .clk(clk),
        .rst(rst),
        .en(en),
        .clr_acc(clr_acc),
        .addr_a(addr_a),
        .addr_b(addr_b),
        .a_out_01(a_out_01),
        .a_out_11(a_out_11),
        .b_out_10(b_out_10),
        .b_out_11(b_out_11),
        .acc_00(acc_00),
        .acc_01(acc_01),
        .acc_10(acc_10),
        .acc_11(acc_11)
    );

    // Clock generation (100 MHz -> 10ns period)
    always begin
        #5 clk = ~clk;
    end

    // Stimulus block
    initial begin
        // Load hex data into BRAMs
        $readmemh("matrix_a.hex", dut.ram_a.memory);
        $readmemh("matrix_b.hex", dut.ram_b.memory);

        // 1. Hold reset for 2 clock cycles to flush all pipeline registers
        rst = 1;
        en = 1;
        clr_acc = 1;
        addr_a = 10'd0;
        addr_b = 10'd0;
        repeat (2) @(posedge clk);
        
        // 2. Release reset and allow BRAM read for Address 0
        rst = 0;
        @(posedge clk);

        // 3. Fetch Address 1
        addr_a = 10'd1;
        addr_b = 10'd1;

        // 4. Hold clr_acc high until first product reaches MAC accumulators
        repeat (2) @(posedge clk);
        clr_acc = 0;

        // 5. Allow pipeline to complete accumulation
        repeat (6) @(posedge clk);

        // 6. Print results and finish simulation
        $display("----------------------------------------");
        $display("acc_00: %d", acc_00);
        $display("acc_01: %d", acc_01);
        $display("acc_10: %d", acc_10);
        $display("acc_11: %d", acc_11);
        $display("----------------------------------------");
        $finish;
    end

endmodule