module Filter (
    input [7:0]IN,
    input clk,rst,
    output [7:0]Average_out
);
    reg [7:0] mem [3:0];

    always@(posedge clk or posedge rst)begin
        if(rst)begin
            mem[3]<=0;
            mem[2]<=0;
            mem[1]<=0;
            mem[0]<=0;
        end
        else begin
            mem[3]<=mem[2];
            mem[2]<=mem[1];
            mem[1]<=mem[0];
            mem[0]<=IN;
        end
    end

    wire [7:0] F0,F1,F2,F3;

    assign F0 = mem[0];
    assign F1 = mem[1]>>1;
    assign F2 = mem[2]>>2;
    assign F3 = mem[3]>>3;

    assign Average_out = F0+F1+F2+F3;
endmodule