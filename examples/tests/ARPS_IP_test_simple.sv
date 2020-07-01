/****************************************************************************
    +-+-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+-+-+-+-+ +-+-+ +-+-+-+-+-+-+-+-+
    |F|u|n|c|t|i|o|n|a|l| |V|e|r|i|f|i|c|a|t|i|o|n| |o|f| |H|a|r|d|w|a|r|e|
    +-+-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+-+-+-+-+ +-+-+ +-+-+-+-+-+-+-+-+

    FILE            ARPS_IP_test_simple.sv

    DESCRIPTION     simple test for debug

 ****************************************************************************/

`ifndef ARPS_IP_TEST_SIMPLE_SV
`define ARPS_IP_TEST_SIMPLE_SV

/**
 * Class: ARPS_IP_test_simple
 */
class ARPS_IP_test_simple extends ARPS_IP_test_base;

    // UVM factory registration
    `uvm_component_utils (ARPS_IP_test_simple)
    
    // sequences
    ARPS_IP_axil_simple_seq axil_seq;
	ARPS_IP_bram_curr_simple_seq bram_curr_seq;
	ARPS_IP_bram_ref_simple_seq bram_ref_seq;
	ARPS_IP_bram_mv_simple_seq bram_mv_seq;
//    ARPS_IP_slave_simple_seq slave_seq;

    // new - constructor
    function new(string name = "ARPS_IP_test_simple", uvm_component parent = null);
        super.new(name, parent);
    endfunction : new

    // UVM build_phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        // build all sequences
        axil_seq = ARPS_IP_axil_simple_seq::type_id::create("axil_seq");
        bram_curr_seq = ARPS_IP_bram_curr_simple_seq::type_id::create("bram_curr_seq");
        bram_ref_seq = ARPS_IP_bram_ref_simple_seq::type_id::create("bram_ref_seq");
        bram_mv_seq = ARPS_IP_bram_mv_simple_seq::type_id::create("bram_mv_seq");
//        slave_seq = ARPS_IP_slave_simple_seq::type_id::create("slave_seq");
    endfunction : build_phase
    
    // UVM run_phase
    task run_phase(uvm_phase phase);
        assert(axil_seq.randomize()); // random fields in master seq.
        assert(bram_curr_seq.randomize());
        assert(bram_ref_seq.randomize());
        assert(bram_mv_seq.randomize());
        `uvm_info(get_type_name(), "Test after randomization is working", UVM_MEDIUM)        
        phase.raise_objection(this); // test cannot end yet

        // start all sequences
        fork
	        `uvm_info(get_type_name(), "Simple test inside fork is working", UVM_MEDIUM)
		
            axil_seq.start(env.axil_agent.seqr);
            bram_curr_seq.start(env.bram_curr_agent.seqr);
            bram_ref_seq.start(env.bram_ref_agent.seqr);
            bram_mv_seq.start(env.bram_mv_agent.seqr);
//            slave_seq.start(env.slave.seqr); // runs forever
        join_any
        // only way to get here is if master sequence finished
        `uvm_info(get_type_name(), "After fork in simple testr is working", UVM_MEDIUM)        
        phase.drop_objection(this); // test can end
    endtask : run_phase

endclass : ARPS_IP_test_simple

`endif

