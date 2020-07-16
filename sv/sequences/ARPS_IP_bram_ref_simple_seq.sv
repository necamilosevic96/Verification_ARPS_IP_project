/****************************************************************************
    +-+-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+-+-+-+-+ +-+-+ +-+-+-+-+-+-+-+-+
    |F|u|n|c|t|i|o|n|a|l| |V|e|r|i|f|i|c|a|t|i|o|n| |o|f| |H|a|r|d|w|a|r|e|
    +-+-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+-+-+-+-+ +-+-+ +-+-+-+-+-+-+-+-+

    FILE            ARPS_IP_master_simple_seq.sv

    DESCRIPTION     simple sequence; random transactions

 ****************************************************************************/
 
`ifndef ARPS_IP_BRAM_REF_SIMPLE_SEQ_SV
`define ARPS_IP_BRAM_REF_SIMPLE_SEQ_SV

/**
 * Class: ARPS_IP_bram_ref_simple_seq
 */
class ARPS_IP_bram_ref_simple_seq extends ARPS_IP_bram_ref_base_seq;

    rand int unsigned num_of_tr;

    // constraints
//    constraint num_of_tr_cst { num_of_tr inside {[2 : 4]};}

    // UVM factory registration
    `uvm_object_utils(ARPS_IP_bram_ref_simple_seq)

	bit [31:0] address_write_1;
	//rand bit [31:0] image_queue_ref[$];

    // new - constructor
    function new(string name = "ARPS_IP_bram_ref_simple_seq");
        super.new(name);
    endfunction : new

    // sequence generation logic in body
    virtual task body();
	
	req = ARPS_IP_bram_ref_transaction::type_id::create("req");                    

		read_pixels();

		forever begin
         
		 //seq_rand();
		 
		 //`uvm_info(get_type_name(), "img_32 value is starting refereent\t ",UVM_HIGH)
		 
/*		assert(req.randomize());
			
		image_queue_ref.push_back(req.img_32_ref);
		
		//`uvm_info(get_type_name(), "img_32 value is starting referent\t ",UVM_HIGH)
		
		 
		 foreach (image_queue_ref[i])begin
			`uvm_do(req)
			//`uvm_info(get_type_name(), "Sequence is working, address collected BRAM REFERENT", UVM_MEDIUM)
			 `uvm_do_with(req, {req.data_ref_frame == image_queue_ref[i]; } )
			//`uvm_do_with(req, {req.data_curr_frame == image_queue[req.address_curr]; } )
			//`uvm_info(get_type_name(), "Sequence is working BRAM REFERENT", UVM_MEDIUM) 
		end
*/		
		
			`uvm_do(req)
			address_write_1 = req.address_ref;
			//`uvm_info(get_type_name(), "Sequence is working, address collected BRAM CURRENT address", UVM_MEDIUM)
//			 `uvm_do_with(req, {req.data_curr_frame == image_queue[i]; } )
			`uvm_do_with(req, {req.data_ref_frame == pixel_queue[address_write_1/4]; } )
			//`uvm_info(get_type_name(), "Sequence is working BRAM CURRENT data", UVM_MEDIUM)

		end // forever begin	
		
		//`uvm_info(get_type_name(), "Sequence after forever begin is working BRAM REFERENT", UVM_MEDIUM)
	
	
	
  //      repeat(num_of_tr) begin
           // `uvm_do(req)
/* 
       req = ARPS_IP_bram_ref_transaction::type_id::create("req"); 
 
		forever begin
	      start_item(req);	// handshake sa driverom 
	      finish_item(req);   
		end
*/
   //`uvm_info(get_type_name(), "Sequence is working BRAM REFERENT", UVM_MEDIUM)
  //      end
    endtask : body

endclass : ARPS_IP_bram_ref_simple_seq

`endif
