module pe_control (
    input  logic clk,
    input  logic rst_n,
    input  logic start_i,
    input  logic [3:0] vector_len_i, // Up to 16
    output logic load_weight_o,
    output logic clear_acc_o,
    output logic valid_o
);

    typedef enum logic [1:0] {IDLE, LOAD_W, MAC, DONE} state_t;
    state_t state_q, state_d;
    logic [3:0] count_q, count_d;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state_q <= IDLE;
            count_q <= '0;
        end else begin
            state_q <= state_d;
            count_q <= count_d;
        end
    end

    always_comb begin
        state_d = state_q;
        count_d = count_q;
        load_weight_o = 1'b0;
        clear_acc_o = 1'b0;
        valid_o = 1'b0;

        case (state_q)
            IDLE: begin
                if (start_i) begin
                    state_d = LOAD_W;
                end
            end
            LOAD_W: begin
                load_weight_o = 1'b1;
                clear_acc_o = 1'b1;
                count_d = '0;
                state_d = MAC;
            end
            MAC: begin
                if (count_q == vector_len_i - 1) begin
                    state_d = DONE;
                end else begin
                    count_d = count_q + 1;
                end
            end
            DONE: begin
                valid_o = 1'b1;
                state_d = IDLE;
            end
            default: state_d = IDLE;
        endcase
    end

endmodule
