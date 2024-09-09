module LFSR_tb ();
    reg block_enable,clk,rst;
    reg [15:0]seed;
    wire [7:0]out_rand;

    initial begin
        clk = 0;
        forever begin
            #1 clk=~clk;
        end
    end

    LFSR dut (.block_enable(block_enable),.seed(seed),.out_rand(out_rand),.clk(clk),.rst(rst));

    initial begin
        rst = 0;
        seed = $random;
        block_enable = 0;
        @(negedge clk);

        rst = 1;
        @(negedge clk);

        rst = 0;
        repeat(5) @(negedge clk);

        block_enable = 1;
        repeat(10) @(negedge clk);

        rst = 1;
        @(negedge clk);
        rst = 0;
        repeat(10) @(negedge clk);

        $stop;
    end
endmodule