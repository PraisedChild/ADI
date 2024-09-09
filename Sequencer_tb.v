module Sequencer_tb ();
    reg clk,Seq_en,rst;
    reg [7:0]n;
    reg [31:0]in;
    wire Seq_done;
    wire [7:0] Sequence;

    initial begin
        clk = 0;
        forever begin
            #1 clk = ~clk;
        end
    end

    Sequencer dut (.clk(clk),.Seq_en(Seq_en),.rst(rst),.n(n),.in(in),.Seq_done(Seq_done),.Sequence(Sequence));

    initial begin
        rst = 1;
        Seq_en = 0;
        n = 3;
        in = 32'habcdefab;
        @(negedge clk);

        rst = 0;
        repeat(5) @(negedge clk);

        Seq_en = 1;
        repeat(40) @(negedge clk);
        $stop;
    end
endmodule