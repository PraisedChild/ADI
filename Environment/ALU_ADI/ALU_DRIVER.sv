package alu_driver_pkg;
import alu_seq_item_pkg::*;
import uvm_pkg::*;
 `include "uvm_macros.svh"

class alu_driver extends uvm_driver #(alu_seq_item);
`uvm_component_utils(alu_driver)

virtual alu_if alu_vif;
alu_config alu_cfg;
alu_seq_item stim_seq_item;

function new(string name = "alu_driver", uvm_component parent = null);
super.new(name,parent);
endfunction

task run_phase(uvm_phase phase);
super.run_phase(phase);
        forever begin
 stim_seq_item= alu_seq_item::type_id::create("stim_seq_item");
 seq_item_port.get_next_item(stim_seq_item);
 alu_vif.rst = stim_seq_item.rst;
 alu_vif.opcode = stim_seq_item.opcode;
 alu_vif.out = stim_seq_item.out;
    @(negedge alu_vif.clk);
    seq_item_port.item_done();
    `uvm_info("run_phase", stim_seq_item.convert2string(), UVM_HIGH)
  end
endtask
  endclass
endpackage  