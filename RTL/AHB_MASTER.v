module AHB_MASTER (
    input HCLK,HRESETn,
    input [31:0] DATA,OPCODE,HRDATA,
    input HREADY,
    output [31:0]HWDATA,HADDR,RESPONSE,
    output [4:0]RESPONSE_ADDR,
    output HWRITE,REG_ENABLE,REG_WRITE,DONE,WAIT
);
    
    wire ENABLE_WIRE,WRITE_WIRE,BURST_WIRE,HWRITE_WIRE,BUSY_WIRE;
    wire [5:0]STATE_WIRE;

    MIPS_Controller top_interface (.OPCODE(OPCODE[31:26]),.BURST(BURST_WIRE),.ENABLE(ENABLE_WIRE),.WRITE(WRITE_WIRE),.BUSY(BUSY_WIRE));
    AHB_FSM top_fsm (.HCLK(HCLK),.HRESETn(HRESETn),.ENABLE(ENABLE_WIRE),.WRITE(WRITE_WIRE),.HREADY(HREADY),.BURST(BURST_WIRE),.MIPS_BUSY(BUSY_WIRE),.STATE(STATE_WIRE));
    AHB_READ_HANDLER top_rhandler (.state(STATE_WIRE),.HRDATA(HRDATA),.HCLK(HCLK),.HREADY(HREADY),.HRESETn(HRESETn),.ADDR(OPCODE[25:0]),.RESPONSE(RESPONSE),.RESPONSE_ADDR(RESPONSE_ADDR),.REG_ENABLE(REG_ENABLE),.REG_WRITE(REG_WRITE));
    AHB_WRITE_HANDLER top_whandler (.state(STATE_WIRE),.DATA(DATA),.HCLK(HCLK),.HREADY(HREADY),.HRESETn(HRESETn),.ADDR(OPCODE[25:0]),.HWDATA(HWDATA),.HADDR(HADDR),.HWRITE(HWRITE),.DONE(DONE),.WAIT(WAIT));
endmodule