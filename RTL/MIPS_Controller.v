module MIPS_Controller (
    input [5:0]OPCODE,
    output BURST,ENABLE,WRITE,BUSY
);
    ///available OPCODES list///
    //////OPCODES 100011 > lw (one word), 101011 > sw (one word), 
    // 100001 > lw(burst incr4 cache), 100000 > sw (burst incr4 cache), 
    // 000000 > BUSY///

    assign ENABLE = (OPCODE == 6'b100011 || OPCODE == 6'b100000 || OPCODE == 6'b101011 || OPCODE == 6'b100001);
    assign BURST = (OPCODE == 6'b100000 || OPCODE == 6'b100001);
    assign WRITE = (OPCODE == 6'b100000 || OPCODE == 6'b101011);
    assign BUSY = (OPCODE==6'b000000);
    
endmodule