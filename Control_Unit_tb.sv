module Control_Unit_tb ();
    reg [31:0] in;
    reg [7:0] n;
    reg clk,rst,seq_done,data_valid;
    wire seq_enable;
    wire rand_flag;
    wire [7:0] seq_num;
    wire [31:0] seq_data;

    initial begin
        clk = 0;
        forever begin
            #1 clk = ~clk;
        end
    end

    Control_Unit dut (.clk(clk),.in(in),.n(n),.rst(rst),.seq_data(seq_data),.data_valid(data_valid),.seq_done(seq_done),.seq_enable(seq_enable),.rand_flag(rand_flag),.seq_num(seq_num));

    initial begin
        rst = 1;
        in = 32'habcdefab;
        n = 3;
        seq_done = 0;
        data_valid = 0;
        @(negedge clk);

        rst = 0;
        repeat(5) @(negedge clk);

        data_valid = 1;
        repeat(50) @(negedge clk);

        seq_done = 1;
        repeat(10) @(negedge clk);

        $stop;
    end
endmodule