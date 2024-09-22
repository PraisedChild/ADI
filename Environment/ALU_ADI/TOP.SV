import uvm_pkg::*;
 `include "uvm_macros.svh"
import alu_test_pkg::*;

module top();
bit clk;
initial begin
    forever 
    #1 clk = ~clk;
end
alu_if aluif(clk);


ALU DUT (clk, aluif.rst, aluif.A, aluif.B, aluif.opcode,
             , aluif.out);
             
bind ALU alu_sva alu_SVA_INST(clk, rst, A, B, opcode, out);

initial begin
    uvm_config_db#(virtual alu_if)::set(null, "uvm_test_top", "alu_IF", aluif);

    run_test("alu_test");
end

endmodule 