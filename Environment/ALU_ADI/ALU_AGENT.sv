package alu_agent_pkg;
import MySequencer_pkg::*;
import alu_seq_item_pkg::*;
import alu_driver_pkg::*;
import alu_monitor_pkg::*;
import alu_config_pkg::*;
import uvm_pkg::*;
 `include "uvm_macros.svh"
 class alu_agent extends uvm_agent;
    `uvm_component_utils(alu_agent)
    MySequencer sqr;
    alu_driver drv;
    alu_monitor mon;
    alu_config alu_cfg;
    uvm_analysis_port #(alu_seq_item) agt_ap;

    function new (string name = "alu_agent", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db #(alu_config)::get(this , "", "CFG", alu_cfg))
            `uvm_fatal("build_phase", "Unable to get configuration object")

        sqr = MySequencer::type_id::create("sqr", this);
        drv = alu_driver::type_id::create("drv", this);
        mon = alu_monitor::type_id::create("mon",this);
        agt_ap = new("agt_ap", this);
        endfunction
    
    function void connect_phase(uvm_phase phase);
    drv.alu_vif = alu_cfg.alu_vif;
    mon.alu_vif = alu_cfg.alu_vif;
    drv.seq_item_port.connect(sqr.seq_item_export);
    mon.mon_ap.connect(agt_ap);
    endfunction

 endclass
endpackage