`timescale 1ns / 1ps

module matrix_mult_2x2 (
    input logic clk,
    input logic rst,
    input logic en,
    input logic clr_acc,
    input logic signed [15:0] bram_dout_a,
    input logic signed [15:0] bram_dout_b,
    output logic signed [31:0] acc_00,
    output logic signed [31:0] acc_01,
    output logic signed [31:0] acc_10,
    output logic signed [31:0] acc_11
);

endmodule