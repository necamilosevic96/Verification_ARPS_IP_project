/****************************************************************************
    +-+-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+-+-+-+-+ +-+-+ +-+-+-+-+-+-+-+-+
    |F|u|n|c|t|i|o|n|a|l| |V|e|r|i|f|i|c|a|t|i|o|n| |o|f| |H|a|r|d|w|a|r|e|
    +-+-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+-+-+-+-+ +-+-+ +-+-+-+-+-+-+-+-+

    FILE            ARPS_IP_monitor.sv

    DESCRIPTION     

 ****************************************************************************/

`ifndef ARPS_IP_BRAM_REF_MONITOR_SV
`define ARPS_IP_BRAM_REF_MONITOR_SV

/*
 * Class: ARPS_IP_monitor
 */
class ARPS_IP_bram_ref_monitor extends uvm_monitor;
    
    // ARPS_IP virtual interface
    virtual bram_ref_if vif;
	
	logic [31:0]  address_r;
	//logic [31:0]  address_r2 = 32'h00000000;
	logic [31:0]  data_r;
	bit   [31:0]  addr_cnt = 32'h00000000;
    
    /*DEBUG*/
    bit flag_f_open = 1'b1;
    bit flag_f_close = 1'b0;
    bit flag_f_write =1'b0;
    int cnt=0;
    int fd; //file descriptor
    
    /*END DEBUG*/
    
    // configuration
    ARPS_IP_config cfg;
    
    // TLM - from monitor to other components
    uvm_analysis_port #(ARPS_IP_bram_ref_transaction) item_collected_port;
    
    // keep track of number of transactions
    int unsigned num_transactions = 0;
    
    // current transaction
    ARPS_IP_bram_ref_transaction tr_collected_ref;

    // UVM factory registration
    `uvm_component_utils_begin(ARPS_IP_bram_ref_monitor)
        `uvm_field_object(cfg, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_component_utils_end    
 

//START
/*       
    // coverage
    covergroup cg_ARPS_IP_monitor;
        // cover direction - read or write
        cp_direction : coverpoint tr_collected.dir {
            bins write = {ARPS_IP_WRITE};
            bins read  = {ARPS_IP_READ};
        }
        // cover address ack
        cp_addr_ack : coverpoint tr_collected.addr_ack {
            bins ack  = {ARPS_IP_ACK};
            bins nack = {ARPS_IP_NACK};            
        }
        // cover data ack
        cp_data_ack : coverpoint tr_collected.data_ack {
            bins ack  = {ARPS_IP_ACK};
            bins nack = {ARPS_IP_NACK};            
        }        
        // TODO : add others
    endgroup : cg_ARPS_IP_monitor;


*/
//FINISH

    // new - constructor
    function new(string name = "ARPS_IP_bram_ref_monitor", uvm_component parent = null);
        super.new(name, parent);
        item_collected_port = new("item_collected_port", this);
       // cg_ARPS_IP_monitor = new(); ------------------------------------------------komentttt
    endfunction : new
    
    // UVM build_phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        // get configuration object from db
        if(!uvm_config_db#(ARPS_IP_config)::get(this, "", "ARPS_IP_config", cfg))
            `uvm_fatal("NOCONFIG",{"Config object must be set for: ",get_full_name(),".cfg"})
    endfunction: build_phase
    
    // UVM connect_phase
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        // get interface from db
        if(!uvm_config_db#(virtual bram_ref_if)::get(this, "", "bram_ref_if", vif))
            `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"})    
    endfunction : connect_phase


    extern virtual task run_phase(uvm_phase phase);

endclass : ARPS_IP_bram_ref_monitor

// UVM run_phase
task ARPS_IP_bram_ref_monitor::run_phase(uvm_phase phase);   

 
  tr_collected_ref = ARPS_IP_bram_ref_transaction::type_id::create("tr_collected_ref", this);
	
	forever begin

		@(posedge vif.clk)begin
            /*[SS] DEBUG: Wrtie in txt file*/
            if(flag_f_open==1'b1) begin
                fd=$fopen("ref_monitor.txt","w");
                if(fd) $display("File was opened");
                else $display("ERROR: File was not opened");
                flag_f_open=1'b0;
                flag_f_write=1'b1;
            end
            /*END [SS] DEBUG: Wrtie in txt file*/
            
			address_r = vif.addr_ref;
            
            /*[SS] DEBUG: Wrtie in txt file*/
            if(flag_f_write==1'b1) begin
                data_r = vif.data_ref;
                $fdisplay(fd,"addr[%d]=%x data[%d]=%x",cnt,address_r,cnt,data_r);
                cnt++;
                if(address_r==32'h0000FFFF) begin
                    flag_f_write=1'b0;
                    flag_f_close=1'b1;
                end
            end
            /*END [SS] DEBUG: Wrtie in txt file*/
            
			//if(address_r!=address_r2 && address_r!=32'h00000000) begin
			if(address_r==addr_cnt) begin
			
				addr_cnt = addr_cnt + 32'h00000004;

				data_r = vif.data_ref;
				//address_r2 = address_r;

				tr_collected_ref.address_ref = address_r;
				tr_collected_ref.data_ref_frame = data_r;
				
				item_collected_port.write(tr_collected_ref);

				`uvm_info(get_type_name(), $sformatf("Transaction collected data in monitor BRAM REFERENT:\n%s", tr_collected_ref.sprint()), UVM_MEDIUM)
	
			end // if
			
//			if(addr_cnt>32'h0000FFFF) begin
//                addr_cnt = 32'h00000000;
//            end
            
            /*[SS] DEBUG: Wrtie in txt file*/
            if(flag_f_close==1'b1) begin
                fd=$fopen("ref_monitor.txt","w");
                flag_f_open=1'b0;
            end
            /*END [SS] DEBUG: Wrtie in txt file*/
		end 

        
    end  // forever begin
endtask : run_phase

`endif

