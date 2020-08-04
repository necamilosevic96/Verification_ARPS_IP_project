/****************************************************************************
    +-+-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+-+-+-+-+ +-+-+ +-+-+-+-+-+-+-+-+
    |F|u|n|c|t|i|o|n|a|l| |V|e|r|i|f|i|c|a|t|i|o|n| |o|f| |H|a|r|d|w|a|r|e|
    +-+-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+-+-+-+-+ +-+-+ +-+-+-+-+-+-+-+-+

    FILE            ARPS_IP_master_driver.sv

    DESCRIPTION     

 ****************************************************************************/

`ifndef ARPS_IP_AXIL_DRIVER_SV
`define ARPS_IP_AXIL_DRIVER_SV

/*
 * Class: ARPS_IP_axil_driver
 */
 
`uvm_analysis_imp_decl(_interrupt_a)
class ARPS_IP_axil_driver extends uvm_driver #(ARPS_IP_axil_transaction);
    
	uvm_analysis_imp_interrupt_a#(ARPS_IP_interrupt_transaction, ARPS_IP_axil_driver) port_interrupt_a;
	
    // ARPS_IP virtual interface
    virtual axil_if vif;
	
	int    interrupt_o = 0;
    
    // configuration
    ARPS_IP_axil_config axil_cfg;
    
    // UVM factory registration
    `uvm_component_utils_begin(ARPS_IP_axil_driver)
        `uvm_field_object(axil_cfg, UVM_DEFAULT | UVM_REFERENCE)
    `uvm_component_utils_end       

    // new - constructor
    function new(string name = "ARPS_IP_axil_driver", uvm_component parent = null);
        super.new(name, parent);
		port_interrupt_a = new("port_interrupt_a", this);
    endfunction : new
    
    // UVM build_phase
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        // get configuration object from db
        if(!uvm_config_db#(ARPS_IP_axil_config)::get(this, "*", "ARPS_IP_axil_config", axil_cfg))
            `uvm_fatal("NOCONFIG",{"Config object must be set for: ",get_full_name(),".axil_cfg"})
    endfunction: build_phase
    
    // UVM connect_phase
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        // get interface from db
        if(!uvm_config_db#(virtual axil_if)::get(this, "", "axil_if", vif))
            `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"})    
    endfunction : connect_phase
    
    // additional class methods
    extern virtual task run_phase(uvm_phase phase); 
	extern function write_interrupt_a(ARPS_IP_interrupt_transaction tr);

endclass : ARPS_IP_axil_driver

// UVM run_phase
task ARPS_IP_axil_driver::run_phase(uvm_phase phase);


	@(negedge vif.rst);       
        forever begin
         seq_item_port.get_next_item(req);
         `uvm_info(get_type_name(), $sformatf("Driver sending...\n %s", req.sprint()), UVM_HIGH)
         // do actual driving here
	      
	      @(posedge vif.clk)begin//writing using AXIL
		  
		  if(interrupt_o == 1)begin
		         interrupt_o = 0;	       
		         req.interrupt = 1;       
		         continue;
			end
		  
	         if(req.wr_re)begin//read = 0, write = 1
	            vif.s_axi_awaddr = req.addr;
	            vif.s_axi_awvalid = 1;
	            vif.s_axi_wdata = req.wdata;
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
	         else begin
	            vif.s_axi_araddr = req.addr;
               vif.s_axi_arvalid = 1;
               vif.s_axi_rready = 1;
	            wait(vif.s_axi_arready);
               wait(vif.s_axi_rvalid);	           
	            vif.s_axi_arvalid = 0;
               vif.s_axi_araddr = 0;
	            wait(!vif.s_axi_rvalid);
               req.rdata = vif.s_axi_rdata;               
	            vif.s_axi_rready = 0;	       
	         end	         
	      end // @ (posedge vif.s_axi_aclk)
	      
	      //end of driving
        seq_item_port.item_done();
      end
	  
      
endtask : run_phase


function ARPS_IP_axil_driver::write_interrupt_a (ARPS_IP_interrupt_transaction tr);
      `uvm_info(get_type_name(), "INTERRUPT HAPPENED", UVM_FULL)
      interrupt_o = 1;
      
endfunction : write_interrupt_a

`endif