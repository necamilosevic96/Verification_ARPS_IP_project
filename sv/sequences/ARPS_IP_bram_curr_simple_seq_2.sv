/****************************************************************************
    +-+-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+-+-+-+-+ +-+-+ +-+-+-+-+-+-+-+-+
    |F|u|n|c|t|i|o|n|a|l| |V|e|r|i|f|i|c|a|t|i|o|n| |o|f| |H|a|r|d|w|a|r|e|
    +-+-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+-+-+-+-+ +-+-+ +-+-+-+-+-+-+-+-+

    FILE            ARPS_IP_master_simple_seq_2.sv

    DESCRIPTION     simple sequence; random transactions

 ****************************************************************************/
 
`ifndef ARPS_IP_BRAM_CURR_SIMPLE_SEQ_2_SV
`define ARPS_IP_BRAM_CURR_SIMPLE_SEQ_2_SV

class ARPS_IP_bram_curr_simple_seq_2 extends ARPS_IP_bram_curr_base_seq_2;

    // UVM factory registration
    `uvm_object_utils(ARPS_IP_bram_curr_simple_seq_2)
	
	bit [31:0] address_write_c;
    int start_frame_c = 0;
    int num_of_seq = 5;
    int cnt_seq = 0;
    // new - constructor
    function new(string name = "ARPS_IP_bram_curr_simple_seq_2");
        super.new(name);
    endfunction : new

    // sequence generation logic in body   
    virtual task body();
		read_curr_img(start_frame_c); 
		req = ARPS_IP_bram_curr_transaction::type_id::create("req");
        forever begin
            if(cnt_seq < num_of_seq) begin
                `uvm_do(req)
                address_write_c = req.address_curr;
                if(req.interrupt) begin
                    req.interrupt = 0;
                    if(start_frame_c<4) begin
                        start_frame_c++;
                    end
                    read_curr_img(start_frame_c);
                    cnt_seq++;
                end
                else begin
                    `uvm_do_with(req, {req.data_curr_frame == curr_queue[address_write_c/4]; } )
                end
            end
            else begin
                break;
            end
        end
		
//	`uvm_info(get_type_name(), "Sequence is working BRAM CURRENT forever", UVM_MEDIUM)		
//		`uvm_info(get_type_name(), "Sequence after forever begin is working BRAM CURRENT forever", UVM_MEDIUM)

    endtask : body

endclass : ARPS_IP_bram_curr_simple_seq_2

`endif