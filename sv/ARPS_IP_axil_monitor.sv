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

    // start and stop helper events   KOMENTARI
//    event start_e;
//    event stop_e;
    
    // UVM factory registration
    `uvm_component_utils_begin(ARPS_IP_axil_monitor)
        `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_component_utils_end    
 

//START
/*       
    // coverage
    covergroup cg_ARPS_IP_monitor;
        // cover direction - read or write
        cp_direction : coverpoint tr_collected.dir {
            bins write = {ARPS_IP_WRITE};
            bins read  = {ARPS_IP_READ};
        }
        // cover address ack
        cp_addr_ack : coverpoint tr_collected.addr_ack {
            bins ack  = {ARPS_IP_ACK};
            bins nack = {ARPS_IP_NACK};            
        }
        // cover data ack
        cp_data_ack : coverpoint tr_collected.data_ack {
            bins ack  = {ARPS_IP_ACK};
            bins nack = {ARPS_IP_NACK};            
        }        
        // TODO : add others
    endgroup : cg_ARPS_IP_monitor;


*/
//FINISH

    // new - constructor
    function new(string name = "ARPS_IP_axil_monitor", uvm_component parent = null);
        super.new(name, parent);
        item_collected_port = new("item_collected_port", this);
       // cg_ARPS_IP_monitor = new(); ------------------------------------------------komentttt
		//write_address = new();
		//read_address = new();
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


    extern virtual task run_phase(uvm_phase phase); // dodato nakaknadno, vec dole postoji

//START
/*

    // additional class methods
    extern virtual task start_condition(ref event start_e);
    extern virtual task stop_condition(ref event stop_e);
//    extern virtual task run_phase(uvm_phase phase);
    extern virtual task collect_transactions();
    extern virtual function void report_phase(uvm_phase phase);

*/
//FINISH

endclass : ARPS_IP_axil_monitor

// UVM run_phase
task ARPS_IP_axil_monitor::run_phase(uvm_phase phase);    
    forever begin
//START
		tr_current = ARPS_IP_axil_transaction::type_id::create("tr_current", this);
		@(posedge vif.clk)begin
			if(vif.s_axi_awready )begin
               `uvm_info(get_name(), $sformatf("write address: %d", vif.s_axi_awaddr), UVM_LOW)
				address = vif.s_axi_awaddr;               
//				write_address.sample();
			end
			if(vif.s_axi_arready)
				address = vif.s_axi_araddr;
			if(vif.s_axi_rvalid)begin
//				read_address.sample();
				tr_current.rdata = vif.s_axi_rdata;
				tr_current.addr = address;
				item_collected_port.write(tr_current);

               `uvm_info(get_name(), $sformatf("read address: %d \t read_data: %d", address, vif.s_axi_rdata), UVM_LOW)               
			end
		end
  
    end
endtask : run_phase

`endif

