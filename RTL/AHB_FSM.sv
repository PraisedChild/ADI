module AHB_FSM (
    input HCLK,HRESETn,ENABLE,WRITE,HREADY,BURST,MIPS_BUSY,
    output [5:0]STATE
);
    
    typedef enum bit [5:0] {
        IDLE = 6'b000001,
        SBURSTW = 6'b000010,
        SBURSTR = 6'b000100,
        INCRBW = 6'b001000,
        INCRBR = 6'b010000,
        BUSY = 6'b100000
    } state_e;

    state_e cs,ns,SAVED_STATE;

    ///STATE MEMORY///
    always@(posedge HCLK or negedge HRESETn)begin
        if(!HRESETn)
        cs<=IDLE;
        else
        cs<=ns;
    end
    assign STATE = cs;

    always@(posedge HCLK or negedge HRESETn)begin
        if(!HRESETn)begin
            SAVED_STATE<=IDLE;
        end
        else begin
            if(cs!=BUSY)
            SAVED_STATE<=cs;
        end
    end
    ///NEXT STATE LOGIC///
    reg HOLD;

    always@(*)begin
        case(cs)
        IDLE: begin
            if(ENABLE && !MIPS_BUSY)begin
                if(WRITE&&BURST)
                ns = INCRBW;
                else if(!WRITE&&BURST)
                ns = INCRBR;
                else if(!WRITE)
                ns = SBURSTR;
                else
                ns = SBURSTW;
            end
            else
            ns = IDLE;
        end
        SBURSTW: begin
            if(!ENABLE || MIPS_BUSY)
            ns=IDLE;
            else begin
                if(WRITE&&BURST)
                ns = INCRBW;
                else if(!WRITE&&BURST)
                ns = INCRBR;
                else if(!WRITE)
                ns = SBURSTR;
                else
                ns = SBURSTW;
            end
        end
        SBURSTR: begin
            if(!ENABLE || MIPS_BUSY)
            ns = IDLE;
            else begin
                if(WRITE&&BURST)
                ns = INCRBW;
                else if(!WRITE&&BURST)
                ns = INCRBR;
                else if(!WRITE)
                ns = SBURSTR;
                else
                ns = SBURSTW;
            end
        end
        INCRBW: begin
            if(MIPS_BUSY)begin
                ns = BUSY;
                SAVED_STATE = INCRBW;
                // HOLD = 1;
            end
            else if(!HREADY)begin
                ns = INCRBW;
                // HOLD = 1; //to hold data and address while we wait for the slave to be ready
            end
            else if(!ENABLE)begin
                ns = IDLE;
                // HOLD = 0;
            end
            else if(ENABLE && WRITE && BURST)begin
                ns = INCRBW;
            end
            else if(ENABLE && !WRITE && BURST)begin
                ns = INCRBR;
            end
            else if(ENABLE && WRITE)
            ns = SBURSTW;
            else if (ENABLE && !WRITE)
            ns = SBURSTR;
            else 
            ns = IDLE;
        end
        INCRBR:begin
            if(MIPS_BUSY)begin
                ns = BUSY;
                SAVED_STATE = INCRBR;
                HOLD = 1;
            end
            else if(!HREADY)begin
                ns = INCRBR;
                HOLD = 1; //to hold data and address while we wait for the slave to be ready
            end
            else if(!ENABLE)begin
                ns = IDLE;
                HOLD = 0;
            end
            else if(ENABLE && WRITE && BURST)begin
                ns = INCRBW;
            end
            else if(ENABLE && !WRITE && BURST)begin
                ns = INCRBR;
            end
            else if(ENABLE && WRITE)
            ns = SBURSTW;
            else if (ENABLE && !WRITE)
            ns = SBURSTR;
            else 
            ns = IDLE;
        end
        BUSY:begin
            if(MIPS_BUSY)begin
                ns = BUSY;
            end
            else 
                ns = SAVED_STATE; 
        end
        default: begin
            ns = IDLE;
            HOLD = 0;
            SAVED_STATE = IDLE;
        end
        endcase
    end
endmodule