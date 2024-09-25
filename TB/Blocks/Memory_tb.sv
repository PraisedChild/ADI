module Memory_tb ();
    reg HWRITE,HCLK,HRESETn,HREADY_Prev,HSEL1,HBURST,HTRANS;
    reg [30:0]HADDR;
    reg [31:0]HWDATA;
    wire [31:0]HRDATA;
    wire HREADY;

    initial begin
        HCLK = 0;
        forever begin
            #1 HCLK = ~HCLK;
        end
    end

    Memory dut (.HWRITE(HWRITE),.HCLK(HCLK),.HRESETn(HRESETn),.HREADY_Prev(HREADY_Prev),.HSEL1(HSEL1),.HBURST(HBURST),.HTRANS(HTRANS),.HADDR(HADDR),.HWDATA(HWDATA),.HRDATA(HRDATA),.HREADY(HREADY));

    initial begin
        reset();
        write();
        reset();
        read();
        reset();
        $stop;
    end

    task reset;
        HRESETn = 0;
        HSEL1 = 1;
        @(posedge HCLK);
        HRESETn = 1;
        HWRITE = 1;
        HTRANS = 0;
        HBURST = 0;
        HADDR = 0;
        HWDATA = $random;
        @(posedge HCLK);    
    endtask
    task write;
        HTRANS = 1;
        HWDATA = $random;
        @(posedge HCLK);
        @(posedge HCLK);
    endtask
    task read;
        HTRANS = 1;
        HWRITE = 0;
        @(posedge HCLK);
        @(posedge HCLK);
    endtask
endmodule