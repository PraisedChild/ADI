module Wrapper (
    input clk,rst,data_valid,
    input [31:0] in,
    input [7:0] n,
    output receive_flag
);
    wire [7:0]prbs_out;
    PRBS prbs (.clk(clk),.rst(rst),.data_valid(data_valid),.in(in),.n(n),.PRBS_OUT(prbs_out));
    Receiver rcv (.clk(clk),.rst(rst),.in(prbs_out),.n(n),.receive_flag(receive_flag));
    
endmodule