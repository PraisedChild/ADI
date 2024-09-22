package alu_test_pkg;
import alu_env_pkg::*;
import alu_config_pkg::*;
import alu_seq_item_pkg::*;
import alu_seq_pkg::*;
import uvm_pkg::*;
 `include "uvm_macros.svh"


class alu_test extends uvm_test;
    `uvm_component_utils(alu_test)

    alu_env env;
    alu_config alu_cfg;
    virtual alu_if alu_vif;
    alu_main_seq main_seq;
    alu_reset_seq reset_seq;

    function new(string name = "alu_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction //new()

    function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = alu_env::type_id::create("env", this);
    alu_cfg = alu_config::type_id::create("alu_cfg", this);
    main_seq= alu_main_seq::type_id::create("main_seq", this);
    reset_seq= alu_reset_seq::type_id::create("reset_seq", this);

    if(!uvm_config_db #(virtual alu_if)::get(this, "", "alu_IF", alu_cfg.alu_vif))
       `uvm_fatal("build_phase", "Test_Unable to get virtual interface");

       uvm_config_db #(alu_config)::set(this, "*", "CFG", alu_cfg);
    endfunction


    task run_phase (uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);

 `uvm_info("run_phase", "Welcome to the UVM ENV.", UVM_MEDIUM)
    `uvm_info("run_phase", "Reset Asserted.", UVM_MEDIUM)
    reset_seq.start(env.agt.sqr);
    `uvm_info("run_phase", "Reset Deasserted.", UVM_MEDIUM)

`uvm_info("run_phase", "Stimulus Generation Started.", UVM_MEDIUM)
    main_seq.start(env.agt.sqr);
`uvm_info("run_phase", "Stimulus Generation Ended.", UVM_MEDIUM)
    phase.drop_objection(this);
    endtask : run_phase


endclass: alu_test 
endpackage