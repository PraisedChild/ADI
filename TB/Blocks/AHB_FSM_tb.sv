module AHB_FSM_tb ();
    reg HCLK,HRESETn,ENABLE,WRITE,HREADY,BURST,MIPS_BUSY;
    wire [5:0]STATE;
    wire HWRITE;

    initial begin
        HCLK = 0;
        forever begin
            #1 HCLK = ~HCLK;
        end
    end

    AHB_FSM dut (.HCLK(HCLK),.HRESETn(HRESETn),.ENABLE(ENABLE),.WRITE(WRITE),.HREADY(HREADY),.BURST(BURST),.MIPS_BUSY(MIPS_BUSY),.STATE(STATE));

    initial begin
        HRESETn = 0;
        ENABLE = 0;
        HREADY = 1;
        WRITE = 0;
        BURST = 0;
        MIPS_BUSY=0;
        @(negedge HCLK);
        HRESETn=1;
        IDLE();
        BUSY();
        SBURSTW();
        SBURSTW();
        IDLE();
        SBURSTR();
        BUSY();
        INCRBR();
        repeat(5) @(negedge HCLK);
        BUSY();
        @(negedge HCLK);
        MIPS_BUSY=0;
        @(negedge HCLK);
        IDLE();
        INCRBW();
        repeat(5) @(negedge HCLK);
        IDLE();
        $stop;
    end


    task IDLE;
    begin
    ENABLE = 0;
    @(negedge HCLK);
    end
    endtask
    task BUSY;
    begin
    MIPS_BUSY = 1;
    @(negedge HCLK);
    end
    endtask
    task SBURSTW;
    begin
    WRITE = 1;
    MIPS_BUSY = 0;
    ENABLE = 1;
    BURST =0;
    @(negedge HCLK);
    end
    endtask
    task SBURSTR;
    begin
    WRITE = 0;
    MIPS_BUSY = 0;
    ENABLE = 1;
    BURST = 0;
    @(negedge HCLK);
    end
    endtask
    task INCRBR;
    begin
    WRITE = 0;
    MIPS_BUSY = 0;
    ENABLE = 1;
    BURST = 1;
    @(negedge HCLK);
    end
    endtask
    task INCRBW;
    begin
    WRITE = 1;
    MIPS_BUSY=0;
    ENABLE = 1;
    BURST = 1;
    @(negedge HCLK);
    end
    endtask
    task WAIT;
    begin
    HREADY = 1;
    @(negedge HCLK);
    end
    endtask
endmodule