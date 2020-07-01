/****************************************************************************
    +-+-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+-+-+-+-+ +-+-+ +-+-+-+-+-+-+-+-+
    |F|u|n|c|t|i|o|n|a|l| |V|e|r|i|f|i|c|a|t|i|o|n| |o|f| |H|a|r|d|w|a|r|e|
    +-+-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+-+-+-+-+ +-+-+ +-+-+-+-+-+-+-+-+

    FILE            ARPS_IP_env.sv

    DESCRIPTION     environment containing the master and slave agents

 ****************************************************************************/

`ifndef ARPS_IP_ENV_SV
`define ARPS_IP_ENV_SV

/**
 * Class: ARPS_IP_env
 */
class ARPS_IP_env extends uvm_env;

//    ARPS_IP_slave_agent  slave;  // one slave
    ARPS_IP_axil_agent axil_agent; // one master
	ARPS_IP_bram_curr_agent bram_curr_agent;
	ARPS_IP_bram_ref_agent bram_ref_agent;
	ARPS_IP_bram_mv_agent bram_mv_agent;

    ARPS_IP_config cfg; // uvc configuration

    // UVM factory registration
    `uvm_component_utils_begin(ARPS_IP_env)
        `uvm_field_object(cfg, UVM_DEFAULT)
    `uvm_component_utils_end    

    // new - constructor
    function new(string name = "ARPS_IP_env", uvm_component parent = null);
        super.new(name, parent);
    endfunction : new

    // UVM build_phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    
        // get configuration from db or use default configuration if none is set
        if(!uvm_config_db#(ARPS_IP_config)::get(this, "", "ARPS_IP_config", cfg)) begin
            `uvm_info("NOCONFIG", "Using default_ARPS_IP_config", UVM_LOW)
            ARPS_IP_config::type_id::set_type_override(default_ARPS_IP_config::get_type(), 1);
            cfg = ARPS_IP_config::type_id::create("cfg");
        end
            
        // set the master configuration
        if(cfg.has_master) begin
            uvm_config_db#(ARPS_IP_axil_config)::set(this, "axil_agent*", "ARPS_IP_axil_config", cfg.axil_cfg);
            uvm_config_db#(ARPS_IP_config)::set(this, "axil_agent.mon*", "ARPS_IP_config", cfg);
			uvm_config_db#(ARPS_IP_bram_curr_config)::set(this, "bram_curr_agent*", "ARPS_IP_bram_curr_config", cfg.bram_curr_cfg);
            uvm_config_db#(ARPS_IP_config)::set(this, "bram_curr_agent.mon*", "ARPS_IP_config", cfg);
			uvm_config_db#(ARPS_IP_bram_ref_config)::set(this, "bram_ref_agent*", "ARPS_IP_bram_ref_config", cfg.bram_ref_cfg);
            uvm_config_db#(ARPS_IP_config)::set(this, "bram_ref_agent.mon*", "ARPS_IP_config", cfg);
			uvm_config_db#(ARPS_IP_bram_mv_config)::set(this, "bram_mv_agent*", "ARPS_IP_bram_mv_config", cfg.bram_mv_cfg);
            uvm_config_db#(ARPS_IP_config)::set(this, "bram_mv_agent.mon*", "ARPS_IP_config", cfg);
        end
        // set the slave configuration
//        if(cfg.has_slave) begin
//            uvm_config_db#(ARPS_IP_slave_config)::set(this, "slave*", "ARPS_IP_slave_config", cfg.slave_cfg);
//            uvm_config_db#(ARPS_IP_config)::set(this, "slave.mon*", "ARPS_IP_config", cfg);
//        end

        // create agents
        if(cfg.has_master) begin
            axil_agent = ARPS_IP_axil_agent::type_id::create("axil_agent", this);
			bram_curr_agent = ARPS_IP_bram_curr_agent::type_id::create("bram_curr_agent", this);
			bram_ref_agent = ARPS_IP_bram_ref_agent::type_id::create("bram_ref_agent", this);
			bram_mv_agent = ARPS_IP_bram_mv_agent::type_id::create("bram_mv_agent", this);
        end
//        if(cfg.has_slave) begin
//            slave = ARPS_IP_slave_agent::type_id::create("slave", this);
//        end

    endfunction : build_phase  

endclass : ARPS_IP_env

`endif
