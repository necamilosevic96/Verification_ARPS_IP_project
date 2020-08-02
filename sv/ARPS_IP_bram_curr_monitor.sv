/****************************************************************************
    +-+-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+-+-+-+-+ +-+-+ +-+-+-+-+-+-+-+-+
    |F|u|n|c|t|i|o|n|a|l| |V|e|r|i|f|i|c|a|t|i|o|n| |o|f| |H|a|r|d|w|a|r|e|
    +-+-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+-+-+-+-+ +-+-+ +-+-+-+-+-+-+-+-+

    FILE            ARPS_IP_monitor.sv

    DESCRIPTION     

 ****************************************************************************/

`ifndef ARPS_IP_BRAM_CURR_MONITOR_SV
`define ARPS_IP_BRAM_CURR_MONITOR_SV

/*
 * Class: ARPS_IP_monitor
 */
class ARPS_IP_bram_curr_monitor extends uvm_monitor;
    
    // ARPS_IP virtual interface
    virtual bram_curr_if vif;
	
	
	logic [31:0]  address_r;
	//logic [31:0]  address_r2 = 32'h00000000;
	logic [31:0]  data_r;
	//int fd;
	bit   [31:0]  addr_cnt = 32'h00000000;
    
    // configuration
    ARPS_IP_config cfg;
    
    // TLM - from monitor to other components
    uvm_analysis_port #(ARPS_IP_bram_curr_transaction) item_collected_port;
    
    // keep track of number of transactions
    int unsigned num_transactions = 0;
    
    // current transaction
    ARPS_IP_bram_curr_transaction tr_collected;

    
    // UVM factory registration
    `uvm_component_utils_begin(ARPS_IP_bram_curr_monitor)
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
    function new(string name = "ARPS_IP_bram_curr_monitor", uvm_component parent = null);
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
        if(!uvm_config_db#(virtual bram_curr_if)::get(this, "", "bram_curr_if", vif))
            `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"})    
    endfunction : connect_phase


    extern virtual task run_phase(uvm_phase phase);

endclass : ARPS_IP_bram_curr_monitor

// UVM run_phase
task ARPS_IP_bram_curr_monitor::run_phase(uvm_phase phase);    
    
	tr_collected = ARPS_IP_bram_curr_transaction::type_id::create("tr_collected", this);
	
	//fd = ($fopen("C:/Users/Nemanja/Desktop/Working/Verification_ARPS_IP_project/sv/proba.txt"));
	
	forever begin

		@(posedge vif.clk)begin

			address_r = vif.addr_curr;

					
			//if(address_r!=address_r2 && address_r!=32'h00000000) begin
			if(address_r==addr_cnt) begin

//				@(posedge vif.clk)begin // NM clk wait

				data_r = vif.data_curr;
				//address_r2 = address_r;
				
				addr_cnt = addr_cnt + 32'h00000004;

				//$fdisplay(fd ,"0x%h\n" ,data_r);
				
				//if(address_r2==32'h0000ffff)begin
					//$fclose(fd);
				//end
				tr_collected.address_curr = address_r;
				tr_collected.data_curr_frame = data_r;
		
				item_collected_port.write(tr_collected);
				
				`uvm_info(get_type_name(), $sformatf("Transaction collected data in monitor BRAM CURRENT:\n%s", tr_collected.sprint()), UVM_MEDIUM)
				
//				end // clk wait
			
			end //if
			
//			if (addr_cnt>32'h0000FFFF) begin
//                addr_cnt = 32'h00000000;
//            end
		
		end 

        
    end  // forever begin
	
endtask : run_phase


`endif

