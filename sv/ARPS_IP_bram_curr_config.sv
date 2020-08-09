/****************************************************************************
    +-+-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+-+-+-+-+ +-+-+ +-+-+-+-+-+-+-+-+
    |F|u|n|c|t|i|o|n|a|l| |V|e|r|i|f|i|c|a|t|i|o|n| |o|f| |H|a|r|d|w|a|r|e|
    +-+-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+-+-+-+-+ +-+-+ +-+-+-+-+-+-+-+-+

    FILE            ARPS_IP_master_config.sv

    DESCRIPTION     contains main and default configurations

 ****************************************************************************/

`ifndef ARPS_IP_BRAM_CURR_CONFIG_SV
`define ARPS_IP_BRAM_CURR_CONFIG_SV

/*
 * Class: ARPS_IP_bram_curr_config
 */
class ARPS_IP_bram_curr_config extends uvm_object;
    
    // is agent active or passive
    uvm_active_passive_enum is_active = UVM_ACTIVE;
    // checks and coverage control
    bit has_checks      = 1;
    bit has_coverage    = 1;

    // UVM factory registration
    `uvm_object_utils_begin(ARPS_IP_bram_curr_config)
        `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
        `uvm_field_int(has_checks, UVM_DEFAULT)
        `uvm_field_int(has_coverage, UVM_DEFAULT)    
    `uvm_object_utils_end

    // new - constructor
    function new(string name = "ARPS_IP_bram_curr_config");
        super.new(name);
    endfunction : new
 
endclass : ARPS_IP_bram_curr_config

`endif 

