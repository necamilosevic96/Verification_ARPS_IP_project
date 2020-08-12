/****************************************************************************
    +-+-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+-+-+-+-+ +-+-+ +-+-+-+-+-+-+-+-+
    |F|u|n|c|t|i|o|n|a|l| |V|e|r|i|f|i|c|a|t|i|o|n| |o|f| |H|a|r|d|w|a|r|e|
    +-+-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+-+-+-+-+ +-+-+ +-+-+-+-+-+-+-+-+
    FILE            ARPS_IP_master_simple_seq.sv
    DESCRIPTION     simple sequence; random transactions
 ****************************************************************************/
 
`ifndef ARPS_IP_BRAM_REF_SIMPLE_SEQ_SV
`define ARPS_IP_BRAM_REF_SIMPLE_SEQ_SV

`include "..//sv/sequences/ARPS_IP_def.sv"

/**
 * Class: ARPS_IP_bram_ref_simple_seq
 */
class ARPS_IP_bram_ref_simple_seq extends ARPS_IP_bram_ref_base_seq;

    rand int unsigned num_of_tr;
    
    bit [31:0] address_write_r;
    int num_of_seq = 1; //NUMBER_OF_SEQ DEFAULT (changed in ARPS_IP_def.sv)
    int start_frame_r = 50; //STARTING FRAME DEFAULT (changed in ARPS_IP_def.sv)
    int cnt_seq = 0;
    
    // UVM factory registration
    `uvm_object_utils(ARPS_IP_bram_ref_simple_seq)

    // new - constructor
    function new(string name = "ARPS_IP_bram_ref_simple_seq");
        super.new(name);
    endfunction : new

    // sequence generation logic in body
    virtual task body();
    
        //Define num of sequences
        ARPS_IP_def def = new();
        num_of_seq = def.get_num_of_seq();
        //Define start frame ref
        start_frame_r = def.get_ref_frame_num();
        
        read_ref_img(start_frame_r);
	    req = ARPS_IP_bram_ref_transaction::type_id::create("req");                    
        
		forever begin
            if(cnt_seq < num_of_seq) begin
                `uvm_do(req)
                address_write_r = req.address_ref;
                if(req.interrupt) begin
                    req.interrupt = 0;
                    start_frame_r++;
                    read_ref_img(start_frame_r);
                    cnt_seq++;
                    `uvm_info(get_type_name(),"BRAM_REF_SEQ: Interrupt = 1",UVM_MEDIUM)
                end	
                else begin
                    `uvm_do_with(req, {req.data_ref_frame == ref_queue[address_write_r/4]; } )
                end
            end 
            else begin
                `uvm_info(get_type_name(),"BRAM_REF_SEQ: Finish",UVM_MEDIUM)
                break;
            end

		end // forever begin	
		
    endtask : body

endclass : ARPS_IP_bram_ref_simple_seq

`endif