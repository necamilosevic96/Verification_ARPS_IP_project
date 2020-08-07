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
   
    logic [31:0] curr_queue[$];
    int unsigned	i = 0;
    int unsigned cnt_seq = 4;
    // new - constructor
    function new(string name = "ARPS_IP_bram_curr_base_seq_2");
        super.new(name);
    endfunction: new


    function void read_curr_img(int sel);
        init_queue();
        case(sel)
            0:  begin 
                    for(int p=0;p<16384;p++) begin
                        curr_queue[p]=32'h00000000;
                    end
                    `uvm_info(get_type_name(), $sformatf("BRAM_CURR_SEQ: ALL ZEROS %d", sel), UVM_MEDIUM)
                end
                
            1:  begin
                    for(int p=0;p<16384;p++) begin
                        curr_queue[p]=32'h00000000;
                    end
                    `uvm_info(get_type_name(), $sformatf("BRAM_CURR_SEQ: ALL ZEROS %d", sel), UVM_MEDIUM)
                end
                
            2:  begin
                    for(int p=0;p<16384;p++) begin
                        curr_queue[p]=32'hFFFFFFFF;;
                    end
                    `uvm_info(get_type_name(), $sformatf("BRAM_CURR_SEQ: ALL ONES %d", sel), UVM_MEDIUM)
                end
                
            3:  begin
                    for(int p=0;p<16384;p++) begin
                        curr_queue[p]=32'hFFFFFFFF;;
                    end
                    `uvm_info(get_type_name(), $sformatf("BRAM_CURR_SEQ: ALL ONES %d", sel), UVM_MEDIUM)
                end
                
            4:  begin
                    while(i !=16384) begin
                        curr_queue[i]=($urandom_range(0, 32'hFFFFFFFF));
                        i++;
                    end
                    `uvm_info(get_type_name(), $sformatf("BRAM_CURR_SEQ: Random %d", cnt_seq), UVM_MEDIUM)
                    cnt_seq++;
                end
            default: 
                `uvm_error(get_type_name(), "BRAM_CURR: Invalid 'sel' value!!! ")
            endcase
    endfunction
    
    function void init_queue();
        i=0;
        for(int k=0;k<16384;k++) begin
            curr_queue[k]=0;
        end
        `uvm_info(get_type_name(), $sformatf("BRAM_CURR_SEQ: Init_queue"), UVM_HIGH)
    endfunction
endclass: ARPS_IP_bram_curr_base_seq_2

`endif

