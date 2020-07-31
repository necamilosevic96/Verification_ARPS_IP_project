/****************************************************************************
    +-+-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+-+-+-+-+ +-+-+ +-+-+-+-+-+-+-+-+
    |F|u|n|c|t|i|o|n|a|l| |V|e|r|i|f|i|c|a|t|i|o|n| |o|f| |H|a|r|d|w|a|r|e|
    +-+-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+-+-+-+-+ +-+-+ +-+-+-+-+-+-+-+-+

    FILE            ARPS_IP_master_simple_seq.sv

    DESCRIPTION     simple sequence; random transactions

 ****************************************************************************/
 
`ifndef ARPS_IP_BRAM_MV_SIMPLE_SEQ_SV
`define ARPS_IP_BRAM_MV_SIMPLE_SEQ_SV

/**
 * Class: ARPS_IP_bram_mv_simple_seq
 */
class ARPS_IP_bram_mv_simple_seq extends ARPS_IP_bram_mv_base_seq;

    rand int unsigned num_of_tr;

    // UVM factory registration
    `uvm_object_utils(ARPS_IP_bram_mv_simple_seq)

    // new - constructor
    function new(string name = "ARPS_IP_bram_mv_simple_seq");
        super.new(name);
    endfunction : new

    // sequence generation logic in body
    virtual task body();

        `uvm_do(req)

    endtask : body

endclass : ARPS_IP_bram_mv_simple_seq

`endif
