/****************************************************************************
    +-+-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+-+-+-+-+ +-+-+ +-+-+-+-+-+-+-+-+
    |F|u|n|c|t|i|o|n|a|l| |V|e|r|i|f|i|c|a|t|i|o|n| |o|f| |H|a|r|d|w|a|r|e|
    +-+-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+-+-+-+-+ +-+-+ +-+-+-+-+-+-+-+-+

    FILE            ARPS_IP_bram_curr_transaction.sv

    DESCRIPTION     sequence item

 ****************************************************************************/

`ifndef ARPS_IP_BRAM_CURR_TRANSACTION_SV
`define ARPS_IP_BRAM_CURR_TRANSACTION_SV
      
/*
 * Class: ARPS_IP_bram_curr_transaction
 */

class ARPS_IP_bram_curr_transaction extends uvm_sequence_item;

	rand bit [31:0] address_curr;
	rand bit [31:0] data_curr_frame;
	bit             interrupt = 0;
	rand bit [31:0] img_32;


    // UVM factory registration
    `uvm_object_utils_begin (ARPS_IP_bram_curr_transaction)
		  `uvm_field_int  (interrupt,       UVM_DEFAULT)
		  `uvm_field_int  (address_curr,    UVM_DEFAULT)
		  `uvm_field_int  (data_curr_frame, UVM_DEFAULT)
		  `uvm_field_int  (img_32,          UVM_DEFAULT)
    `uvm_object_utils_end
 
    // new - constructor
    function new(string name = "ARPS_IP_bram_curr_transaction");
        super.new(name);
    endfunction : new

endclass : ARPS_IP_bram_curr_transaction

`endif

