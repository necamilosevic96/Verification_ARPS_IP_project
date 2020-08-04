/*******************************************************************************
 +-+-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+-+-+-+-+ +-+-+ +-+-+-+-+-+-+-+-+
 |F|u|n|c|t|i|o|n|a|l| |V|e|r|i|f|i|c|a|t|i|o|n| |o|f| |H|a|r|d|w|a|r|e|
 +-+-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+-+-+-+-+ +-+-+ +-+-+-+-+-+-+-+-+

 FILE            ARPS_IP_interrupt_monitor.sv

 DESCRIPTION     

 *******************************************************************************/

`ifndef ARPS_IP_INTERRUPT_MONITOR_SV
 `define ARPS_IP_INTERRUPT_MONITOR_SV

class ARPS_IP_interrupt_monitor extends uvm_monitor;

   // control fileds
   bit checks_enable = 1;
   bit coverage_enable = 1;

   uvm_analysis_port #(ARPS_IP_interrupt_transaction) item_collected_port;

   `uvm_component_utils_begin(ARPS_IP_interrupt_monitor)
      `uvm_field_int(checks_enable, UVM_DEFAULT)
      `uvm_field_int(coverage_enable, UVM_DEFAULT)
   `uvm_component_utils_end

   // The virtual interface used to drive and view HDL signals.
   virtual interface interrupt_if vif;

   // current transaction
   ARPS_IP_interrupt_transaction current_frame;

/*   // coverage can go here
   covergroup interrupt_cg;
      option.per_instance = 1;
      interrupt_cpt: coverpoint vif.done_interrupt{
         bins interrupt_happened = {1};
      }      
   endgroup
   // ...
*/
   function new(string name = "ARPS_IP_interrupt_monitor", uvm_component parent = null);
      super.new(name,parent);
      item_collected_port = new("item_collected_port", this);
      //interrupt_cg = new();      
   endfunction

   function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      if (!uvm_config_db#(virtual interrupt_if)::get(this, "*", "interrupt_if", vif))
        `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"})
   endfunction : connect_phase

   task run_phase(uvm_phase phase);
      forever begin
	 current_frame = ARPS_IP_interrupt_transaction::type_id::create("current_frame", this);
	 // ...
	 // collect transactions
	 // ...
	 @(posedge vif.clk)begin
		
		current_frame.interrupt_flag=vif.interrupt_o;
	 
	    if(vif.interrupt_o)begin
	       `uvm_info(get_type_name(),
			 $sformatf("INTERRUPT HAPPENED"),
			 UVM_FULL)
	       //interrupt_cg.sample();          
	       item_collected_port.write(current_frame);
	    end
	 end
      end
   endtask : run_phase

endclass : ARPS_IP_interrupt_monitor

`endif

