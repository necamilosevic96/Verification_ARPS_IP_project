/****************************************************************************
    +-+-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+-+-+-+-+ +-+-+ +-+-+-+-+-+-+-+-+
    |F|u|n|c|t|i|o|n|a|l| |V|e|r|i|f|i|c|a|t|i|o|n| |o|f| |H|a|r|d|w|a|r|e|
    +-+-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+-+-+-+-+ +-+-+ +-+-+-+-+-+-+-+-+

    FILE            ARPS_IP_bram_mv_transaction.sv

    DESCRIPTION     sequence item

 ****************************************************************************/

`ifndef ARPS_IP_BRAM_MV_TRANSACTION_SV
`define ARPS_IP_BRAM_MV_TRANSACTION_SV
      
/*
 * Class: ARPS_IP_bram_mv_transaction
 */

class ARPS_IP_bram_mv_transaction extends uvm_sequence_item;

	rand bit [31:0]		    address_mv;
	rand bit [31 : 0 ]	    data_mv_frame;

    // UVM factory registration
    `uvm_object_utils_begin (ARPS_IP_bram_mv_transaction)
        `uvm_field_int  (address_mv,       UVM_DEFAULT) 
        `uvm_field_int  (data_mv_frame,       UVM_DEFAULT)
    `uvm_object_utils_end
 
    // new - constructor
    function new(string name = "ARPS_IP_bram_mv_transaction");
        super.new(name);
    endfunction : new

endclass : ARPS_IP_bram_mv_transaction

`endif

