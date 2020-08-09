/****************************************************************************
    +-+-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+-+-+-+-+ +-+-+ +-+-+-+-+-+-+-+-+
    |F|u|n|c|t|i|o|n|a|l| |V|e|r|i|f|i|c|a|t|i|o|n| |o|f| |H|a|r|d|w|a|r|e|
    +-+-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+-+-+-+-+ +-+-+ +-+-+-+-+-+-+-+-+
    FILE            ARPS_IP_master_simple_seq.sv
    DESCRIPTION     simple sequence; random transactions
 ****************************************************************************/

`ifndef ARPS_IP_AXIL_SIMPLE_SEQ_SV
`define ARPS_IP_AXIL_SIMPLE_SEQ_SV

/**
 * Class: ARPS_IP_axil_simple_seq
 */
class ARPS_IP_axil_simple_seq extends ARPS_IP_axil_base_seq;

    int num_of_seq = 5;
    int cnt_seq = 0;
    // UVM factory registration
    `uvm_object_utils(ARPS_IP_axil_simple_seq)

    // new - constructor
    function new(string name = "ARPS_IP_axil_simple_seq");
        super.new(name);
    endfunction : new

    // sequence generation logic in body
    virtual task body();
	
	req = ARPS_IP_axil_transaction::type_id::create("req");

    `uvm_do_with(req, {req.wr_re == 1'b0; req.addr == 4'b0100; req.wdata == 31'b1; } )
	`uvm_do_with(req, {req.wr_re == 1'b0; req.addr == 4'b0000; req.wdata == 31'b1; } )
    
    `uvm_do_with(req, {req.wr_re == 1'b0; req.addr == 4'b0100; req.wdata == 31'b0; } )
	`uvm_do_with(req, {req.wr_re == 1'b0; req.addr == 4'b0000; req.wdata == 31'b0; } ) 
	
    `uvm_do_with(req, {req.wr_re == 1'b1; req.addr == 4'b0000; req.wdata == 31'b1; } ) // start = 1;
	`uvm_do_with(req, {req.wr_re == 1'b1; req.addr == 4'b0000; req.wdata == 31'b0; } ) // start = 0;
    
    forever begin
        if(cnt_seq < num_of_seq) begin

            if(req.interrupt)begin
                `uvm_info(get_type_name(), "\nAXI_LITE: Interrupt = 1 \n", UVM_MEDIUM)
                req.interrupt = 0;
                cnt_seq++;
            end
   
            `uvm_do_with(req, {req.wr_re == 1'b0; req.addr == 4'b0100; req.wdata == 31'b0; } ) //ready
            if(req.rdata == 32'b1) begin
                `uvm_info(get_type_name(),"\nAXI_LITE: Ready = 1 \n", UVM_MEDIUM);
                `uvm_do_with(req, {req.wr_re == 1'b1; req.addr == 4'b0000; req.wdata == 31'b1; } )//start =1;
                `uvm_info(get_type_name(),"\nAXI_LITE: Start = 1 \n", UVM_MEDIUM);
                `uvm_do_with(req, {req.wr_re == 1'b1; req.addr == 4'b0000; req.wdata == 31'b0; } )//start =0;
                `uvm_info(get_type_name(),"\nAXI_LITE: Start = 0 \n", UVM_MEDIUM);
            end

            `uvm_info(get_type_name(), "Sequence is working AXI LITE", UVM_FULL)
        end
        
        else begin
            break;
        end
    end
    endtask : body

endclass : ARPS_IP_axil_simple_seq

`endif