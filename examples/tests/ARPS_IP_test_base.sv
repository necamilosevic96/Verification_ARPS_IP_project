/****************************************************************************
    +-+-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+-+-+-+-+ +-+-+ +-+-+-+-+-+-+-+-+
    |F|u|n|c|t|i|o|n|a|l| |V|e|r|i|f|i|c|a|t|i|o|n| |o|f| |H|a|r|d|w|a|r|e|
    +-+-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+-+-+-+-+ +-+-+ +-+-+-+-+-+-+-+-+

    FILE            ARPS_IP_test_base.sv

    DESCRIPTION     base test to be extended by other tests

 ****************************************************************************/

`ifndef ARPS_IP_TEST_BASE_SV
`define ARPS_IP_TEST_BASE_SV

/**
 * Class: ARPS_IP_test_base
 */
class ARPS_IP_test_base extends uvm_test;

    // UVM factory registration
    `uvm_component_utils (ARPS_IP_test_base)

    // main environment
    ARPS_IP_env env;

    // new - constructor
    function new(string name = "ARPS_IP_test_base", uvm_component parent = null);
        super.new(name, parent);
    endfunction : new

    // UVM build_phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        // build environment
        env = ARPS_IP_env::type_id::create("env", this);
    endfunction : build_phase

    // UVM end_of_elaboration_phase
    function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
        // display verification environment topology
        uvm_top.print_topology();
    endfunction : end_of_elaboration_phase    

endclass : ARPS_IP_test_base

`endif

