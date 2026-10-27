module bram_sync (
    input logic clk,
    input logic we,
    input logic [9:0] addr,
    input logic [15:0] din,
    output logic [15:0] dout
);

    (* ram_style = "block" *) logic [15:0] memory [0:1023];

    // Added for FPGA Bitstream Initialization
    initial begin
        $readmemh("matrix_a.mem", memory); // Ensure file is in design sources
    end

    always_ff @(posedge clk) begin
        if (we) memory[addr] <= din;
        dout <= memory[addr];
    end

endmodule