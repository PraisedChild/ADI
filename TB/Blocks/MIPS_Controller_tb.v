module MIPS_Controller_tb ();
    reg [5:0]OPCODE;
    wire BURST,ENABLE,WRITE,BUSY;

    reg clk;

    initial begin
        clk = 0;
        forever begin
           #1 clk = ~clk;
        end
    end

    MIPS_Controller dut (.OPCODE(OPCODE),.BURST(BURST),.ENABLE(ENABLE),.WRITE(WRITE),.BUSY(BUSY));

    initial begin
        OPCODE = 6'b100011;
        @(negedge clk);
        OPCODE = 6'b000000;
        @(negedge clk);
        OPCODE = 6'b100000;
        @(negedge clk);
        OPCODE = 6'b100001;
        @(negedge clk);
        OPCODE = 6'b101011;

        @(negedge clk);

        $stop;
    end
endmodule