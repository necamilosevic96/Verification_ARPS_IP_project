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

parameter integer IP_DATA_WIDTH	= 8;
parameter integer IP_ADDR_WIDTH	= 16;

class ARPS_IP_axil_transaction extends uvm_sequence_item;

	rand bit		    start_i;
	rand bit [8 : 0 ]	    mv_addr;

	rand bit		    we_curr;
	rand bit [IP_DATA_WIDTH -1 : 0 ]  data_curr;
	rand bit [IP_ADDR_WIDTH -1 : 0 ]  addr_curr;

	rand bit  		    we_ref;
	rand bit [IP_DATA_WIDTH -1 : 0 ]  data_ref;
	rand bit [IP_ADDR_WIDTH -1 : 0 ]  addr_ref;
	rand bit [(IP_DATA_WIDTH /2) -1 : 0 ] data_out;	


   constraint address_constraint {addr_curr <=  16'h14;}

//START
/*


    // fields
    rand ARPS_IP_direction_enum       dir;
    rand bit [ADDR_WIDTH - 1 : 0] addr;
    rand ARPS_IP_ack_enum             addr_ack;
    rand bit [DATA_WIDTH - 1 : 0] data;
    rand ARPS_IP_ack_enum             data_ack;

    // timings (#clk cycles)
    rand int unsigned scl_period;    // SCL period
    rand int unsigned start_hold;    // start hold time before SCL toggle
    rand int unsigned stop_setup;    // setup time from SCL posedge to SDA assert
    rand int unsigned delay;         // time between stop and start conditions
    
    // constraints
    constraint timing_constraint {
        scl_period  inside {[1 : 20]};
        scl_period % 4 == 0;
        start_hold  inside {[1 : 10]};
        stop_setup  inside {[1 : 10]};
        delay       inside {[1 : 10]};
    }
    constraint ack_constraint {
    	addr_ack dist {ARPS_IP_ACK := 8, ARPS_IP_NACK := 2};
    	data_ack dist {ARPS_IP_ACK := 8, ARPS_IP_NACK := 2};
   	}

*/
//FINISH


    // UVM factory registration
    `uvm_object_utils_begin (ARPS_IP_axil_transaction)
//      `uvm_field_enum (ARPS_IP_direction_enum, dir,      UVM_DEFAULT)
//    	`uvm_field_enum (ARPS_IP_ack_enum,       data_ack, UVM_DEFAULT)
//     	`uvm_field_enum (ARPS_IP_ack_enum,       addr_ack, UVM_DEFAULT) 
        `uvm_field_int  (start_i,       UVM_DEFAULT) 
        `uvm_field_int  (mv_addr,       UVM_DEFAULT)
        `uvm_field_int  (we_curr, UVM_DEFAULT)
        `uvm_field_int  (data_curr, UVM_DEFAULT)
        `uvm_field_int  (addr_curr, UVM_DEFAULT)
        `uvm_field_int  (we_ref,      UVM_DEFAULT)
        `uvm_field_int  (data_ref,      UVM_DEFAULT)
        `uvm_field_int  (addr_ref,      UVM_DEFAULT)
    `uvm_object_utils_end
 
    // new - constructor
    function new(string name = "ARPS_IP_axil_transaction");
        super.new(name);
    endfunction : new

endclass : ARPS_IP_axil_transaction

`endif
