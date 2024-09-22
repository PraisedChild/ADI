package alu_env_pkg;
import alu_agent_pkg::*;
import alu_coverage_pkg::*;
import alu_scoreboard_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class alu_env extends uvm_env;
 `uvm_component_utils(alu_env)


 alu_agent agt;
 alu_scoreboard sb;
 alu_coverage cov;

 function new (string name = "alu_env", uvm_component parent = null);
    super.new(name, parent);
    endfunction

   function void build_phase(uvm_phase phase);
   super.build_phase(phase);
   agt= alu_agent::type_id::create("agt", this);
   sb= alu_scoreboard::type_id::create("sb", this);
   cov= alu_coverage::type_id::create("cov", this);
   endfunction : build_phase;

   function void connect_phase (uvm_phase phase);
      agt.agt_ap.connect(sb.sb_export);
      agt.agt_ap.connect(cov.cov_export);
   endfunction
    endclass
    endpackage