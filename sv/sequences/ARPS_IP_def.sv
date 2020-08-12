/****************************************************************************
    +-+-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+-+-+-+-+ +-+-+ +-+-+-+-+-+-+-+-+
    |F|u|n|c|t|i|o|n|a|l| |V|e|r|i|f|i|c|a|t|i|o|n| |o|f| |H|a|r|d|w|a|r|e|
    +-+-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+-+-+-+-+ +-+-+ +-+-+-+-+-+-+-+-+

    FILE            ARPS_IP_master_base_seq.sv

    DESCRIPTION     base sequence to be extended by other sequences

 ****************************************************************************/

`ifndef ARPS_IP_DEF_SV
`define ARPS_IP_DEF_SV

class ARPS_IP_def;
    int num_of_seq = 10;// number of sequences
    int ref_frame_num = 50; //starting txt file in folder "images_for_arps" (sample50.txt)
    int curr_frame_num = 51;
    
    function int get_num_of_seq();
        return num_of_seq;
    endfunction
    
    function int get_ref_frame_num();
        return ref_frame_num;
    endfunction
    
    function int get_curr_frame_num();
        return curr_frame_num;
    endfunction
endclass

`endif