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
   //logic   [31:0] img_hex;
   string   img_hex;

   int 		fd;
   string 	file_path = "C:/Users/Nemanja/Desktop/Working/Verification_ARPS_IP_project/images_for_arps/sample50.txt";
   int 		i = 0;  

//    ../../images_for_arps

    // new - constructor
    function new(string name = "ARPS_IP_bram_curr_base_seq");
        super.new(name);
    endfunction: new

// comment tasks PRE_BODY and POST_BODY
/*
   virtual task pre_body();
      uvm_phase phase = get_starting_phase();
      if (phase != null)
        phase.raise_objection(this, {"Running sequence '", get_full_name(), "'"});
      
   endtask : pre_body 

   // objections are dropped in post_body
   virtual task post_body();
      uvm_phase phase = get_starting_phase();
      if (phase != null)
        phase.drop_objection(this, {"Completed sequence '", get_full_name(), "'"});
   endtask : post_body
*/


   function void read_images();
		
			`uvm_info(get_type_name(), "Opening file BRAM CURRENT", UVM_MEDIUM)
		
		fd = ($fopen(file_path, "r"));
//		fd = $fopen("./sample24.txt", "r");   // opening file from the same folder
		
			`uvm_info(get_type_name(), "File potentially opened, extracting image BRAM CURRENT", UVM_MEDIUM)
		
		if(fd)begin
			`uvm_info(get_type_name(), "File OPENED, extracting image BRAM CURRENT", UVM_MEDIUM)
		end
		
		if(fd)begin
			
			`uvm_info(get_type_name(),$sformatf("FILE WITH IMAGE OPENED "),UVM_HIGH)
		 
			
			while(!$feof(fd))begin
				if(i == 16385) begin

					//`uvm_info(get_type_name(), "PRe ubacivanja zadnje slike u queue BRAM CURRENT", UVM_MEDIUM) 
					$fscanf(fd ,"%s\n",img_hex);
					//image_queue.push_back(img_hex);
					image_queue.push_back(img_hex.atohex());
					//`uvm_info(get_type_name(), "Zadnja slika u queue ubacena BRAM CURRENT", UVM_MEDIUM)

					i = 0;    
					//break;
				end  
				else begin
				
					//`uvm_info(get_type_name(), "Prvi koment u else BRAM CURRENT", UVM_MEDIUM)
					$fscanf(fd ,"%s\n",img_hex);
					//image_queue.push_back(img_hex);
					//`uvm_info(get_type_name(), "Zavrsen scan u else BRAM CURRENT", UVM_MEDIUM)
					image_queue.push_back(img_hex.atohex());
					//`uvm_info(get_type_name(), "Image stavljena u queue BRAM CURRENT", UVM_MEDIUM)

					i++;
					//`uvm_info(get_type_name(), $sformatf("Zadnja slika u queue ubacena BRAM CURRENT %d \n", i), UVM_MEDIUM)
				end
            
			end // while (!$feof(fd_img))  
		end
        else
			`uvm_info(get_type_name(),$sformatf("ERROR OPENING FILE WITH IMAGE"),UVM_HIGH)
    
	
		`uvm_info(get_type_name(), "Import image finished BRAM CURRENT", UVM_MEDIUM)
		$fclose(fd);
		`uvm_info(get_type_name(), "After file is closed BRAM CURRENT", UVM_MEDIUM)
	
   endfunction

endclass: ARPS_IP_bram_curr_base_seq

`endif

