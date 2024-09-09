module Control_Unit (
    input [31:0] in,
    input [7:0] n,
    input clk,rst,seq_done,data_valid,
    output reg seq_enable,
    output reg rand_flag,
    output [7:0] seq_num,
    output [31:0] seq_data
);
    ///this block doesn't use out valid, but instead uses a sequence of patterns for the other block to recognize 
    ///that transmission is about to begin, this is useful for noisy environments.

    typedef enum bit [2:0] { 
        IDLE = 3'b001,
        ESTABLISHMENT = 3'b010,
        RANDOMIZATION = 3'b100
    } state_e;
    
    ///fsm, got state of idle, establishment, and randomization, onehot encoding for performance.

    state_e cs,ns;

    ///state block///
    always@(posedge clk or posedge rst)begin
        if(rst)begin
            cs<=IDLE;
        end
        else begin
            cs<=ns;
        end
    end

    ///next state logic & outputs///
    always@(*)begin
        rand_flag = 0;
        seq_enable=0;
        case(cs)
        IDLE:begin
            if(data_valid) begin
                ns=ESTABLISHMENT;
                seq_enable=1;
            end
            else
                ns=IDLE;
                seq_enable=0;
            end
        ESTABLISHMENT: begin
            if(seq_done) begin
            ns=RANDOMIZATION;
            seq_enable=0;
            end
            else begin
            ns=ESTABLISHMENT;
            seq_enable=1;
            end
        end
        RANDOMIZATION: begin
            ns=RANDOMIZATION;
            rand_flag = 1;
            seq_enable = 0;
        end
        default: begin
            ns = IDLE;
            rand_flag = 0;
            seq_enable=0;
        end
        endcase
    end

    assign seq_data = in;
    assign seq_num = n; 
endmodule