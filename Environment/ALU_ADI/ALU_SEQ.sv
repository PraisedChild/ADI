package alu_seq_pkg;
import alu_seq_item_pkg::*;
import uvm_pkg::*;
 `include "uvm_macros.svh"

 class alu_reset_seq extends uvm_sequence #(alu_seq_item);
 `uvm_object_utils(alu_reset_seq);
 alu_seq_item seq_item;

 function new (string name = "alu_seq");
 super.new(name);
 endfunction

 task body; 
 seq_item = alu_seq_item::type_id::create("seq_item");
 start_item(seq_item);
 seq_item.rst = 1;
 seq_item.A = 0;
 seq_item.B = 0;
 seq_item.opcode = 0;
 finish_item(seq_item);
 endtask
 endclass
 

 class alu_main_seq extends uvm_sequence #(alu_seq_item);
 `uvm_object_utils(alu_main_seq);
 alu_seq_item seq_item;

 function new (string name = "alu_main_seq");
 super.new(name);
 endfunction

 task body(); 
    for (i = 0 ; i<4 ; i++ ) begin
        seq_item.opcode=i;
        seq_item.A= 0; seq_item.B= 0;
        @(negedge seq_item.clk);
        seq_item.A= 1; seq_item.B= 0;
        @(negedge seq_item.clk);
        seq_item.A= 1; seq_item.B= 1;
        @(negedge seq_item.clk);
        seq_item.A= 0; seq_item.B= 1;
        @(negedge seq_item.clk);
    end
 repeat(1000) begin
    seq_item = alu_seq_item::type_id::create("seq_item");
  start_item(seq_item);
  assert(seq_item.randomize());
 finish_item(seq_item);
 end
 

 endtask
 endclass



endpackage