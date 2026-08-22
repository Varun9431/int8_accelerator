`timescale 1ns / 1ps

module tb_matrix_mult_2x2 ();

    // Internal wires
    logic clk = 0;
    logic rst = 1; 
    logic en = 0; 
    logic clr_acc = 1; 
    logic signed [15:0] bram_dout_a = '0; 
    logic signed [15:0] bram_dout_b = '0; 
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
        .bram_dout_a(bram_dout_a),
        .bram_dout_b(bram_dout_b),
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
        @(posedge clk);            
        rst = 0;
        en = 1;
        clr_acc = 1;
        bram_dout_a = 16'h0302; 
        bram_dout_b = 16'h0605; 

        @(posedge clk);             // Product 1 at Stage 1
        clr_acc = 1;
        bram_dout_a = 16'h0401; 
        bram_dout_b = 16'h0807;

        @(posedge clk);             // Product 1 at Stage 2, Product 2 at Stage 1 *clr_acc = 1, ready for clearing old acc and keeping only product 1 for next clock cyle*
        clr_acc = 1;

        @(posedge clk);             // Product 1 at Stage 3, Product 2 at Stage 1 *clr_acc = 0, ready for accumulating product 2 with product 1*
        clr_acc = 0;

        @(posedge clk);
        clr_acc = 1;
        
        assert (acc_00 == 17 && acc_01 == 20 && acc_10 == 43 && acc_11 == 50)
            $info("Test Passed: Accumulated results are correct, got (%0d,%0d,%0d,%0d)", acc_00, acc_01, acc_10, acc_11);
        else
            $error("Test Failed: Expected (17,20,43,50), got (%0d,%0d,%0d,%0d)", acc_00, acc_01, acc_10, acc_11);
        
        $finish;
    end

endmodule