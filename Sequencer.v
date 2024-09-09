module Sequencer (
    input clk,Seq_en,rst,
    input [7:0]n,
    input [31:0]in,
    output reg Seq_done,
    output reg [7:0] Sequence
);

    reg [1:0] counter;
    reg [7:0] n_counter;

    always@(posedge clk or posedge rst)begin
        if(rst)begin
            counter<=0;
            n_counter<=0;
            Seq_done<=0;
            Sequence<=0;
        end
        else begin
            if(Seq_en)begin
                Seq_done<=0;
                if(n_counter==n)begin
                    Seq_done<=1;
                end
                else begin
                case(counter)
                0: begin
                    Sequence<=in[31:24];
                    counter<=1;
                end
                1: begin
                    Sequence<=in[23:16];
                    counter<=2;
                end
                2: begin
                    Sequence<=in[15:8];
                    counter<=3;
                end
                3: begin
                    Sequence<=in[7:0];
                    counter<=0;
                    n_counter<=n_counter+1;
                end
                default: Sequence<=8'b0000_0000;
                endcase
                end
            end
        end
    end
endmodule