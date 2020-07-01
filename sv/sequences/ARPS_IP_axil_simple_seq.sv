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

    rand int unsigned num_of_tr;

    // constraints
    constraint num_of_tr_cst { num_of_tr inside {[5 : 10]};}

    // UVM factory registration
    `uvm_object_utils(ARPS_IP_axil_simple_seq)

    // new - constructor
    function new(string name = "ARPS_IP_axil_simple_seq");
        super.new(name);
    endfunction : new

    // sequence generation logic in body
    virtual task body();
        repeat(num_of_tr) begin
            `uvm_do_with(req, {req.we_curr == 1'b1; })
        `uvm_info(get_type_name(), "Sequence is working AXI LITE", UVM_MEDIUM)
        end
    endtask : body

endclass : ARPS_IP_axil_simple_seq

`endif
