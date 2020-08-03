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
   
   logic [31:0] image_queue[$];
   string   img_hex;

   int 		fd;
   //string 	file_path = "C:/Users/Nemanja/Desktop/Working/Verification_ARPS_IP_project/images_for_arps/sample51.txt";
   string   file_path = "..//images_for_arps/sample51.txt";
   int 		i = 0;  
   
   int fd2; // NM new file descriptor


    // new - constructor
    function new(string name = "ARPS_IP_bram_curr_base_seq");
        super.new(name);
    endfunction: new


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

// NM ispis u novi fajl -------START		
		
		fd2 = ($fopen("..//images_for_arps/probanje.txt", "w"));
		
		if(fd2)begin
			for(int i=0; i<image_queue.size(); i++)begin
				$fdisplay(fd2 ,"0x%h" ,image_queue[i]);
			end
		end
		
		$fclose(fd2);
		
// NM ------------------------ END
	
   endfunction

endclass: ARPS_IP_bram_curr_base_seq

`endif

