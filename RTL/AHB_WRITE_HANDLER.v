module AHB_WRITE_HANDLER (
    input [5:0]state,
    input [31:0]DATA,
    input HCLK,HREADY,HRESETn,
    input [25:0]ADDR,
    output reg [31:0]HWDATA,
    output [31:0]HADDR,
    //output reg HWRITE,
    output reg DONE,WAIT,HBURST
);
    reg [31:0]STORED_ADDR;
    reg BURST_ON;
    
    localparam IDLE = 6'b000001;
    localparam SBURSTW = 6'b000010;
    localparam SBURSTR = 6'b000100;
    localparam INCRBW = 6'b001000;
    localparam INCRBR = 6'b010000;
    localparam BUSY = 6'b100000;

    always@(posedge HCLK or negedge HRESETn)begin
        if(!HRESETn)begin
            //HWRITE<=0;
            HWDATA<=0;
            STORED_ADDR<=0;
            BURST_ON<=0;
            DONE<=1;
            WAIT<=0;
        end
        else begin
        if(DONE==0 && HREADY && !BURST_ON)begin
            DONE<=1;
            //HWRITE<=0;
        end
        else if(BURST_ON && HREADY)begin
            HWDATA<=DATA;
            WAIT<=0;
        end
        else
            WAIT<=1;
        end
        if(HREADY)
        WAIT<=0;

        if(state == SBURSTW)begin
            HWDATA<=DATA;
            DONE<=0;
            //HWRITE<=1;
        end
        if(state == INCRBW)begin
            if(!BURST_ON)begin
            BURST_ON<=1;
            //HWRITE<=1;
            DONE<=0;
            HWDATA<=DATA;
            HBURST<=1;
            end
        end
        if(BURST_ON && !(state == INCRBW || state == BUSY))begin
            BURST_ON<=0;
            if(state != SBURSTW)begin
            //HWRITE<=0;
            DONE<=1;
            HBURST<=0;
            end
        end    
    end

    assign HADDR = {11'b0,ADDR[20:0]};

    
endmodule
