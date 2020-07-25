/****************************************************************************
    +-+-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+-+-+-+-+ +-+-+ +-+-+-+-+-+-+-+-+
    |F|u|n|c|t|i|o|n|a|l| |V|e|r|i|f|i|c|a|t|i|o|n| |o|f| |H|a|r|d|w|a|r|e|
    +-+-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+-+-+-+-+ +-+-+ +-+-+-+-+-+-+-+-+

    FILE            ARPS_IP_config.sv

    DESCRIPTION     contains main and default configurations

 ****************************************************************************/

`ifndef ARPS_IP_CONFIG_SV
`define ARPS_IP_CONFIG_SV

/**
 * Class: ARPS_IP_config
 */
class ARPS_IP_config extends uvm_object;
    
    // master/slave agents
    bit has_master;
    bit has_slave;

    // configurations for every agent
//    ARPS_IP_slave_config  slave_cfg;
    ARPS_IP_axil_config axil_cfg;
    ARPS_IP_bram_curr_config bram_curr_cfg;
    ARPS_IP_bram_ref_config bram_ref_cfg;
    ARPS_IP_bram_mv_config bram_mv_cfg;
    ARPS_IP_interrupt_config interrupt_cfg;

    // control
    bit has_checks = 1;
    bit has_coverage = 1;

    // UVM factory registration
    `uvm_object_utils_begin(ARPS_IP_config)
        `uvm_field_int(has_master, UVM_DEFAULT)
        `uvm_field_int(has_slave, UVM_DEFAULT)
        `uvm_field_object(interrupt_cfg, UVM_DEFAULT)
        `uvm_field_object(axil_cfg, UVM_DEFAULT)
        `uvm_field_object(bram_curr_cfg, UVM_DEFAULT)
        `uvm_field_object(bram_ref_cfg, UVM_DEFAULT)
        `uvm_field_object(bram_mv_cfg, UVM_DEFAULT)
        `uvm_field_int(has_checks, UVM_DEFAULT)
        `uvm_field_int(has_coverage, UVM_DEFAULT)
    `uvm_object_utils_end

    // new - constructor
    function new(string name = "ARPS_IP_config");
        super.new(name);
    endfunction : new

    // additional class methods
//    extern function void add_slave(uvm_active_passive_enum is_active = UVM_ACTIVE);
    extern function void add_axil(uvm_active_passive_enum is_active = UVM_ACTIVE);
    extern function void add_bram_curr(uvm_active_passive_enum is_active = UVM_ACTIVE);
    extern function void add_bram_ref(uvm_active_passive_enum is_active = UVM_ACTIVE);
    extern function void add_bram_mv(uvm_active_passive_enum is_active = UVM_ACTIVE);
    extern function void add_interrupt(uvm_active_passive_enum is_active = UVM_ACTIVE);

endclass : ARPS_IP_config

/*

// creates and configures a slave agent config and adds to a queue
function void ARPS_IP_config::add_slave(uvm_active_passive_enum is_active = UVM_ACTIVE);
    slave_cfg = ARPS_IP_slave_config::type_id::create("slave_cfg");
    has_slave = 1;
    slave_cfg.is_active = is_active;
    slave_cfg.has_checks = has_checks;
    slave_cfg.has_coverage = has_coverage;
endfunction : add_slave

*/

// creates and configures a master agent configuration
function void ARPS_IP_config::add_axil(uvm_active_passive_enum is_active = UVM_ACTIVE);
    axil_cfg = ARPS_IP_axil_config::type_id::create("axil_cfg");
    has_master = 1;
    axil_cfg.is_active = is_active;
    axil_cfg.has_checks = has_checks;
    axil_cfg.has_coverage = has_coverage;
endfunction : add_axil


function void ARPS_IP_config::add_bram_curr(uvm_active_passive_enum is_active = UVM_ACTIVE);
    bram_curr_cfg = ARPS_IP_bram_curr_config::type_id::create("bram_curr_cfg");
    has_master = 1;
    bram_curr_cfg.is_active = is_active;
    bram_curr_cfg.has_checks = has_checks;
    bram_curr_cfg.has_coverage = has_coverage;
endfunction : add_bram_curr


function void ARPS_IP_config::add_bram_ref(uvm_active_passive_enum is_active = UVM_ACTIVE);
    bram_ref_cfg = ARPS_IP_bram_ref_config::type_id::create("bram_ref_cfg");
    has_master = 1;
    bram_ref_cfg.is_active = is_active;
    bram_ref_cfg.has_checks = has_checks;
    bram_ref_cfg.has_coverage = has_coverage;
endfunction : add_bram_ref


function void ARPS_IP_config::add_bram_mv(uvm_active_passive_enum is_active = UVM_ACTIVE);
    bram_mv_cfg = ARPS_IP_bram_mv_config::type_id::create("bram_mv_cfg");
    has_master = 1;
    bram_mv_cfg.is_active = is_active;
    bram_mv_cfg.has_checks = has_checks;
    bram_mv_cfg.has_coverage = has_coverage;
endfunction : add_bram_mv


function void ARPS_IP_config::add_interrupt(uvm_active_passive_enum is_active = UVM_ACTIVE);
    interrupt_cfg = ARPS_IP_interrupt_config::type_id::create("interrupt_cfg");
    has_slave = 1;
    interrupt_cfg.is_active = is_active;
    interrupt_cfg.has_checks = has_checks;
    interrupt_cfg.has_coverage = has_coverage;
endfunction : add_interrupt

/**
 * Class: default_ARPS_IP_config
 * 
 * Description: default configuration - one master, no slaves
 */
class default_ARPS_IP_config extends ARPS_IP_config;

    `uvm_object_utils(default_ARPS_IP_config)

    function new(string name = "default_ARPS_IP_config");
        super.new(name);
        add_axil(UVM_ACTIVE);
        add_bram_curr(UVM_ACTIVE);
        add_bram_ref(UVM_ACTIVE);
        add_bram_mv(UVM_ACTIVE);
        add_interrupt(UVM_ACTIVE); // TODO : remove after debug
    endfunction : new

endclass : default_ARPS_IP_config

`endif
