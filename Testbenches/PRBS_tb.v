module PRBS_tb ();
    reg clk,rst,data_valid;
    reg [31:0] in;
    reg [7:0] n;
    wire [7:0]PRBS_OUT;

    initial begin
        clk = 0;
        forever begin
            #1 clk = ~clk;
        end
    end

    PRBS dut (.clk(clk),.rst(rst),.data_valid(data_valid),.in(in),.n(n),.PRBS_OUT(PRBS_OUT));


    initial begin
        rst = 1;
        in = 32'habcdefab;
        n = 3;
        data_valid = 0;
        @(negedge clk);

        rst = 0;
        repeat(5) @(negedge clk);

        data_valid = 1;
        repeat(50) @(negedge clk);

        $stop;
    end
endmodule
