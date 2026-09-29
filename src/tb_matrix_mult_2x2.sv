`timescale 1ns / 1ps

module tb_matrix_mult_2x2 ();

    // Internal wires
    logic clk = 0;
    logic rst = 1; 
    logic en = 0; 
    logic clr_acc = 1; 
    logic signed [9:0] addr_a;
    logic signed [9:0] addr_b;
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
        $readmemh("matrix_a.hex", dut.ram_a.memory);
        $readmemh("matrix_b.hex", dut.ram_b.memory);


        @(posedge clk);            
        rst = 0;
        en = 1;
        clr_acc = 1;


        @(posedge clk);            
        clr_acc = 0;
        addr_a = 10'd0;
        addr_b = 10'd0;

        @(posedge clk);          
        clr_acc = 0;
        addr_a = 10'd1;
        addr_b = 10'd1;

        repeat(5) @(posedge clk);             
        clr_acc = 0;

        $display("acc_00: %d,\n acc_01: %d,\n acc_10: %d,\n acc_11: %d\n", acc_00, acc_01, acc_10, acc_11);

        $finish;
    end

endmodule