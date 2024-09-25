module Memory (
    input HWRITE,HCLK,HRESETn,HREADY_Prev,HSEL1,HBURST,HTRANS,
    input [30:0]HADDR,
    input [31:0]HWDATA,
    output reg [31:0]HRDATA,
    output reg HREADY
);
    //we will only use 1 slave, but will keep the other as dummy to use the MUX and Decoder
    
    reg [31:0] mem1 [30:0];

    typedef enum bit [2:0] {
        IDLE = 3'b001,
        ACTIVE_READ = 3'b010,
        ACTIVE_WRITE = 3'b100
    } state_e;

    state_e cs,ns;
    reg [30:0] ADDR;
    register add_reg (.D(HADDR),.CLK(HCLK),.Q(ADDR));

    always @(posedge HCLK or negedge HRESETn) begin
            if(!HRESETn)begin
                cs<=IDLE;
            end
            else
                cs<=ns;
    end

    always@(*)begin
        case(cs)
        IDLE:begin
            HRDATA=0;
            HREADY=1;
        end
        ACTIVE_READ:begin
            
            HREADY = 1;
        end
        ACTIVE_WRITE:begin
            HREADY = 1;
            HRDATA = 0;
        end
        default:begin
            HRDATA = 0;
            HREADY = 1;
        end 
        endcase
    end

    always@(posedge HCLK)begin
            if(cs == ACTIVE_WRITE) begin
                mem1 [ADDR] = HWDATA;
            end
    end

    always@(*)begin
        case(cs)
        IDLE:begin
            if(!HTRANS)begin
                ns = IDLE;
            end
            else begin
                if(HWRITE)begin
                    ns = ACTIVE_WRITE;
                end
                else begin
                    ns = ACTIVE_READ;
                    HRDATA = mem1[ADDR];
                end
            end
        end
        ACTIVE_READ:begin
            if(HBURST)
                ns = ACTIVE_READ;
            else begin
                if(!HTRANS)
                    ns = IDLE;
                else begin
                    if(HWRITE)
                        ns = ACTIVE_WRITE;
                    else 
                        ns = ACTIVE_READ;
                end
            end
            
        end
        ACTIVE_WRITE:begin
            if(HBURST)
                ns = ACTIVE_WRITE;
            else begin
                if(!HTRANS)
                    ns = IDLE;
                else begin
                    if(HWRITE)
                        ns = ACTIVE_WRITE;
                    else 
                        ns = ACTIVE_READ;
                end
            end
        end
        default:begin
            ns = IDLE;
        end
        endcase
    end

endmodule

module register (
    input [30:0] D,
    input CLK,
    output reg [30:0]Q
);
    always@(posedge CLK)begin
        Q<=D;
    end
endmodule
