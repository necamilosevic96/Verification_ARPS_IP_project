/*******************************************************************************
 +-+-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+-+-+-+-+ +-+-+ +-+-+-+-+-+-+-+-+
 |F|u|n|c|t|i|o|n|a|l| |V|e|r|i|f|i|c|a|t|i|o|n| |o|f| |H|a|r|d|w|a|r|e|
 +-+-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+-+-+-+-+ +-+-+ +-+-+-+-+-+-+-+-+

 FILE            ARPS_IP_interrupt_agent.sv

 DESCRIPTION     

 *******************************************************************************/

`ifndef ARPS_IP_INTERRUPT_AGENT_SV
 `define ARPS_IP_INTERRUPT_AGENT_SV

class ARPS_IP_interrupt_agent extends uvm_agent;

   ARPS_IP_interrupt_monitor interrupt_mon;

   `uvm_component_utils_begin (ARPS_IP_interrupt_agent)
   `uvm_component_utils_end

   function new(string name = "ARPS_IP_interrupt_agent", uvm_component parent = null);
      super.new(name,parent);
   endfunction

   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      interrupt_mon = ARPS_IP_interrupt_monitor::type_id::create("interrupt_monitor", this);
   endfunction : build_phase

   function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
   endfunction : connect_phase

endclass : ARPS_IP_interrupt_agent

`endif

