/****************************************************************************
    +-+-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+-+-+-+-+ +-+-+ +-+-+-+-+-+-+-+-+
    |F|u|n|c|t|i|o|n|a|l| |V|e|r|i|f|i|c|a|t|i|o|n| |o|f| |H|a|r|d|w|a|r|e|
    +-+-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+-+-+-+-+ +-+-+ +-+-+-+-+-+-+-+-+

    FILE            ARPS_IP_master_base_seq.sv

    DESCRIPTION     base sequence to be extended by other sequences

 ****************************************************************************/

`ifndef ARPS_IP_BRAM_CURR_BASE_SEQ_SV
`define ARPS_IP_BRAM_CURR_BASE_SEQ_SV

/*
 * Class: ARPS_IP_bram_curr_base_seq
 */
class ARPS_IP_bram_curr_base_seq extends uvm_sequence #(ARPS_IP_bram_curr_transaction);

    // UVM factory registration
    `uvm_object_utils(ARPS_IP_bram_curr_base_seq)

    // new - constructor
    function new(string name = "ARPS_IP_bram_curr_base_seq");
        super.new(name);
    endfunction: new

endclass: ARPS_IP_bram_curr_base_seq

`endif

