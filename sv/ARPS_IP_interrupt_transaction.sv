/*******************************************************************************
    +-+-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+-+-+-+-+ +-+-+ +-+-+-+-+-+-+-+-+
    |F|u|n|c|t|i|o|n|a|l| |V|e|r|i|f|i|c|a|t|i|o|n| |o|f| |H|a|r|d|w|a|r|e|
    +-+-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+-+-+-+-+ +-+-+ +-+-+-+-+-+-+-+-+

    FILE            ARPS_IP_interrupt_transaction.sv

    DESCRIPTION     

*******************************************************************************/

`ifndef ARPS_IP_INTERRUPT_TRANSACTION_SV
`define ARPS_IP_INTERRUPT_TRANSACTION_SV

class ARPS_IP_interrupt_transaction extends uvm_sequence_item;

	bit interrupt_flag =0;;

    `uvm_object_utils_begin(ARPS_IP_interrupt_transaction)
		`uvm_field_int  (interrupt_flag,      UVM_DEFAULT)
    `uvm_object_utils_end
    
    function new(string name = "ARPS_IP_interrupt_transaction");
        super.new(name);
    endfunction 

endclass : ARPS_IP_interrupt_transaction

`endif

