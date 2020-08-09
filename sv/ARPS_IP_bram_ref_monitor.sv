/****************************************************************************
    +-+-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+-+-+-+-+ +-+-+ +-+-+-+-+-+-+-+-+
    |F|u|n|c|t|i|o|n|a|l| |V|e|r|i|f|i|c|a|t|i|o|n| |o|f| |H|a|r|d|w|a|r|e|
    +-+-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+-+-+-+-+ +-+-+ +-+-+-+-+-+-+-+-+

    FILE            ARPS_IP_monitor.sv

    DESCRIPTION     

 ****************************************************************************/

`ifndef ARPS_IP_BRAM_REF_MONITOR_SV
`define ARPS_IP_BRAM_REF_MONITOR_SV

/*
 * Class: ARPS_IP_monitor
 */
class ARPS_IP_bram_ref_monitor extends uvm_monitor;
    
    // ARPS_IP virtual interface
    virtual bram_ref_if vif;
	
	logic [31:0]  address_r;
	logic [31:0]  data_r;
	
    // configuration
    ARPS_IP_config cfg;
    
    // TLM - from monitor to other components
    uvm_analysis_port #(ARPS_IP_bram_ref_transaction) item_collected_port;
    
    // keep track of number of transactions
    int unsigned num_transactions = 0;
    
    // current transaction
    ARPS_IP_bram_ref_transaction tr_collected_ref;

    // UVM factory registration
    `uvm_component_utils_begin(ARPS_IP_bram_ref_monitor)
        `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_component_utils_end    
 
    covergroup cg_ref_monitor;
        cp_address_ref : coverpoint (tr_collected_ref.address_ref/4) {
            /*
            bins low = {0,16384};
            bins med  = {16385,32768};
			bins high  = {32769,49152};
			bins extr  = {49153,65535};
            */
            bins range[] = {[0:16383]};
        } 
    endgroup : cg_ref_monitor;

    // new - constructor
    function new(string name = "ARPS_IP_bram_ref_monitor", uvm_component parent = null);
        super.new(name, parent);
        item_collected_port = new("item_collected_port", this);
        cg_ref_monitor = new();
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
        if(!uvm_config_db#(virtual bram_ref_if)::get(this, "", "bram_ref_if", vif))
            `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"})    
    endfunction : connect_phase


    extern virtual task run_phase(uvm_phase phase);

endclass : ARPS_IP_bram_ref_monitor

// UVM run_phase
task ARPS_IP_bram_ref_monitor::run_phase(uvm_phase phase);   

 
  tr_collected_ref = ARPS_IP_bram_ref_transaction::type_id::create("tr_collected_ref", this);
	forever begin
        
		@(posedge vif.clk)begin
            address_r = vif.addr_ref;
            assert(address_r <= 65532)
            @(posedge vif.clk)begin
                if(vif.en_ref == 1'b1) begin
                    
                    data_r = vif.data_ref;
                    tr_collected_ref.address_ref = address_r;
                    tr_collected_ref.data_ref_frame = data_r;
                    item_collected_port.write(tr_collected_ref);
					
					if(cfg.has_coverage == 1) begin
						cg_ref_monitor.sample();
					end

                    `uvm_info(get_type_name(), $sformatf("Transaction collected data in monitor BRAM REFERENT:\n%s", tr_collected_ref.sprint()), UVM_FULL)
                end
            end 
        end
        
    end  // forever begin
endtask : run_phase

`endif

