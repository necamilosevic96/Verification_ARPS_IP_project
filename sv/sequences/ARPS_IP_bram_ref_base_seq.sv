/****************************************************************************
    +-+-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+-+-+-+-+ +-+-+ +-+-+-+-+-+-+-+-+
    |F|u|n|c|t|i|o|n|a|l| |V|e|r|i|f|i|c|a|t|i|o|n| |o|f| |H|a|r|d|w|a|r|e|
    +-+-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+-+-+-+-+ +-+-+ +-+-+-+-+-+-+-+-+

    FILE            ARPS_IP_master_base_seq.sv

    DESCRIPTION     base sequence to be extended by other sequences

 ****************************************************************************/

`ifndef ARPS_IP_BRAM_REF_BASE_SEQ_SV
`define ARPS_IP_BRAM_REF_BASE_SEQ_SV

/*
 * Class: ARPS_IP_bram_ref_base_seq
 */
class ARPS_IP_bram_ref_base_seq extends uvm_sequence #(ARPS_IP_bram_ref_transaction);

    // UVM factory registration
    `uvm_object_utils(ARPS_IP_bram_ref_base_seq)
	
	logic [31:0] ref_queue[$];
    string   data_hex_ref;
	int 		fd_r;

	string   file_path = "..//images_for_arps/sample";
    string   full_path;
    string   ext = ".txt";
    string   fr_num;
	int unsigned     i = 0;  

    // new - constructor
    function new(string name = "ARPS_IP_bram_ref_base_seq");
        super.new(name);
    endfunction: new
    
   function void read_ref_img(int frame_num);
        i = 0;
		init_queue_r();
        fr_num.itoa(frame_num);
		`uvm_info(get_type_name(), "Opening file BRAM REFERENT", UVM_MEDIUM)
		
		fd_r = ($fopen({file_path,fr_num,ext}, "r"));

		if(fd_r)begin
			`uvm_info(get_type_name(), $sformatf("BRAM_REF_SEQ: File OPENED, SAMPLE%d",frame_num), UVM_MEDIUM)
			while(!$feof(fd_r))begin
				if(i >= 16384) begin
					$fscanf(fd_r ,"%s\n",data_hex_ref);
					i = 0;    
				end  
				else begin			
					$fscanf(fd_r ,"%s\n",data_hex_ref);
					ref_queue[i]=(data_hex_ref.atohex());
					i++;
				end
            
			end // while (!$feof(fd_img))  
		end
        else begin
			`uvm_error(get_type_name(), $sformatf("BRAM_REF_SEQ: Fail to open SAMPLE%d",frame_num))
        end
	
		`uvm_info(get_type_name(), "BRAM_REF_SEQ: Import image finished", UVM_HIGH)
		$fclose(fd_r);
		`uvm_info(get_type_name(), "BRAM_REF_SEQ: File closed", UVM_MEDIUM)
	
   endfunction
    
    function void init_queue_r();
        for(int k=0;k<16384;k++) begin
            ref_queue[k]=0;
        end
        `uvm_info(get_type_name(), "BRAM_REF_SEQ: Initialising ref_queue", UVM_MEDIUM)
    endfunction
endclass: ARPS_IP_bram_ref_base_seq

`endif

