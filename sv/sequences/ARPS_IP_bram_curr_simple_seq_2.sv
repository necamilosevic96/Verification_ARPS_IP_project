/****************************************************************************
    +-+-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+-+-+-+-+ +-+-+ +-+-+-+-+-+-+-+-+
    |F|u|n|c|t|i|o|n|a|l| |V|e|r|i|f|i|c|a|t|i|o|n| |o|f| |H|a|r|d|w|a|r|e|
    +-+-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+-+-+-+-+ +-+-+ +-+-+-+-+-+-+-+-+

    FILE            ARPS_IP_master_simple_seq_2.sv

    DESCRIPTION     simple sequence; random transactions

 ****************************************************************************/
 
`ifndef ARPS_IP_BRAM_CURR_SIMPLE_SEQ_2_SV
`define ARPS_IP_BRAM_CURR_SIMPLE_SEQ_2_SV

class ARPS_IP_bram_curr_simple_seq_2 extends ARPS_IP_bram_curr_base_seq;

    // UVM factory registration
    `uvm_object_utils(ARPS_IP_bram_curr_simple_seq_2)
	
	bit [31:0] address_write;
	logic [31:0] image_queue[$];

    // new - constructor
    function new(string name = "ARPS_IP_bram_curr_simple_seq_2");
        super.new(name);
    endfunction : new

    // sequence generation logic in body   
    virtual task body();

		//read_images();
      
		req = ARPS_IP_bram_curr_transaction::type_id::create("req");                    

		forever begin

		/*	`uvm_do(req)
			address_write = req.address_curr;

		if(req.interrupt)begin
			`uvm_do_with(req, {req.interrupt == 0; } )
		end	
		else begin
			`uvm_do_with(req, {req.data_curr_frame == image_queue[address_write/4]; } )
		end
		*/
		
		assert(req.randomize());
		image_queue.push_back(req.img_32);
		`uvm_do(req)
		address_write = req.address_curr;
		//foreach (image_queue[i])begin
			`uvm_do_with(req, {req.data_curr_frame == image_queue[address_write/4]; } )
		//end
		
		`uvm_info(get_type_name(), "Sequence is working BRAM CURRENT forever", UVM_MEDIUM)		
		
		end // forever begin	
		
		`uvm_info(get_type_name(), "Sequence after forever begin is working BRAM CURRENT forever", UVM_MEDIUM)

    endtask : body

endclass : ARPS_IP_bram_curr_simple_seq_2

`endif