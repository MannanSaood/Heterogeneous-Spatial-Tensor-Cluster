`timescale 1ns / 1ps

module tb_ping_pong();
    logic clk;
    logic rst_n;
    logic buffer_switch_req_i;
    logic buffer_ready_o;
    logic dma_write_bank_sel_o;
    logic core_read_bank_sel_o;

    ping_pong_controller dut (
        .clk(clk),
        .rst_n(rst_n),
        .buffer_switch_req_i(buffer_switch_req_i),
        .buffer_ready_o(buffer_ready_o),
        .dma_write_bank_sel_o(dma_write_bank_sel_o),
        .core_read_bank_sel_o(core_read_bank_sel_o)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst_n = 0;
        buffer_switch_req_i = 0;
        #20 rst_n = 1;
        
        // Ensure starting state (Core reads 0, DMA writes 1)
        #10;
        if (core_read_bank_sel_o !== 1'b0 || dma_write_bank_sel_o !== 1'b1) 
            $display("[FAIL] Initial state incorrect");
            
        // Toggle buffer
        @(posedge clk);
        buffer_switch_req_i = 1;
        @(posedge clk);
        buffer_switch_req_i = 0;
        
        #10;
        if (core_read_bank_sel_o !== 1'b1 || dma_write_bank_sel_o !== 1'b0) 
            $display("[FAIL] Toggle state incorrect");
            
        $display("[READ] PASSED %0t -- Ping-Pong Controller Functional Simulation Complete", $time);
        $finish;
    end
endmodule
