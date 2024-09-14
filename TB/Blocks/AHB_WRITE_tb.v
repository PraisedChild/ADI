module AHB_WRITE_tb ();
    reg [5:0]state;
    reg [31:0]DATA;
    reg HCLK,HREADY,HRESETn;
    reg [25:0]ADDR;
    wire [31:0]HWDATA;
    wire [31:0]HADDR;
    wire HWRITE,DONE,WAIT;

    localparam IDLE = 6'b000001;
    localparam SBURSTW = 6'b000010;
    localparam SBURSTR = 6'b000100;
    localparam INCRBW = 6'b001000;
    localparam INCRBR = 6'b010000;
    localparam BUSY = 6'b100000;


    initial begin
        HCLK = 0;
        forever begin
            #1 HCLK = ~HCLK;
        end
    end

    AHB_WRITE_HANDLER dut (.state(state),.DATA(DATA),.HCLK(HCLK),.HREADY(HREADY),.HRESETn(HRESETn),.ADDR(ADDR),.HWDATA(HWDATA),.HADDR(HADDR),.HWRITE(HWRITE),.DONE(DONE),.WAIT(WAIT));

    initial begin
        HRESETn=0;
        state = IDLE;
        @(negedge HCLK);
        HRESETn=1;
        @(negedge HCLK);
        write_burst_hold;
        @(posedge HCLK);
        @(posedge HCLK);
        $stop;
    end

    task write1;
    begin
        state = IDLE;
        DATA = $random;
        HREADY = 1;
        ADDR = 500;
        @(posedge HCLK);
        state = SBURSTW;
        @(posedge HCLK);
        state = IDLE;
        @(posedge HCLK);
        @(posedge HCLK);
    end
    endtask

    task write1_wait;
    begin
        state = IDLE;
        DATA = $random;
        HREADY = 1;
        ADDR = 500;
        @(posedge HCLK);
        state = SBURSTW;
        @(posedge HCLK);
        state = IDLE;
        HREADY = 0;
        @(posedge HCLK);
        HREADY = 1;
        @(posedge HCLK);
    end
    endtask

    task write_burst;
    begin
        state = IDLE;
        DATA = $random;
        HREADY = 1;
        ADDR = 500;
        @(posedge HCLK);
        state = INCRBW;
        DATA = $random;
        @(posedge HCLK);
        state = INCRBW;
        DATA = $random;
        @(posedge HCLK);
        state = INCRBW;
        DATA = $random;
        @(posedge HCLK);
        state = IDLE;
        @(posedge HCLK);
        @(posedge HCLK);
    end
    endtask
    task write_bwait;
    begin
        state = IDLE;
        DATA = $random;
        HREADY = 1;
        ADDR = 500;
        @(posedge HCLK);
        state = INCRBW;
        DATA = $random;
        @(posedge HCLK);
        state = INCRBW;
        DATA = $random;
        @(posedge HCLK);
        state = BUSY;
        @(posedge HCLK);
        state = INCRBW;
        DATA = $random;
        @(posedge HCLK);
        state = IDLE;
        @(posedge HCLK);
        @(posedge HCLK);
    end
    endtask
    task write_burst_hold;
    begin
        state = IDLE;
        DATA = $random;
        HREADY = 1;
        ADDR = 500;
        @(posedge HCLK);
        state = INCRBW;
        DATA = $random;
        @(posedge HCLK);
        state = INCRBW;
        HREADY = 0;
        DATA = $random;
        @(posedge HCLK);
        state = INCRBW;
        HREADY = 1;
        @(posedge HCLK);
        state = IDLE;
        @(posedge HCLK);
        @(posedge HCLK);
    end
    endtask
endmodule