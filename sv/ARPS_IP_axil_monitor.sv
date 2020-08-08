/****************************************************************************
    +-+-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+-+-+-+-+ +-+-+ +-+-+-+-+-+-+-+-+
    |F|u|n|c|t|i|o|n|a|l| |V|e|r|i|f|i|c|a|t|i|o|n| |o|f| |H|a|r|d|w|a|r|e|
    +-+-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+-+-+-+-+ +-+-+ +-+-+-+-+-+-+-+-+

    FILE            ARPS_IP_monitor.sv

    DESCRIPTION     

 ****************************************************************************/

`ifndef ARPS_IP_AXIL_MONITOR_SV
`define ARPS_IP_AXIL_MONITOR_SV

/*
 * Class: ARPS_IP_monitor
 */
class ARPS_IP_axil_monitor extends uvm_monitor;
    
    // ARPS_IP virtual interface
    virtual axil_if vif;
    
    // configuration
    ARPS_IP_config cfg;
    
    // TLM - from monitor to other components
    uvm_analysis_port #(ARPS_IP_axil_transaction) item_collected_port;
    
    // keep track of number of transactions
    int unsigned num_transactions = 0;
	
	bit [3:0]	address;
    
    // current transaction
    ARPS_IP_axil_transaction tr_current;

    // UVM factory registration
    `uvm_component_utils_begin(ARPS_IP_axil_monitor)
        `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_component_utils_end    
     
    // coverage
    covergroup cg_axil_monitor;
        // cover direction - read or write
        cp_direction : coverpoint address {
            bins write = {0};
            bins read  = {4};
        }

    endgroup : cg_axil_monitor;

    // new - constructor
    function new(string name = "ARPS_IP_axil_monitor", uvm_component parent = null);
        super.new(name, parent);
        item_collected_port = new("item_collected_port", this);
        cg_axil_monitor = new();
    endfunction : new
    
    // UVM build_phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        // get configuration object from db
        if(!uvm_config_db#(ARPS_IP_config)::get(this, "", "ARPS_IP_config", cfg))
            `uvm_fatal("NOCONFIG",{"Config object must be set for: ",get_full_name(),".cfg"})
    endfunction: build_phase
    
    // UVM connect_phase
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        // get interface from db
        if(!uvm_config_db#(virtual axil_if)::get(this, "", "axil_if", vif))
            `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"})    
    endfunction : connect_phase

    extern virtual task run_phase(uvm_phase phase);

endclass : ARPS_IP_axil_monitor

// UVM run_phase
task ARPS_IP_axil_monitor::run_phase(uvm_phase phase);    
    forever begin

		tr_current = ARPS_IP_axil_transaction::type_id::create("tr_current", this);
		@(posedge vif.clk)begin
		
			if(vif.s_axi_awready )begin
               `uvm_info(get_name(), $sformatf("write address: %d", vif.s_axi_awaddr), UVM_LOW)
				address = vif.s_axi_awaddr;               
			end
			if(vif.s_axi_arready)
				address = vif.s_axi_araddr;

			if(vif.s_axi_rvalid)begin

				tr_current.rdata = vif.s_axi_rdata;
				tr_current.addr = address;
				item_collected_port.write(tr_current);
				
				cg_axil_monitor.sample();
              
			end
		end
  
    end
endtask : run_phase

`endif

