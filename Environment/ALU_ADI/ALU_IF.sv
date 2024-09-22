interface alu_if (clk);
  input clk;
logic rst;
logic [2:0] opcode;
logic A, B;
logic [1:0] out;

// modport DUT (input A, B, clk, rst, 
//               output out);
// modport TEST (output A, B, rst, 
//               input clk, out);
endinterface : alu_if