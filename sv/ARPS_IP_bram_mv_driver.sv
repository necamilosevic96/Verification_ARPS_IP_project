/****************************************************************************
    +-+-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+-+-+-+-+ +-+-+ +-+-+-+-+-+-+-+-+
    |F|u|n|c|t|i|o|n|a|l| |V|e|r|i|f|i|c|a|t|i|o|n| |o|f| |H|a|r|d|w|a|r|e|
    +-+-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+-+-+-+-+ +-+-+ +-+-+-+-+-+-+-+-+

    FILE            ARPS_IP_master_driver.sv

    DESCRIPTION     

 ****************************************************************************/

`ifndef ARPS_IP_BRAM_MV_DRIVER_SV
`define ARPS_IP_BRAM_MV_DRIVER_SV

/*
 * Class: ARPS_IP_bram_mv_driver
 */
class ARPS_IP_bram_mv_driver extends uvm_driver #(ARPS_IP_bram_mv_transaction);
    
    // ARPS_IP virtual interface
    virtual bram_mv_if vif;
    
    // configuration
    ARPS_IP_bram_mv_config bram_mv_cfg;
    
    // UVM factory registration
    `uvm_component_utils_begin(ARPS_IP_bram_mv_driver)
        `uvm_field_object(bram_mv_cfg, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_component_utils_end       

    // new - constructor
    function new(string name = "ARPS_IP_bram_mv_driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction : new
    
    // UVM build_phase
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        // get configuration object from db
        if(!uvm_config_db#(ARPS_IP_bram_mv_config)::get(this, "*", "ARPS_IP_bram_mv_config", bram_mv_cfg))
            `uvm_fatal("NOCONFIG",{"Config object must be set for: ",get_full_name(),".bram_mv_cfg"})
    endfunction: build_phase
    
    // UVM connect_phase
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        // get interface from db
        if(!uvm_config_db#(virtual bram_mv_if)::get(this, "", "bram_mv_if", vif))
            `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"})    
    endfunction : connect_phase
    
    // additional class methods
    extern virtual task run_phase(uvm_phase phase); 

endclass : ARPS_IP_bram_mv_driver

// UVM run_phase
task ARPS_IP_bram_mv_driver::run_phase(uvm_phase phase);

	
        seq_item_port.get_next_item(req);

        seq_item_port.item_done();
      
endtask : run_phase


`endif

