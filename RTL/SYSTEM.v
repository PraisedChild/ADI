module SYSTEM (
    input [31:0] DATA,OPCODE,
    input HCLK,HRESETn,
    output [4:0]RESPONSE_ADDR,
    output REG_ENABLE,REG_WRITE,DONE,WAIT,
    output [31:0]RESPONSE
);
    wire HREADY,HWRITE,HTRANS,HBURST,HSEL1,HSEL2,MUX_SEL,HREADYOUT_1,HREADYOUT_2;
    wire [31:0] HWDATA,HADDR,HRDATA,HRDATA_1,HRDATA_2;

    AHB_MASTER mstr (
        .HREADY(HREADY),
        .HWDATA(HWDATA),
        .HADDR(HADDR),
        .HWRITE(HWRITE),
        .HTRANS(HTRANS),
        .HBURST(HBURST),
        .HCLK(HCLK),
        .HRESETn(HRESETn),
        .DATA(DATA),
        .OPCODE(OPCODE),
        .RESPONSE(RESPONSE),
        .RESPONSE_ADDR(RESPONSE_ADDR),
        .REG_ENABLE(REG_ENABLE),
        .REG_WRITE(REG_WRITE),
        .DONE(DONE),
        .WAIT(WAIT),
        .HRDATA(HRDATA)
        );
    Memory mem_slave (
        .HWRITE(HWRITE),
        .HCLK(HCLK),
        .HRESETn(HRESETn),
        .HSEL1(HSEL1),
        .HBURST(HBURST),
        .HTRANS(HTRANS),
        .HADDR(HADDR[30:0]),
        .HWDATA(HWDATA),
        .HRDATA(HRDATA_1),
        .HREADY(HREADY_1)
        );
    UART dummy_slave (
        .HWRITE(HWRITE),
        .HCLK(HCLK),
        .HRESETn(HRESETn),
        .HSEL1(HSEL2),
        .HBURST(HBURST),
        .HTRANS(HTRANS),
        .HADDR(HADDR),
        .HWDATA(HWDATA),
        .HRDATA(HRDATA_2),
        .HREADY(HREADY_2)
        );
    AHB_Decoder decode (
        .HADDR(HADDR[31]),
        .HSEL_1(HSEL1),
        .HSEL_2(HSEL2),
        .MUX_SEL(MUX_SEL)
        );
    AHB_MUX mux (
        .HRDATA_1(HRDATA_1),
        .HRDATA_2(HRDATA_2),
        .HREADYOUT_1(HREADY_1),
        .HREADYOUT_2(HREADY_2),
        .MUX_SEL(MUX_SEL),
        .HRDATA(HRDATA),
        .HREADY(HREADY)
        );
    
endmodule
