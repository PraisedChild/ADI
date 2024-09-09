module Receiver #(
    parameter SEQUENCE = 32'habcdefab
)(
    input [7:0]n,in,
    input clk,rst,
    output reg receive_flag
);
    typedef enum bit [3:0] {
        S0 = 4'b0001,
        S1 = 4'b0010,
        S2 = 4'b0100,
        S3 = 4'b1000
    } state_e;

    state_e cs,ns;
    reg [9:0] counter;
    reg counter_flag,counter_hold;

    always@(posedge clk or posedge rst)begin
        if(rst)
        cs<=S0;
        else
        cs<=ns;
    end

    always@(posedge clk or posedge rst)begin
        if(rst)
        counter<=0;
        else begin
            if(!counter_hold)begin
            if(counter_flag)
            counter<= counter+1;
            else
            counter<=0;
        end
        end
    end
    always@(*)begin
        if((counter==(n*4)))begin
            ns = S0;
            receive_flag = 1;
            counter_flag = 1;
            counter_hold = 1;
        end
        else begin
            receive_flag = 0;
            counter_hold = 0;
        case(cs)
        S0: if(in==8'hab) begin
                ns = S1;
                counter_flag = 1;
            end
            else begin
                ns = S0;
                counter_flag = 0;
            end
        S1: if(in==8'hcd) begin
                ns = S2;
                counter_flag = 1;
            end
            else begin
                ns = S0;
                counter_flag = 0;
            end
        S2: if(in==8'hef) begin
                ns = S3;
                counter_flag = 1;
            end
            else begin
                ns = S0;
                counter_flag = 0;
            end
        S3: if(in==8'hab)begin
                ns = S0;
                counter_flag = 1;
            end
            else begin
                ns = S0;
                counter_flag = 0;
            end
        default: begin
            ns = S0;
            counter_flag = 0;
            end
        endcase
    end
    end
endmodule