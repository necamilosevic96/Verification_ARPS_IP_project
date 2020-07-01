/****************************************************************************
    +-+-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+-+-+-+-+ +-+-+ +-+-+-+-+-+-+-+-+
    |F|u|n|c|t|i|o|n|a|l| |V|e|r|i|f|i|c|a|t|i|o|n| |o|f| |H|a|r|d|w|a|r|e|
    +-+-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+-+-+-+-+ +-+-+ +-+-+-+-+-+-+-+-+

    FILE            ARPS_IP_master_agent.sv

    DESCRIPTION     master agent

 ****************************************************************************/

`ifndef ARPS_IP_BRAM_MV_AGENT_SV
`define ARPS_IP_BRAM_MV_AGENT_SV

typedef uvm_sequencer #(ARPS_IP_bram_mv_transaction) ARPS_IP_bram_mv_sequencer;

/*
 * Class: ARPS_IP_bram_mv_agent
 */
class ARPS_IP_bram_mv_agent extends uvm_agent;
    
    // configuration object
    ARPS_IP_bram_mv_config bram_mv_cfg;

    // components
    ARPS_IP_bram_mv_monitor          mon;
    ARPS_IP_bram_mv_driver    drv;
    ARPS_IP_bram_mv_sequencer seqr;
    
    // UVM factory registration
    `uvm_component_utils_begin(ARPS_IP_bram_mv_agent)
        `uvm_field_object(bram_mv_cfg, UVM_DEFAULT)
    `uvm_component_utils_end

    // new - constructor
    function new(string name = "ARPS_IP_bram_mv_agent", uvm_component parent);
        super.new(name, parent);
    endfunction : new

    // UVM build_phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        // get configuration object from db
        if(!uvm_config_db#(ARPS_IP_bram_mv_config)::get(this, "", "ARPS_IP_bram_mv_config", bram_mv_cfg))
            `uvm_fatal("NOCONFIG",{"Config object must be set for: ",get_full_name(),".bram_mv_cfg"})

        // create driver and sequencer if agent is active
        if(bram_mv_cfg.is_active == UVM_ACTIVE) begin
            seqr = ARPS_IP_bram_mv_sequencer::type_id::create("seqr", this);
            drv = ARPS_IP_bram_mv_driver::type_id::create("drv", this);
        end
        // always create monitor
        mon = ARPS_IP_bram_mv_monitor::type_id::create("mon", this);
    endfunction : build_phase

    // UVM connect_phase
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        // connect driver and sequencer if agent is active
        if(bram_mv_cfg.is_active == UVM_ACTIVE) begin
            drv.seq_item_port.connect(seqr.seq_item_export);
        end
    endfunction : connect_phase

endclass : ARPS_IP_bram_mv_agent

`endif

