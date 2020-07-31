/****************************************************************************
    +-+-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+-+-+-+-+ +-+-+ +-+-+-+-+-+-+-+-+
    |F|u|n|c|t|i|o|n|a|l| |V|e|r|i|f|i|c|a|t|i|o|n| |o|f| |H|a|r|d|w|a|r|e|
    +-+-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+-+-+-+-+ +-+-+ +-+-+-+-+-+-+-+-+

    FILE            ARPS_IP_axil_transaction.sv

    DESCRIPTION     sequence item

 ****************************************************************************/

`ifndef ARPS_IP_AXIL_TRANSACTION_SV
`define ARPS_IP_AXIL_TRANSACTION_SV
      
/*
 * Class: ARPS_IP_axil_transaction
 */

parameter integer IP_DATA_WIDTH	= 32;
parameter integer IP_ADDR_WIDTH	= 4;

class ARPS_IP_axil_transaction extends uvm_sequence_item;

	rand bit		    	wr_re;
	rand bit [3 : 0 ]	    addr;
	rand bit [31 : 0 ]		rdata;
	rand bit [31 : 0 ]		wdata;


    // UVM factory registration
    `uvm_object_utils_begin (ARPS_IP_axil_transaction) 
       `uvm_field_int  (wr_re,       UVM_DEFAULT) 
        `uvm_field_int  (addr,       UVM_DEFAULT)
        `uvm_field_int  (rdata, UVM_DEFAULT)
        `uvm_field_int  (wdata, UVM_DEFAULT)
    `uvm_object_utils_end
 
    // new - constructor
    function new(string name = "ARPS_IP_axil_transaction");
        super.new(name);
    endfunction : new

endclass : ARPS_IP_axil_transaction

`endif

