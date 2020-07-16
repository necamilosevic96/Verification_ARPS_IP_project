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
    
    // configuration
    ARPS_IP_config cfg;
    
    // TLM - from monitor to other components
    uvm_analysis_port #(ARPS_IP_bram_curr_transaction) item_collected_port;
    
    // keep track of number of transactions
    int unsigned num_transactions = 0;
    
    // current transaction
    ARPS_IP_bram_curr_transaction tr_collected;

    // start and stop helper events   KOMENTARI
//    event start_e;
//    event stop_e;
    
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


    extern virtual task run_phase(uvm_phase phase); // dodato nakaknadno, vec dole postoji

//START
/*

    // additional class methods
    extern virtual task start_condition(ref event start_e);
    extern virtual task stop_condition(ref event stop_e);
//    extern virtual task run_phase(uvm_phase phase);
    extern virtual task collect_transactions();
    extern virtual function void report_phase(uvm_phase phase);

*/
//FINISH

endclass : ARPS_IP_bram_curr_monitor

// UVM run_phase
task ARPS_IP_bram_curr_monitor::run_phase(uvm_phase phase);    
 //   forever begin
//START/
//	@(posedge vif.clk)begin
        //`uvm_info(get_type_name(), "Monitor is working BRAM CURRENT", UVM_MEDIUM)

     
//`uvm_info(get_type_name(),$sformatf("Driver run phase started...\n%s",req.sprint()), UVM_HIGH)
	 
 //       @(negedge vif.rst); // reset dropped
 //       `uvm_info(get_type_name(), "Reset dropped", UVM_MEDIUM)
        
  //      fork
 //           @(posedge vif.rst); // reset is active high
//            start_condition(start_e);
//            stop_condition(stop_e);
//            collect_transactions();

//				tr_collected.data_curr_frame = vif.data_curr;


  //      join_any
  //      disable fork;
        // only way to get here is after reset
//	`uvm_info(get_type_name(), $sformatf("Transaction collected data in monitor:\n%s", tr_collected.sprint()), UVM_MEDIUM)
//	end 
//FINISH
        
  //  end
endtask : run_phase


//START
/*



// trigger event when start
task ARPS_IP_monitor::start_condition(ref event start_e);
    forever begin
        wait(vif.sda_wire !== 1'bx); // don't trigger from an X to 0 transition
        @(negedge vif.sda_wire);
        if(vif.scl_wire === 1'b1) begin
            ->start_e;
        end
    end
endtask : start_condition

// trigger event when stop
task ARPS_IP_monitor::stop_condition(ref event stop_e);
    forever begin
        wait(vif.sda_wire !== 1'bx); // don't trigger from an X to 1 transition
        @(posedge vif.sda_wire);
        if(vif.scl_wire === 1'b1) begin
            ->stop_e;
        end
    end
endtask : stop_condition    

// monitor ARPS_IP interface and collect transactions
task ARPS_IP_monitor::collect_transactions();
    forever begin
        wait(start_e.triggered);
        tr_collected = ARPS_IP_bram_transaction::type_id::create("tr_collected", this);
              
        // address
        tr_collected.addr = 0;
        repeat(ADDR_WIDTH) begin
            @(posedge vif.scl_wire);
            #1;
            tr_collected.addr = {tr_collected.addr[ADDR_WIDTH - 2 : 0], vif.sda_wire};
        end 
     
        // read / write bit
        @(posedge vif.scl_wire);
        #1;
        tr_collected.dir = ARPS_IP_direction_enum'(vif.sda_wire);
    
        // ack bit
        @(posedge vif.scl_wire);
        #1;
        if(vif.sda_wire === 1'b0) tr_collected.addr_ack = ARPS_IP_ACK;
        else tr_collected.addr_ack = ARPS_IP_NACK;
        if(cfg.has_checks) begin // check for NACK
	        asrt_addr_nack : assert (tr_collected.addr_ack == ARPS_IP_ACK)
	        else
	            `uvm_error(get_type_name(), $sformatf("Observed address NACK during %s", tr_collected.dir.name))    
        end
        // only if ack
        if(tr_collected.addr_ack == ARPS_IP_ACK) begin
            // data
            repeat(DATA_WIDTH) begin
                @(posedge vif.scl_wire);
                #1;
                tr_collected.data = {tr_collected.data[DATA_WIDTH - 2 : 0], vif.sda_wire};
            end
    
            // ack bit
            @(posedge vif.scl_wire);
            #1;
            if(vif.sda_wire === 1'b0) tr_collected.data_ack = ARPS_IP_ACK;
            else tr_collected.data_ack = ARPS_IP_NACK;
            if(cfg.has_checks) begin // check for NACK
	            asrt_data_nack : assert (tr_collected.data_ack == ARPS_IP_ACK)
	            else
	                `uvm_error(get_type_name(), $sformatf("Observed data NACK during %s", tr_collected.dir.name))
            end
        end
        
        wait(stop_e.triggered);
        
        item_collected_port.write(tr_collected); // TLM
        // collect coverage if enabled
        if(cfg.has_coverage == 1) begin
            cg_ARPS_IP_monitor.sample();
        end
        `uvm_info(get_type_name(), $sformatf("Tr collected :\n%s", tr_collected.sprint()), UVM_MEDIUM)
        num_transactions++;           
    end
endtask : collect_transactions


// UVM report_phase
function void ARPS_IP_monitor::report_phase(uvm_phase phase);
    // final report
    `uvm_info( get_type_name(),
               $sformatf("Report: ARPS_IP monitor collected: %0d transactions", num_transactions),
               UVM_LOW);
endfunction : report_phase

*/
//FINISH



`endif

