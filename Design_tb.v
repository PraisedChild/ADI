module Design_tb ();
    reg clk,rst,data_valid;
    reg [31:0] in;
    reg [7:0] n;
    wire receive_flag;

    initial begin
        clk = 0;
        forever begin
            #1 clk = ~clk;
        end
    end

    Wrapper dut (.clk(clk),.rst(rst),.data_valid(data_valid),.in(in),.n(n),.receive_flag(receive_flag));

    initial begin
        rst = 1;
        data_valid = 0;
        in = 32'habcdefab;
        n = 3;
        @(negedge clk);

        rst = 0;
        repeat(5) @(negedge clk);

        data_valid = 1;
        repeat(40) @(negedge clk);

        $stop;
    end
endmodule