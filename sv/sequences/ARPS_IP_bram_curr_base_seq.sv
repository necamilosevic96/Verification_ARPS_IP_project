/****************************************************************************
    +-+-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+-+-+-+-+ +-+-+ +-+-+-+-+-+-+-+-+
    |F|u|n|c|t|i|o|n|a|l| |V|e|r|i|f|i|c|a|t|i|o|n| |o|f| |H|a|r|d|w|a|r|e|
    +-+-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+-+-+-+-+ +-+-+ +-+-+-+-+-+-+-+-+

    FILE            ARPS_IP_master_base_seq.sv

    DESCRIPTION     base sequence to be extended by other sequences

 ****************************************************************************/

`ifndef ARPS_IP_BRAM_CURR_BASE_SEQ_SV
`define ARPS_IP_BRAM_CURR_BASE_SEQ_SV

/*
 * Class: ARPS_IP_bram_curr_base_seq
 */
class ARPS_IP_bram_curr_base_seq extends uvm_sequence #(ARPS_IP_bram_curr_transaction);

    // UVM factory registration
    `uvm_object_utils(ARPS_IP_bram_curr_base_seq)
	`uvm_declare_p_sequencer(ARPS_IP_bram_curr_sequencer)
    
    logic [31:0] curr_queue[$];
    string  img_hex;
    int     fd;
    
    //string   file_path = "..//images_for_arps/sample69"; 
    string  file_path = "..//images_for_arps/sample";
    string  full_path;
    string  ext = ".txt";
    string  fr_num;
    int unsigned    i = 0;  
    
    // new - constructor
    function new(string name = "ARPS_IP_bram_curr_base_seq");
        super.new(name);
    endfunction: new
    
   function void read_curr_img(int frame_num);
		i = 0;
        init_queue_c();
        fr_num.itoa(frame_num);
		`uvm_info(get_type_name(), "\nOpening file BRAM CURRENT\n", UVM_MEDIUM)
		
		fd = ($fopen({file_path,fr_num,ext}, "r"));
		
		if(fd)begin
			`uvm_info(get_type_name(), $sformatf("\nBRAM_CURR_SEQ: File OPENED, SAMPLE%d\n",frame_num), UVM_MEDIUM)	
			while(!$feof(fd))begin
				if(i >= 16384) begin
 
					$fscanf(fd ,"%s\n",img_hex);
					//curr_queue.push_back(img_hex.atohex());
                    //$display("CURR_qu[0]=%x",curr_queue[0]);
					i = 0;    
					
				end  
				else begin
				
					$fscanf(fd ,"%s\n",img_hex);	
					curr_queue[i] = (img_hex.atohex());
					i++;
					
				end
            
			end // while (!$feof(fd_img))  
		end
        else begin
			`uvm_fatal(get_type_name(), $sformatf("\nBRAM_CURR: Didn't open file SAMPLE%d\n",frame_num))
        end
	
		`uvm_info(get_type_name(), "\nImport image finished BRAM CURRENT\n", UVM_MEDIUM)
		$fclose(fd);
		`uvm_info(get_type_name(), "\nAfter file is closed BRAM CURRENT\n", UVM_MEDIUM)

   endfunction
    
    function void init_queue_c();
        for(int k=0;k<16384;k++) begin
            curr_queue[k]=0;
        end
    endfunction

endclass: ARPS_IP_bram_curr_base_seq

`endif

