module ping_pong_controller (
    input  logic clk,
    input  logic rst_n,
    // Control interface
    input  logic buffer_switch_req_i,
    output logic buffer_ready_o,
    // Mux controls
    output logic dma_write_bank_sel_o, // 0: Bank A, 1: Bank B
    output logic core_read_bank_sel_o  // 0: Bank A, 1: Bank B
);

    logic current_core_bank; // Tracks which bank the core is currently processing

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_core_bank <= 1'b0; // Core starts reading Bank A
        end else if (buffer_switch_req_i) begin
            current_core_bank <= ~current_core_bank; // Flip banks
        end
    end

    // DMA always writes to the bank the core is NOT reading
    assign dma_write_bank_sel_o = ~current_core_bank;
    assign core_read_bank_sel_o = current_core_bank;
    
    assign buffer_ready_o = 1'b1; // Simplified for Phase 2

endmodule
