/****************************************************************************
    +-+-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+-+-+-+-+ +-+-+ +-+-+-+-+-+-+-+-+
    |F|u|n|c|t|i|o|n|a|l| |V|e|r|i|f|i|c|a|t|i|o|n| |o|f| |H|a|r|d|w|a|r|e|
    +-+-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+-+-+-+-+ +-+-+ +-+-+-+-+-+-+-+-+

    FILE            ARPS_IP_master_driver.sv

    DESCRIPTION     

 ****************************************************************************/

`ifndef ARPS_IP_BRAM_MV_DRIVER_SV
`define ARPS_IP_BRAM_MV_DRIVER_SV

/*
 * Class: ARPS_IP_bram_mv_driver
 */
class ARPS_IP_bram_mv_driver extends uvm_driver #(ARPS_IP_bram_mv_transaction);
    
    // ARPS_IP virtual interface
    virtual bram_mv_if vif;
    
    // configuration
    ARPS_IP_bram_mv_config bram_mv_cfg;
    
    // UVM factory registration
    `uvm_component_utils_begin(ARPS_IP_bram_mv_driver)
        `uvm_field_object(bram_mv_cfg, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_component_utils_end       

    // new - constructor
    function new(string name = "ARPS_IP_bram_mv_driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction : new
    
    // UVM build_phase
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        // get configuration object from db
        if(!uvm_config_db#(ARPS_IP_bram_mv_config)::get(this, "*", "ARPS_IP_bram_mv_config", bram_mv_cfg))
            `uvm_fatal("NOCONFIG",{"Config object must be set for: ",get_full_name(),".bram_mv_cfg"})
    endfunction: build_phase
    
    // UVM connect_phase
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        // get interface from db
        if(!uvm_config_db#(virtual bram_mv_if)::get(this, "", "bram_mv_if", vif))
            `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"})    
    endfunction : connect_phase
    
    // additional class methods
    extern virtual task run_phase(uvm_phase phase); 
//    extern virtual task reset();
//    extern virtual task drive_transaction(ARPS_IP_bram_transaction tr);
//    extern virtual task drive_start(ARPS_IP_bram_transaction tr);
//    extern virtual task drive_stop(ARPS_IP_bram_transaction tr);
//    extern virtual task drive_bit(input logic bit_to_drive, input int unsigned scl_period);
//    extern virtual task read_bit(output logic bit_read, input int unsigned scl_period);

endclass : ARPS_IP_bram_mv_driver

// UVM run_phase
task ARPS_IP_bram_mv_driver::run_phase(uvm_phase phase);
//    reset(); // init

 //   forever begin
/* novaaaaaa
	@(negedge vif.rst);       
        forever begin
         seq_item_port.get_next_item(req);
         `uvm_info(get_type_name(),
                   $sformatf("Driver sending...\n%s", req.sprint()),
                   UVM_FULL)
         // do actual driving here
	      
	      @(posedge vif.clk)begin//writing using AXIL
	         if(req.we_curr)begin//read = 0, write = 1
	            vif.s_axi_awaddr = req.addr_curr;
	            vif.s_axi_awvalid = 1;
	            vif.s_axi_wdata = req.data_curr;
	            vif.s_axi_wvalid = 1;
	            vif.s_axi_bready = 1'b1;	       
	            wait(vif.s_axi_awready && vif.s_axi_wready);	       
	            wait(vif.s_axi_bvalid);
	            vif.s_axi_wdata = 0;
	            vif.s_axi_awvalid = 0; 
	            vif.s_axi_wvalid = 0;
               wait(!vif.s_axi_bvalid);	   
	            vif.s_axi_bready = 0;
	         end // if (req.read_write)
/*	         else begin
	            vif.s_axi_araddr = req.mv_addr;
               vif.s_axi_arvalid = 1;
               vif.s_axi_rready = 1;
	            wait(vif.s_axi_arready);
               wait(vif.s_axi_rvalid);	           
	            vif.s_axi_arvalid = 0;
               vif.s_axi_araddr = 0;
	            wait(!vif.s_axi_rvalid);
               req.data_out = vif.s_axi_rdata;               
	            vif.s_axi_rready = 0;	       
	         end
*/ //stari koment ali dotle dolazi novi	         
//	      end // @ (posedge vif.s_axi_aclk)
	      
	      //end of driving
//         seq_item_port.item_done();
//      end


//START

//        `uvm_info(get_type_name(), "Driver is working BRAM MOTION", UVM_MEDIUM)

//        fork
//            @(posedge vif.rst); // reset is active high
  //          forever begin
			
//			`uvm_info(get_type_name(),$sformatf("Driver run phase started...\n%s", req.sprint()), UVM_HIGH)
//			`uvm_info(get_type_name(), "Driver is working insade loop BRAM MOTION", UVM_MEDIUM)			
                seq_item_port.get_next_item(req);

        //`uvm_info(get_type_name(), "Driver is working BRAM MOTION", UVM_MEDIUM)

	//	  vif.s_axi_awvalid = 1'b1;

 //               drive_start(req);
//                drive_transaction(req);
//                drive_stop(req);
               seq_item_port.item_done();
//            end
//        join_any
//        disable fork;
//        reset();


//FINISH

 //   end
      
endtask : run_phase


//START
/*



// reset signals
task ARPS_IP_master_driver::reset();
    `uvm_info(get_type_name(), "Reset observed", UVM_MEDIUM)
    vif.scl <= 1'b1;
    vif.sda <= 1'b1;
    @(negedge vif.rst); // reset dropped
endtask : reset

// drive start condition
task ARPS_IP_master_driver::drive_start(ARPS_IP_bram_transaction tr);

    @(posedge vif.clk); // sync

    vif.scl <= 1'b1;
    vif.sda <= 1'b0;

    repeat(tr.start_hold) @(posedge vif.clk);

    vif.scl <= 1'b1;
    repeat(tr.scl_period / 2) @(posedge vif.clk);
    vif.scl <= 1'b0;
    repeat(tr.scl_period / 4) @(posedge vif.clk);

endtask : drive_start

// drive stop condition
task ARPS_IP_master_driver::drive_stop(ARPS_IP_bram_transaction tr);

    @(posedge vif.clk); // sync

    vif.sda <= 1'b0;

    repeat(tr.scl_period / 2) @(posedge vif.clk);
    vif.scl <= 1'b1;

    repeat(tr.stop_setup) @(posedge vif.clk);
    vif.sda <= 1'b1;

    repeat(tr.delay) @(posedge vif.clk);

endtask : drive_stop

// drive transaction
task ARPS_IP_master_driver::drive_transaction(ARPS_IP_bram_transaction tr);
    logic ack;

    // drive address (msb first)
    for(int i = ADDR_WIDTH; i > 0; --i) begin
        drive_bit(tr.addr[i-1], tr.scl_period);
    end

    // drive direction
    drive_bit(tr.dir, tr.scl_period);

    // get ack from slave
    read_bit(ack, tr.scl_period);
    if(ack === 1'b0) tr.addr_ack = ARPS_IP_ACK;
    else tr.addr_ack = ARPS_IP_NACK;

    // recieved ack - continue
    if(tr.addr_ack == 1'b0) begin
        if(tr.dir == ARPS_IP_WRITE) begin
            for(int i = DATA_WIDTH; i > 0; --i) begin
                drive_bit(tr.data[i - 1], tr.scl_period); 
            end
            // get ack from slave
            read_bit(ack, tr.scl_period);
            if(ack === 1'b0) tr.data_ack = ARPS_IP_ACK;
            else tr.data_ack = ARPS_IP_NACK;
        end
        else begin // READ
            // get data - msb first
            for(int i = DATA_WIDTH; i > 0; --i) begin
                read_bit(tr.data[i-1], tr.scl_period);
            end
        
            // ack or nack
            drive_bit(tr.data_ack, tr.scl_period);
        end
    end
    
    `uvm_info(get_type_name(), $sformatf("ARPS_IP Finished Driving tr \n%s", tr.sprint()), UVM_HIGH)

endtask : drive_transaction

// drive one bit
task ARPS_IP_master_driver::drive_bit(input logic bit_to_drive, input int unsigned scl_period);

    vif.sda <= bit_to_drive;
    repeat(scl_period / 4) @(posedge vif.clk);
    vif.scl <= 1'b1;
    repeat(scl_period / 2) @(posedge vif.clk);
    vif.scl <= 1'b0;
    repeat(scl_period / 4) @(posedge vif.clk);

endtask : drive_bit

// read one bit
task ARPS_IP_master_driver::read_bit(output logic bit_read, input int unsigned scl_period);

    vif.sda <= 1'bZ;
    repeat(scl_period / 4) @(posedge vif.clk);
    vif.scl <= 1'b1;
    repeat(scl_period / 4) @(posedge vif.clk);
    bit_read = vif.sda_wire;
    repeat(scl_period / 4) @(posedge vif.clk);
    vif.scl <= 1'b0;
    repeat(scl_period / 4) @(posedge vif.clk);

endtask : read_bit


*/
//FINSIH

`endif

