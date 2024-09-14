module AHB_READ_HANDLER (
    input [5:0]state,
    input [31:0]HRDATA,
    input HCLK,HREADY,HRESETn,
    input [25:0]ADDR,
    output reg [31:0]RESPONSE,
    output reg [4:0]RESPONSE_ADDR,
    output reg REG_ENABLE, REG_WRITE
);
    reg [4:0]STORED_ADDR;
    reg BURST_ON,SINGLE_ON;
    
    localparam IDLE = 6'b000001;
    localparam SBURSTW = 6'b000010;
    localparam SBURSTR = 6'b000100;
    localparam INCRBW = 6'b001000;
    localparam INCRBR = 6'b010000;
    localparam BUSY = 6'b100000;

    always@(posedge HCLK or negedge HRESETn)begin
        if(!HRESETn)begin
            RESPONSE<=0;
            RESPONSE_ADDR<=0;
            REG_ENABLE<=0;
            REG_WRITE<=0;
            STORED_ADDR<=0;
            BURST_ON<=0;
            SINGLE_ON<=0;
        end
        else begin
        if(!SINGLE_ON && !BURST_ON)begin
            REG_ENABLE<=0;
            REG_WRITE<=0;
            STORED_ADDR<=0;
        end
        if(HREADY && SINGLE_ON)begin
            RESPONSE<=HRDATA;
            RESPONSE_ADDR<=STORED_ADDR;
            REG_ENABLE<=1;
            REG_WRITE<=1;
            SINGLE_ON<=0;
        end
        if(BURST_ON && HREADY)begin
            RESPONSE_ADDR<=STORED_ADDR;
            STORED_ADDR<=STORED_ADDR+4;
            RESPONSE<=HRDATA;
            REG_ENABLE<=1;
            REG_WRITE<=1;
        end
        end
    end
    always@(posedge HCLK or negedge HRESETn)begin
        if(state == SBURSTR)begin
            STORED_ADDR<=ADDR[25:21];
            SINGLE_ON<=1;
        end
        if(state == INCRBR)begin
            if(!BURST_ON)begin
            STORED_ADDR<=ADDR[25:21];
            BURST_ON<=1;
            end
        end
        else 
        BURST_ON<=0;
    end
endmodule