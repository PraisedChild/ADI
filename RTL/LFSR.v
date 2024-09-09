module LFSR (
    input block_enable,clk,rst,
    input [14:0]seed,
    output reg [7:0]out_rand
);

    reg [14:0] shift_reg;

    always@(posedge clk)begin
        if(rst)begin
            shift_reg <= seed;
            out_rand<= 8'b0000_0000;
        end
        else begin
            if(block_enable)begin
                shift_reg[14]<=shift_reg[13];
                shift_reg[13]<=shift_reg[12];
                shift_reg[12]<=shift_reg[11];
                shift_reg[11]<=shift_reg[10];
                shift_reg[10]<=shift_reg[9];
                shift_reg[9]<=shift_reg[8];
                shift_reg[8]<=shift_reg[7];
                shift_reg[7]<=shift_reg[6];
                shift_reg[6]<=shift_reg[5];
                shift_reg[5]<=shift_reg[4];
                shift_reg[4]<=shift_reg[3];
                shift_reg[3]<=shift_reg[2];
                shift_reg[2]<=shift_reg[1];
                shift_reg[1]<=shift_reg[0];
                shift_reg[0]<=shift_reg[14];
                out_rand<={shift_reg[0]^shift_reg[1],shift_reg[11:5]};
            end
        end
    end
endmodule