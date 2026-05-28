module pe_tile (
    input  logic        clk,
    input  logic        rst_n,
    input  logic        start_i,
    input  logic [3:0]  vector_len_i,
    input  logic [7:0]  activation_i,
    input  logic [7:0]  weight_bus_i,
    output logic [15:0] acc_result_o,
    output logic        valid_o
);

    logic load_weight, clear_acc;
    logic [7:0] weight_reg;

    pe_control ctrl_inst (
        .clk(clk),
        .rst_n(rst_n),
        .start_i(start_i),
        .vector_len_i(vector_len_i),
        .load_weight_o(load_weight),
        .clear_acc_o(clear_acc),
        .valid_o(valid_o)
    );

    // Weight stationary register
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            weight_reg <= 8'h00;
        else if (load_weight)
            weight_reg <= weight_bus_i;
    end

    pe_mac mac_inst (
        .clk(clk),
        .rst_n(rst_n),
        .activation_i(activation_i),
        .weight_i(weight_reg),
        .clear_acc_i(clear_acc),
        .acc_o(acc_result_o)
    );

endmodule
