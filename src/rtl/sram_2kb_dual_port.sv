module sram_2kb_dual_port (
    input  logic        clk,
    // Port A (Read/Write)
    input  logic        ena_i,
    input  logic        wea_i,
    input  logic [9:0]  addra_i,
    input  logic [15:0] dina_i,
    output logic [15:0] douta_o,
    // Port B (Read/Write)
    input  logic        enb_i,
    input  logic        web_i,
    input  logic [9:0]  addrb_i,
    input  logic [15:0] dinb_i,
    output logic [15:0] doutb_o
);

    // 2KB SRAM = 1024 words of 16 bits
    logic [15:0] ram [1023:0];

    always_ff @(posedge clk) begin
        if (ena_i) begin
            if (wea_i)
                ram[addra_i] <= dina_i;
            douta_o <= ram[addra_i];
        end
    end

    always_ff @(posedge clk) begin
        if (enb_i) begin
            if (web_i)
                ram[addrb_i] <= dinb_i;
            doutb_o <= ram[addrb_i];
        end
    end

endmodule
