module PRBS (
    input clk,rst,data_valid,
    input [31:0] in,
    input [7:0] n,
    output [7:0]PRBS_OUT
);

    wire mux_sel,sequence_enable,sequence_done;
    wire [31:0] sequence_data;
    wire [7:0] out_est,out_rand,sequence_num;

    MUX2 mux0 (.mux_sel(mux_sel),.in_est(out_est),.in_rand(out_rand),.out(PRBS_OUT));
    LFSR lfsr0 (.clk(clk),.rst(rst),.seed(in[14:0]),.block_enable(mux_sel),.out_rand(out_rand));
    Sequencer seq0 (.clk(clk),.rst(rst),.Seq_en(sequence_enable),.in(sequence_data),.n(sequence_num),.Seq_done(sequence_done),.Sequence(out_est));
    Control_Unit CU0 (.clk(clk),.rst(rst),.in(in),.n(n),.data_valid(data_valid),.seq_enable(sequence_enable),.seq_done(sequence_done),.rand_flag(mux_sel), .seq_data(sequence_data),.seq_num(sequence_num));
endmodule