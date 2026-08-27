(* use_dsp = "yes" *) module int8_mac_pe (
    input  logic        clk,
    input  logic        rst,     // Synchronous reset
    input  logic        en,      // Clock enable
    input  logic        clr_acc,        // Clear accumulator
    input  logic signed [7:0]  a,       // 8-bit signed weight/activation
    input  logic signed [7:0]  b,       // 8-bit signed weight/activation
    output logic signed [31:0] acc      // 32-bit accumulator output
);

    // Internal pipeline registers mapping to DSP48 structural registers
    logic signed [7:0]  a_reg, b_reg;
    logic signed [15:0] m_reg;
    logic signed [31:0] p_reg;

    always_ff @(posedge clk) begin
        if (rst) begin
            a_reg <= '0;
            b_reg <= '0;
            m_reg <= '0;
            p_reg <= '0;
        end else if (en) begin
            // Stage 1: Input Registers
            a_reg <= a;
            b_reg <= b;
            
            // Stage 2: Multiplier Register (M-Reg)
            m_reg <= a_reg * b_reg;
            
            // Stage 3: Accumulator / Output Register (P-Reg)
            if (clr_acc) begin
                p_reg <= m_reg; // Clear accumulator and load new product
            end else begin
                p_reg <= p_reg + m_reg; // Accumulate product
            end
        end
    end

    // Continuous assignment to output port
    assign acc = p_reg;

endmodule