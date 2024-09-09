module Receiver_tb ();
    reg [7:0]n,in;
    reg clk,rst;
    wire receive_flag;

    initial begin
        clk = 0;
        forever begin
            #1 clk = ~clk;
        end
    end

    Receiver dut (.clk(clk),.rst(rst),.n(n),.in(in),.receive_flag(receive_flag));

    initial begin
        rst = 1;
        n = 2;
        in = 8'hab;
        @(negedge clk);
        rst = 0;
        @(negedge clk);
        in = 8'hcd;
        @(negedge clk);
        in = 8'hef;
        @(negedge clk);
        in = 8'hab;
        @(negedge clk);
        in = 8'hab;
        @(negedge clk);
        in = 8'hcd;
        @(negedge clk);
        in = 8'hef;
        @(negedge clk);
        in = 8'hab;
        @(negedge clk);
        repeat(3) @(negedge clk);
        $stop;
    end
endmodule