module SYSTEM_tb ();
    reg [31:0] DATA,OPCODE;
    reg HCLK,HRESETn;
    wire [4:0]RESPONSE_ADDR;
    wire REG_ENABLE,REG_WRITE,DONE,WAIT;
    wire [31:0]RESPONSE;

    initial begin
        HCLK = 0;
        forever begin
            #1 HCLK = ~HCLK;
        end
    end

    SYSTEM sys (
        .DATA(DATA),
        .OPCODE(OPCODE),
        .RESPONSE(RESPONSE),
        .HCLK(HCLK),
        .HRESETn(HRESETn),
        .RESPONSE_ADDR(RESPONSE_ADDR),
        .REG_ENABLE(REG_ENABLE),
        .REG_WRITE(REG_WRITE),
        .DONE(DONE),
        .WAIT(WAIT)
        );

    initial begin
        HRESETn = 0;
        OPCODE = 32'b11111100000000000000000000000001;
        @(posedge HCLK);
        DATA = $random;
        HRESETn = 1;
        @(posedge HCLK);
        test_write();
        @(posedge HCLK);
        @(posedge HCLK);
        test_read();
        @(posedge HCLK);
        @(posedge HCLK);
        $stop;
    end


    task test_write;
    begin
    OPCODE = 32'b10101100000000000000000000000001;
    DATA = $random;
    @(posedge HCLK);
    @(posedge HCLK);
    OPCODE = 32'b11111100000000000000000000000001;
    end
    endtask

    task test_read;
    ///testing a read///
    begin
    OPCODE = 32'b10001100000000000000000000000001;
    DATA = $random;
    @(posedge HCLK);
    @(posedge HCLK);
    OPCODE = 32'b11111100000000000000000000000001;
    end
    endtask
endmodule
