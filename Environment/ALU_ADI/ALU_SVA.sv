import uvm_pkg::*;
 `include "uvm_macros.svh"
`define n_rst disable iff(rst)
typedef enum bit [1:0] {ADD, SUB, MULT, DIV} opcode_e;
typedef enum  { MAXPOS = 1, ZERO = 0} reg_e;
module alu_sva (clk, rst, A, B, opcode, out);
input bit clk;
input logic rst;
input logic A,B;
input opcode_e opcode;
output logic [1:0] out;

ADDITION_ASSERT: assert property(@(posedge clk)) `n_rst opcode==ADD -> out == $past(A) + $past(B);

SUBTRACTION_ASSERT: assert property(@(posedge clk)) `n_rst opcode==SUB -> out == $past(A) - $past((B);

MULTIPLICATION_ASSERT: assert property(@(posedge clk)) `n_rst opcode==MULT -> out == $past(A) * $past(B);

DIVISION_ASSERT: assert property(@(posedge clk)) `n_rst opcode==DIV -> out == $past(A) / $past(B);

ADDITION_COVER: cover property(@(posedge clk)) `n_rst opcode==ADD -> out == $past(A) + $past(B);

SUBTRACTION_COVER: cover property(@(posedge clk)) `n_rst opcode==SUB -> out == $past(A) - $past(B);

MULTIPLICATION_COVER: cover property(@(posedge clk)) `n_rst opcode==MULT -> out == $past(A) * $past(B);

DIVISION_COVER: cover property(@(posedge clk)) `n_rst opcode==DIV -> out == $past(A) / $past(B);


always comb begin : Rst_Cover
if(rst)begin
   cover final (out=0);
end
endmodule