package alu_seq_item_pkg;
import uvm_pkg::*;
 `include "uvm_macros.svh"


typedef enum bit [1:0] {ADD, SUB, MULT, DIV} opcode_e;
typedef enum  { MAXPOS = 1, ZERO = 0} reg_e;

class alu_seq_item extends uvm_sequence_item;
 `uvm_object_utils(alu_seq_item)
bit clk;
rand bit rst, ;
rand logic A, B;
rand opcode_e opcode;
logic [1:0] out;

  function new(string name = "alu_seq_item");
  super.new(name);
  endfunction

  function string convert2string();
   return $sformatf("%s rst= 0b%0b, opcode=0b%0b, A=0b%0b, B=0b%0b, out=0b%0b"
                    , super.convert2string, rst, opcode, A, B, out);
   endfunction

  function string convert2string_stimulus();
   return $sformatf("rst= 0b%0b, opcode=0b%0b, A=0b%0b, B=0b%0b", 
   rst, opcode, A, B);
   endfunction

 constraint con_block {
    rst dist {1:= 2, 0:= 98};

    opcode dist {ADD:=25, SUB:=25, MULT:=25, DIV:=25};

    (opcode == DIV) -> B != 0;

 }


  endclass
endpackage