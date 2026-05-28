module pe_mac (
    input  logic        clk,
    input  logic        rst_n,
    input  logic [7:0]  activation_i,
    input  logic [7:0]  weight_i,
    input  logic        clear_acc_i,
    output logic [15:0] acc_o
);

    logic [15:0] mult_out;
    logic [15:0] acc_reg;
    logic        sparsity_gate;
    logic        gated_clk;

    // Zero-Value Sparsity Gating: Detect if activation is zero
    assign sparsity_gate = (activation_i == 8'h00);

    // Integrated Clock Gating (ICG) Latch Simulation
    // In real ASIC flow, this is replaced by a specialized standard cell
    logic clk_en_latch;
    always_latch begin
        if (!clk) begin
            clk_en_latch = ~sparsity_gate;
        end
    end
    assign gated_clk = clk & clk_en_latch;

    // 8-bit Multiplier
    assign mult_out = activation_i * weight_i;

    // 16-bit Accumulator powered by the gated clock
    always_ff @(posedge gated_clk or negedge rst_n) begin
        if (!rst_n) begin
            acc_reg <= 16'h0000;
        end else if (clear_acc_i) begin
            acc_reg <= mult_out;
        end else begin
            acc_reg <= acc_reg + mult_out;
        end
    end

    assign acc_o = acc_reg;

endmodule
