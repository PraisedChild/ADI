module AHB_READ_tb ();

    reg [5:0]state;
    reg [31:0]HRDATA;
    reg HCLK,HREADY,HRESETn;
    reg [25:0]ADDR;
    wire [31:0]RESPONSE;
    wire [4:0]RESPONSE_ADDR;
    wire REG_ENABLE, REG_WRITE;

    initial begin
        HCLK = 0;
        forever begin
            #1 HCLK = ~HCLK;
        end
    end
    

    AHB_READ_HANDLER dut (.state(state),.HRDATA(HRDATA),.HCLK(HCLK),.HREADY(HREADY),.ADDR(ADDR),.RESPONSE(RESPONSE),.RESPONSE_ADDR(RESPONSE_ADDR),.REG_ENABLE(REG_ENABLE),.REG_WRITE(REG_WRITE),.HRESETn(HRESETn));

    localparam SBURSTR = 6'b000100;
    localparam INCRBR = 6'b010000;      
    localparam BUSY = 6'b100000;
    localparam IDLE = 6'b000001;

    
    initial begin
        HRESETn = 0;
        state = IDLE;
        @(posedge HCLK);
        HRESETn=1;
        @(posedge HCLK);
        read1();
        @(posedge HCLK);
        read1_wait();
        @(posedge HCLK);
        read1_busy();
        @(posedge HCLK);
        read3();
        @(posedge HCLK)
        $stop;
    end

    task read1();
    begin
    @(posedge HCLK);
    state = IDLE;
    HRDATA = 10;
    HREADY = 1;
    ADDR = 25'b0001000000000000000000001;
    @(posedge HCLK);
    state = SBURSTR;
    HRDATA = 10;
    HREADY = 1;
    ADDR = 25'b0001000000000000000000001;
    @(posedge HCLK);
    state = IDLE;
    HRDATA = 10;
    HREADY = 1;
    ADDR = 25'b0;
    @(posedge HCLK);
    HRDATA = 0;
    @(posedge HCLK);
    end
    endtask

    task read1_wait();
    begin
    @(posedge HCLK);
    state = IDLE;
    HRDATA = 10;
    HREADY = 1;
    ADDR = 25'b0001000000000000000000001;
    @(posedge HCLK);
    state = SBURSTR;
    HRDATA = 10;
    HREADY = 1;
    ADDR = 25'b0001000000000000000000001;
    @(posedge HCLK);
    state = IDLE;
    HRDATA = 0;
    HREADY = 0;
    ADDR = 25'b0;
    @(posedge HCLK);
    @(posedge HCLK);
    HREADY = 1;
    @(posedge HCLK);
    end
    endtask

    task read1_busy();
    begin
    @(posedge HCLK);
    state = IDLE;
    HRDATA = 10;
    HREADY = 1;
    ADDR = 25'b0001000000000000000000001;
    @(posedge HCLK);
    state = SBURSTR;
    HRDATA = 10;
    HREADY = 1;
    ADDR = 25'b0001000000000000000000001;
    @(posedge HCLK);
    state = BUSY;
    HRDATA = 10;
    HREADY = 1;
    ADDR = 25'b0;
    @(posedge HCLK);
    HRDATA = 0;
    state = IDLE;
    @(posedge HCLK);
    @(posedge HCLK);
    end
    endtask

    task read3();
    begin
    @(posedge HCLK);
    state = IDLE;
    HRDATA = 10;
    HREADY = 1;
    ADDR = 25'b0001000000000000000000001;
    @(posedge HCLK);
    state = INCRBR;
    HRDATA = 10;
    HREADY = 1;
    ADDR = 25'b0001000000000000000000001;
    @(posedge HCLK);
    state = INCRBR;
    HRDATA = 10;
    HREADY = 1;
    ADDR = 25'b0;
    @(posedge HCLK);
    HRDATA = 0;
    state = IDLE;
    @(posedge HCLK);
    @(posedge HCLK);
    end
    endtask
endmodule