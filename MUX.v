module MUX2 (
    input mux_sel, 
    input [7:0] in_est, in_rand,
    output [7:0]out
);

    assign out = (mux_sel)? in_rand:in_est;
    
endmodule