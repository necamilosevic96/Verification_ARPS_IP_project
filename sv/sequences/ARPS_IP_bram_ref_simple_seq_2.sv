/****************************************************************************
    +-+-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+-+-+-+-+ +-+-+ +-+-+-+-+-+-+-+-+
    |F|u|n|c|t|i|o|n|a|l| |V|e|r|i|f|i|c|a|t|i|o|n| |o|f| |H|a|r|d|w|a|r|e|
    +-+-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+-+-+-+-+ +-+-+ +-+-+-+-+-+-+-+-+

    FILE            ARPS_IP_master_simple_seq_2.sv

    DESCRIPTION     simple sequence; random transactions

 ****************************************************************************/
 
`ifndef ARPS_IP_BRAM_REF_SIMPLE_SEQ_2_SV
`define ARPS_IP_BRAM_REF_SIMPLE_SEQ_2_SV

/**
 * Class: ARPS_IP_bram_ref_simple_seq_2
 */
class ARPS_IP_bram_ref_simple_seq_2 extends ARPS_IP_bram_ref_base_seq_2;

    rand int unsigned num_of_tr;

    // UVM factory registration
    `uvm_object_utils(ARPS_IP_bram_ref_simple_seq_2)

	bit [31:0] address_write_1;

    // new - constructor
    function new(string name = "ARPS_IP_bram_ref_simple_seq_2");
        super.new(name);
    endfunction : new

    // sequence generation logic in body
    virtual task body();
	
	req = ARPS_IP_bram_ref_transaction::type_id::create("req");                    

		read_pixels();

		forever begin
         
			`uvm_do(req)
			address_write_1 = req.address_ref;
			`uvm_do_with(req, {req.data_ref_frame == pixel_queue[address_write_1/4]; } )

		end // forever begin	
		
    endtask : body

endclass : ARPS_IP_bram_ref_simple_seq_2

`endif
