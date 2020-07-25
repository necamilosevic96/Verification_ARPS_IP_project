/*******************************************************************************
 +-+-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+-+-+-+-+ +-+-+ +-+-+-+-+-+-+-+-+
 |F|u|n|c|t|i|o|n|a|l| |V|e|r|i|f|i|c|a|t|i|o|n| |o|f| |H|a|r|d|w|a|r|e|
 +-+-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+-+-+-+-+ +-+-+ +-+-+-+-+-+-+-+-+

 FILE            ARPS_IP_scoreboard.sv

 DESCRIPTION     

 *******************************************************************************/

`ifndef ARPS_IP_SCOREBOARD_SV
 `define ARPS_IP_SCOREBOARD_SV
`uvm_analysis_imp_decl(_axil)
`uvm_analysis_imp_decl(_bram_curr)
`uvm_analysis_imp_decl(_bram_ref)
`uvm_analysis_imp_decl(_bram_mv)
`uvm_analysis_imp_decl(_interrupt)



class ARPS_IP_scoreboard extends uvm_scoreboard;
   
//   localparam bit[9:0] sv_array[0:9] = {10'd361, 10'd267, 10'd581, 10'd632, 10'd480, 10'd513, 10'd376, 10'd432, 10'd751, 10'd683};
//   localparam bit[9:0] IMG_LEN = 10'd784; 
   // control fileds
   bit checks_enable = 1;
   bit coverage_enable = 1;
/*   bit res_ready = 0;
   bit[3:0] result =0;
   int img=0;
   int core=0;
   int sv=0;
   int l=0;
   logic[15 : 0] yQ[$];
   logic[15 : 0] bQ[10];
   logic[15 : 0] ltQ[10][$];
   logic[15 : 0] svQ[10][$];
*/
   int           num_of_assertions = 0;   
   // This TLM port is used to connect the scoreboard to the monitor
   uvm_analysis_imp_axil#(ARPS_IP_axil_transaction, ARPS_IP_scoreboard) port_axil;
   uvm_analysis_imp_bram_curr#(ARPS_IP_bram_curr_transaction, ARPS_IP_scoreboard) port_bram_curr;
   uvm_analysis_imp_bram_ref#(ARPS_IP_bram_ref_transaction, ARPS_IP_scoreboard) port_bram_ref;
   uvm_analysis_imp_bram_mv#(ARPS_IP_bram_mv_transaction, ARPS_IP_scoreboard) port_bram_mv;
   uvm_analysis_imp_interrupt#(ARPS_IP_interrupt_transaction, ARPS_IP_scoreboard) port_interrupt;

   int num_of_tr;
//   logic [31:0] reference_model_image [784];   
   `uvm_component_utils_begin(ARPS_IP_scoreboard)
      `uvm_field_int(checks_enable, UVM_DEFAULT)
      `uvm_field_int(coverage_enable, UVM_DEFAULT)
   `uvm_component_utils_end

   function new(string name = "ARPS_IP_scoreboard", uvm_component parent = null);
      super.new(name,parent);
      port_axil = new("port_axil", this);
      port_bram_curr = new("port_bram_curr", this);
      port_bram_ref = new("port_bram_ref", this);
	  port_bram_mv = new("port_bram_mv", this);
      port_interrupt = new("port_interrupt", this);
   endfunction : new
   
   function void report_phase(uvm_phase phase);
      `uvm_info(get_type_name(), $sformatf("Svm_dskw scoreboard examined: %0d transactions", num_of_tr), UVM_LOW);
      `uvm_info(get_type_name(), $sformatf("Number of mismatch assertions for DUT is: %0d ", num_of_assertions), UVM_NONE);
      
   endfunction : report_phase

 
   function write_axil (ARPS_IP_axil_transaction tr);
      ARPS_IP_axil_transaction tr_clone;
      $cast(tr_clone, tr.clone()); 
      if(checks_enable) begin
         // do actual checking here
         // ...
         // ++num_of_tr;
      end
   endfunction : write_axil
   

   function write_bram_curr (ARPS_IP_bram_curr_transaction tr);
      ARPS_IP_bram_curr_transaction tr_clone;
      $cast(tr_clone, tr.clone()); 
      if(checks_enable) begin
         // do actual checking here
         // ...
         // ++num_of_tr;
      end
   endfunction : write_bram_curr 
   
   function write_bram_ref (ARPS_IP_bram_ref_transaction tr);
      ARPS_IP_bram_ref_transaction tr_clone;
      $cast(tr_clone, tr.clone()); 
      if(checks_enable) begin
         // do actual checking here
         // ...
         // ++num_of_tr;
      end
   endfunction : write_bram_ref 
   
   
   function write_bram_mv (ARPS_IP_bram_mv_transaction tr);
      ARPS_IP_bram_mv_transaction tr_clone;
      $cast(tr_clone, tr.clone()); 
      if(checks_enable) begin
         // do actual checking here
         // ...
         // ++num_of_tr;
      end
   endfunction : write_bram_mv 


   //write_interrupt function is not needed 
   function write_interrupt (ARPS_IP_interrupt_transaction tr);
      ARPS_IP_interrupt_transaction tr_clone;
      $cast(tr_clone, tr.clone()); 
      if(checks_enable) begin
         // do actual checking here
         // ...
         // ++num_of_tr;
      end
   endfunction : write_interrupt
   


endclass : ARPS_IP_scoreboard

`endif

