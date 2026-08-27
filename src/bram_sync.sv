module bram_sync (
    input  logic        clk, we,
    input  logic [9:0]  addr,
    input  logic [15:0] din,
    output logic [15:0] dout
);
    (* ram_style = "block" *) logic [15:0] memory [0:1023];

    initial begin
        $readmemh("bram_init_file.mem", memory);
    end

    // Write and Read operations
    always_ff @(posedge clk) begin
        if (we) memory[addr] <= din;
        dout <= memory[addr]; 
    end
endmodule