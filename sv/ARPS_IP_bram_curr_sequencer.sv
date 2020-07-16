/*******************************************************************************
    +-+-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+-+-+-+-+ +-+-+ +-+-+-+-+-+-+-+-+
    |F|u|n|c|t|i|o|n|a|l| |V|e|r|i|f|i|c|a|t|i|o|n| |o|f| |H|a|r|d|w|a|r|e|
    +-+-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+-+-+-+-+ +-+-+ +-+-+-+-+-+-+-+-+

    FILE            ARPS_IP_bram_curr_sequencer.sv

    DESCRIPTION     

*******************************************************************************/

`ifndef ARPS_IP_BRAM_CURR_SEQUENCER_SV
`define ARPS_IP_BRAM_CURR_SEQUENCER_SV

class ARPS_IP_bram_curr_sequencer extends uvm_sequencer#(ARPS_IP_bram_curr_transaction);

    `uvm_component_utils(ARPS_IP_bram_curr_sequencer)

    function new(string name = "ARPS_IP_bram_curr_sequencer", uvm_component parent = null);
        super.new(name,parent);
    endfunction

endclass : ARPS_IP_bram_curr_sequencer

`endif

