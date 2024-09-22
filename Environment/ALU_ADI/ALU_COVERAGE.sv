package alu_coverage_pkg;
import alu_agent_pkg::*;
import alu_seq_item_pkg::*;
import MySequencer_pkg::*;
import uvm_pkg::*;
 `include "uvm_macros.svh"

typedef enum bit [1:0] {ADD, SUB, MULT, DIV} opcode_e;
typedef enum  { MAXPOS = 1, ZERO = 0} reg_e;


class alu_coverage extends uvm_component;
 `uvm_component_utils(alu_coverage)

uvm_analysis_export #(alu_seq_item) cov_export;
uvm_tlm_analysis_fifo #(alu_seq_item) cov_fifo;
alu_seq_item seq_item_cov;


covergroup cvr_grp;
    A_cvp_values_ADD_MULT : coverpoint seq_item_cov.A{
        bins A_data_0 = {0};
        bins A_data_max = {MAXPOS};
        bins A_data_default = default;
    }


    B_cvp_values_ADD_MULT : coverpoint seq_item_cov.B{
        bins B_data_0 = {0};
        bins B_data_max = {MAXPOS};
        bins B_data_default = default;
    }

    opcode_cvp_values : coverpoint seq_item_cov.opcode {
        bins bins_arith[] = {ADD, SUB, MULT, DIV};
        bins opcode_valid_trans = (ADD => SUB => MULT => DIV);
    }

    function new(string name = "alu_coverage", uvm_component parent = null);
        super.new(name, parent);
        cvr_grp = new();
        endfunction

    function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    cov_export= new("cov_export", this);
    cov_fifo = new("cov_fifo", this);
    endfunction

    function void connect_phase (uvm_phase phase);
        super.connect_phase(phase);
        cov_export.connect(cov_fifo.analysis_export);
        endfunction

        task run_phase (uvm_phase phase);
        super.run_phase(phase);
        forever begin
            cov_fifo.get(seq_item_cov);
            cvr_grp.sample();
            end
        endtask
 endclass
endpackage