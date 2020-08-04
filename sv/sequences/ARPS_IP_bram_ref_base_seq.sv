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
	
	logic [31:0] pixel_queue[$];
    string   img_hex_1;

	int 		fd_1;
	//string 	file_path = "C:/Users/Nemanja/Desktop/Working/Verification_ARPS_IP_project/images_for_arps/sample50.txt";
	string   file_path = "..//images_for_arps/sample68.txt";
	int 		i = 0;  

    // new - constructor
    function new(string name = "ARPS_IP_bram_ref_base_seq");
        super.new(name);
    endfunction: new
    
/*    function void read_pixels();
        while(i !=16385) begin
            pixel_queue.push_back($urandom_range(0, 32'hFFFFFFFF));
            i++;
        end
    endfunction
*/    
    

   function void read_pixels();
		
			`uvm_info(get_type_name(), "Opening file BRAM REFERENT", UVM_MEDIUM)
		
		fd_1 = ($fopen(file_path, "r"));

		
		if(fd_1)begin
			`uvm_info(get_type_name(), "File OPENED, extracting pixels BRAM REFERENT", UVM_MEDIUM)
		end
		
		if(fd_1)begin
			
			`uvm_info(get_type_name(),$sformatf("FILE WITH IMAGE OPENED "),UVM_HIGH)
		 
			
			while(!$feof(fd_1))begin
				if(i == 16385) begin

					$fscanf(fd_1 ,"%s\n",img_hex_1);
					pixel_queue.push_back(img_hex_1.atohex());
					i = 0;    

				end  
				else begin
				
					$fscanf(fd_1 ,"%s\n",img_hex_1);
					pixel_queue.push_back(img_hex_1.atohex());
					i++;

				end
            
			end // while (!$feof(fd_img))  
		end
        else
			`uvm_info(get_type_name(),$sformatf("ERROR OPENING FILE WITH IMAGE"),UVM_HIGH)
    
	
		`uvm_info(get_type_name(), "Import image finished BRAM REFERENT", UVM_MEDIUM)
		$fclose(fd_1);
		`uvm_info(get_type_name(), "After file is closed BRAM REFERENT", UVM_MEDIUM)
	
   endfunction

endclass: ARPS_IP_bram_ref_base_seq

`endif

