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

	//logic   [31:0] img_hex_1;
    string   img_hex_1;

	int 		fd_1;
	string 	file_path = "C:/Users/Nemanja/Desktop/Working/Verification_ARPS_IP_project/images_for_arps/sample51.txt";
	int 		i = 0;  

    // new - constructor
    function new(string name = "ARPS_IP_bram_ref_base_seq");
        super.new(name);
    endfunction: new

   function void read_pixels();
		
			`uvm_info(get_type_name(), "Opening file BRAM CURRENT", UVM_MEDIUM)
		
		fd_1 = ($fopen(file_path, "r"));
//		fd = $fopen("./sample24.txt", "r");   // opening file from the same folder
		
			`uvm_info(get_type_name(), "File potentially opened, extracting image BRAM CURRENT", UVM_MEDIUM)
		
		if(fd_1)begin
			`uvm_info(get_type_name(), "File OPENED, extracting image BRAM CURRENT", UVM_MEDIUM)
		end
		
		if(fd_1)begin
			
			`uvm_info(get_type_name(),$sformatf("FILE WITH IMAGE OPENED "),UVM_HIGH)
		 
			
			while(!$feof(fd_1))begin
				if(i == 16385) begin

					//`uvm_info(get_type_name(), "PRe ubacivanja zadnje slike u queue BRAM CURRENT", UVM_MEDIUM)
					$fscanf(fd_1 ,"%s\n",img_hex_1);
					//pixel_queue.push_back(img_hex_1);
					pixel_queue.push_back(img_hex_1.atohex());
					//`uvm_info(get_type_name(), "Zadnja slika u queue ubacena BRAM CURRENT", UVM_MEDIUM) 

					i = 0;    
					//break;
				end  
				else begin
				
					//`uvm_info(get_type_name(), "Prvi koment u else BRAM CURRENT", UVM_MEDIUM)
					$fscanf(fd_1 ,"%s\n",img_hex_1);
					//pixel_queue.push_back(img_hex_1);
					//`uvm_info(get_type_name(), "Zavrsen scan u else BRAM CURRENT", UVM_MEDIUM)
					pixel_queue.push_back(img_hex_1.atohex());
					//`uvm_info(get_type_name(), "Image stavljena u queue BRAM CURRENT", UVM_MEDIUM)

					i++;
					//`uvm_info(get_type_name(), $sformatf("Zadnja slika u queue ubacena BRAM CURRENT %d \n", i), UVM_MEDIUM)
				end
            
			end // while (!$feof(fd_img))  
		end
        else
			`uvm_info(get_type_name(),$sformatf("ERROR OPENING FILE WITH IMAGE"),UVM_HIGH)
    
	
		`uvm_info(get_type_name(), "Import image finished BRAM CURRENT", UVM_MEDIUM)
		$fclose(fd_1);
		`uvm_info(get_type_name(), "After file is closed BRAM CURRENT", UVM_MEDIUM)
	
   endfunction

endclass: ARPS_IP_bram_ref_base_seq

`endif

