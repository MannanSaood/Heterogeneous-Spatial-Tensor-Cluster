module axi4_stream_dma (
    input  logic        clk,
    input  logic        rst_n,
    // AXI4-Stream Interface
    input  logic [15:0] s_axis_tdata,
    input  logic        s_axis_tvalid,
    output logic        s_axis_tready,
    input  logic        s_axis_tlast,
    // Memory Interface
    output logic        mem_we_o,
    output logic [9:0]  mem_addr_o,
    output logic [15:0] mem_data_o
);

    logic [9:0] addr_counter;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            addr_counter <= '0;
        end else if (s_axis_tvalid && s_axis_tready) begin
            if (s_axis_tlast)
                addr_counter <= '0;
            else
                addr_counter <= addr_counter + 1;
        end
    end

    assign s_axis_tready = 1'b1; // Always ready to receive in Phase 2
    assign mem_we_o      = s_axis_tvalid && s_axis_tready;
    assign mem_addr_o    = addr_counter;
    assign mem_data_o    = s_axis_tdata;

endmodule
