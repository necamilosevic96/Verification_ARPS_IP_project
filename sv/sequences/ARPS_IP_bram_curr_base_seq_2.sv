/****************************************************************************
    +-+-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+-+-+-+-+ +-+-+ +-+-+-+-+-+-+-+-+
    |F|u|n|c|t|i|o|n|a|l| |V|e|r|i|f|i|c|a|t|i|o|n| |o|f| |H|a|r|d|w|a|r|e|
    +-+-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+-+-+-+-+ +-+-+ +-+-+-+-+-+-+-+-+

    FILE            ARPS_IP_master_base_seq_2.sv

    DESCRIPTION     base sequence to be extended by other sequences

 ****************************************************************************/

`ifndef ARPS_IP_BRAM_CURR_BASE_SEQ_2_SV
`define ARPS_IP_BRAM_CURR_BASE_SEQ_2_SV

/*
 * Class: ARPS_IP_bram_curr_base_seq_2
 */
class ARPS_IP_bram_curr_base_seq_2 extends uvm_sequence #(ARPS_IP_bram_curr_transaction);

    // UVM factory registration
    `uvm_object_utils(ARPS_IP_bram_curr_base_seq)
	`uvm_declare_p_sequencer(ARPS_IP_bram_curr_sequencer)
   
//   logic [31:0] image_queue[$];
//   rand bit [31:0] val;
/*   string   img_hex;

   int 		fd;
   string 	file_path = "C:/Users/Nemanja/Desktop/Working/Verification_ARPS_IP_project/images_for_arps/sample50.txt";
   int 		i = 0;  
*/

    // new - constructor
    function new(string name = "ARPS_IP_bram_curr_base_seq_2");
        super.new(name);
    endfunction: new

/*	
	function random_queue();
	
		for(int i=0; i<16385; i++)begin
			val.randomize();
			image_queue.push_back(val);
		end
	
	endfunction 
*/


/*
   function void read_images(); 
		
			`uvm_info(get_type_name(), "Opening file BRAM CURRENT", UVM_MEDIUM)
		
		fd = ($fopen(file_path, "r"));
		
			`uvm_info(get_type_name(), "File potentially opened, extracting image BRAM CURRENT", UVM_MEDIUM)
		
		if(fd)begin
			`uvm_info(get_type_name(), "File OPENED, extracting image BRAM CURRENT", UVM_MEDIUM)
		end
		
		if(fd)begin
			
			`uvm_info(get_type_name(),$sformatf("FILE WITH IMAGE OPENED "),UVM_HIGH)
		 
			
			while(!$feof(fd))begin
				if(i == 16385) begin
 
					$fscanf(fd ,"%s\n",img_hex);
					image_queue.push_back(img_hex.atohex());
					i = 0;    
					
				end  
				else begin
				
					$fscanf(fd ,"%s\n",img_hex);	
					image_queue.push_back(img_hex.atohex());
					i++;
					
				end
            
			end // while (!$feof(fd_img))  
		end
        else
			`uvm_info(get_type_name(),$sformatf("ERROR OPENING FILE WITH IMAGE"),UVM_HIGH)
    
	
		`uvm_info(get_type_name(), "Import image finished BRAM CURRENT", UVM_MEDIUM)
		$fclose(fd);
		`uvm_info(get_type_name(), "After file is closed BRAM CURRENT", UVM_MEDIUM)
	
   endfunction
*/

endclass: ARPS_IP_bram_curr_base_seq_2

`endif

