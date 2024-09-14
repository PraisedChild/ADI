module AHB_MASTER_tb ();
    reg HCLK,HRESETn;
    reg [31:0]DATA,OPCODE,HRDATA;
    reg HREADY;
    wire [31:0]HWDATA,HADDR,RESPONSE;
    wire [4:0]RESPONSE_ADDR;
    wire HWRITE,REG_ENABLE,REG_WRITE,DONE,WAIT;

    initial begin
        HCLK = 0;
        forever begin
            #1 HCLK = ~HCLK;
        end
    end

    AHB_MASTER dut (.HCLK(HCLK),.HRESETn(HRESETn),.DATA(DATA),.OPCODE(OPCODE),.HRDATA(HRDATA),.HREADY(HREADY),.HWDATA(HWDATA),.HADDR(HADDR),.RESPONSE(RESPONSE),.RESPONSE_ADDR(RESPONSE_ADDR),.HWRITE(HWRITE),.REG_ENABLE(REG_ENABLE),.REG_WRITE(REG_WRITE),.DONE(DONE),.WAIT(WAIT));

    initial begin
        HRESETn=0;
        OPCODE = 32'b11111100010101010101010101010101;
        @(posedge HCLK);
        HRESETn=1;
        @(posedge HCLK);
        test_read1();
        @(posedge HCLK);
        test_write1();
        @(posedge HCLK);
        test_write_burst();
        @(posedge HCLK);
        test_read_burst();
        @(posedge HCLK);
        $stop;
    end

    task test_read1;
    ///testing a read///
    begin
    OPCODE = 32'b10001100010101010101010101010101;
    DATA = $random;
    HRDATA = $random;
    HREADY = 1;
    @(negedge HCLK);
    @(negedge HCLK);
    OPCODE = 32'b11111100010101010101010101010101;
    end
    endtask
    task test_write1;
    begin
    OPCODE = 32'b10101100010101010101010101010101;
    DATA = $random;
    HRDATA = $random;
    HREADY = 1;
    @(negedge HCLK);
    @(negedge HCLK);
    OPCODE = 32'b11111100010101010101010101010101;
    end
    endtask
    task test_write_burst;
    begin
    OPCODE = 32'b10000000010101010101010101010101;
    DATA = $random;
    HRDATA = $random;
    HREADY = 1;
    @(posedge HCLK);
    DATA = $random;
    @(posedge HCLK);
    DATA = $random;
    @(posedge HCLK);
    DATA = $random;
    OPCODE = 32'b11111100010101010101010101010101;
    @(posedge HCLK);
    @(negedge HCLK);
    OPCODE = 32'b11111100010101010101010101010101;
    @(posedge HCLK);
    end
    endtask
    task test_read_burst;
    begin
    OPCODE = 32'b10000100010101010101010101010101;
    DATA = $random;
    HRDATA = $random;
    HREADY = 1;
    @(posedge HCLK);
    HRDATA = $random;
    @(posedge HCLK);
    HRDATA = $random;
    @(posedge HCLK);
    HRDATA = $random;
    OPCODE = 32'b11111100010101010101010101010101;
    @(posedge HCLK);
    HRDATA = $random;
    @(negedge HCLK);
    @(posedge HCLK);
    end
    endtask
endmodule