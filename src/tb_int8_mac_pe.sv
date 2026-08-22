`timescale 1ns / 1ps

module tb_int8_mac_pe ();

    // Internal wires
    logic clk;
    logic rst; 
    logic en; 
    logic clr_acc;
    logic signed [7:0] a; 
    logic signed [7:0] b; 
    logic signed [31:0] acc;

    // Device Under Test (DUT)
    int8_mac_pe dut (
        .clk (clk),
        .rst (rst),
        .en  (en),
        .clr_acc (clr_acc),
        .a   (a),
        .b   (b),
        .acc (acc)
    );

    // Clock generation (100 MHz -> 10ns period)
    initial begin
        clk = 0;
        clr_acc = 0;
    end
    always begin
        #5 clk = ~clk;
    end

    // Stimulus block
    initial begin
        // Time 0: Reset the system
        rst = 1;
        en  = 0;
        a   = 0;
        b   = 0;

        // Time 10ns: Release reset, inject data
        #10;
        rst = 0;
        en  = 1;
        a   = 3;
        b   = 4;
        
        // Wait for processing
        #50;
        $finish;
    end

endmodule