/****************************************************************************
    +-+-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+-+-+-+-+ +-+-+ +-+-+-+-+-+-+-+-+
    |F|u|n|c|t|i|o|n|a|l| |V|e|r|i|f|i|c|a|t|i|o|n| |o|f| |H|a|r|d|w|a|r|e|
    +-+-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+-+-+-+-+ +-+-+ +-+-+-+-+-+-+-+-+

    FILE            ARPS_IP_master_driver.sv

    DESCRIPTION     

 ****************************************************************************/

`ifndef ARPS_IP_BRAM_REF_DRIVER_SV
`define ARPS_IP_BRAM_REF_DRIVER_SV

/*
 * Class: ARPS_IP_bram_ref_driver
 */
 
`uvm_analysis_imp_decl(_interrupt_r)
class ARPS_IP_bram_ref_driver extends uvm_driver #(ARPS_IP_bram_ref_transaction);
    
	uvm_analysis_imp_interrupt_r#(ARPS_IP_interrupt_transaction, ARPS_IP_bram_ref_driver) port_interrupt_r;
	
    // ARPS_IP virtual interface
    virtual bram_ref_if vif;
	
	logic [31:0] address_ref;
	int			 i = 0;
	int     		interrupt_o = 0;
    
    // configuration
    ARPS_IP_bram_ref_config bram_ref_cfg;
    
    // UVM factory registration
    `uvm_component_utils_begin(ARPS_IP_bram_ref_driver)
        `uvm_field_object(bram_ref_cfg, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_component_utils_end       

    // new - constructor
    function new(string name = "ARPS_IP_bram_ref_driver", uvm_component parent = null);
        super.new(name, parent);
		port_interrupt_r = new("port_interrupt_o", this);
    endfunction : new
    
    // UVM build_phase
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        // get configuration object from db
        if(!uvm_config_db#(ARPS_IP_bram_ref_config)::get(this, "*", "ARPS_IP_bram_ref_config", bram_ref_cfg))
            `uvm_fatal("NOCONFIG",{"Config object must be set for: ",get_full_name(),".bram_ref_cfg"})
    endfunction: build_phase
    
    // UVM connect_phase
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        // get interface from db
        if(!uvm_config_db#(virtual bram_ref_if)::get(this, "", "bram_ref_if", vif))
            `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"})    
    endfunction : connect_phase
    
    // additional class methods
    extern virtual task run_phase(uvm_phase phase);
    extern function write_interrupt_r(ARPS_IP_interrupt_transaction tr);	

endclass : ARPS_IP_bram_ref_driver

// UVM run_phase
task ARPS_IP_bram_ref_driver::run_phase(uvm_phase phase);


	forever begin

		@(posedge vif.clk)begin
		
			if(interrupt_o == 1)begin
		         interrupt_o = 0;	       
		         req.interrupt = 1;       
		         continue;
			end
		
			address_ref = vif.addr_ref;		

            seq_item_port.get_next_item(req);
			req.address_ref = address_ref;
			seq_item_port.item_done();

			seq_item_port.get_next_item(req);
			vif.data_ref = req.data_ref_frame;
            seq_item_port.item_done();
			
			i++;

		end// posedge clk

	end
      
endtask : run_phase


function ARPS_IP_bram_ref_driver::write_interrupt_r (ARPS_IP_interrupt_transaction tr);
      `uvm_info(get_type_name(), "INTERRUPT HAPPENED", UVM_FULL)
      interrupt_o = 1;
      
endfunction : write_interrupt_r

`endif

