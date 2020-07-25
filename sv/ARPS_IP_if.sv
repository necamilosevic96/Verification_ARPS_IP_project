/****************************************************************************
    +-+-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+-+-+-+-+ +-+-+ +-+-+-+-+-+-+-+-+
    |F|u|n|c|t|i|o|n|a|l| |V|e|r|i|f|i|c|a|t|i|o|n| |o|f| |H|a|r|d|w|a|r|e|
    +-+-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+-+-+-+-+ +-+-+ +-+-+-+-+-+-+-+-+

    FILE            ARPS_IP_if.sv

    DESCRIPTION     ARPS_IP interface

 ****************************************************************************/

`ifndef ARPS_IP_IF_SV
`define ARPS_IP_IF_SV

parameter integer C_S_AXI_DATA_WIDTH	= 32;
parameter integer C_S_AXI_ADDR_WIDTH	= 4;

interface axil_if(input clk, input rst);

   logic [C_S_AXI_ADDR_WIDTH-1 : 0]       s_axi_awaddr ;
   logic [2 : 0]                      	  s_axi_awprot ;
   logic                              	  s_axi_awvalid ;
   logic                              	  s_axi_awready;
   logic [C_S_AXI_DATA_WIDTH-1 : 0]       s_axi_wdata ;
   logic [(C_S_AXI_DATA_WIDTH/8)-1 : 0]   s_axi_wstrb = 4'b1111;
   logic                              	  s_axi_wvalid ;
   logic                              	  s_axi_wready;
   logic [1 : 0]                      	  s_axi_bresp;
   logic                              	  s_axi_bvalid;
   logic                              	  s_axi_bready ;
   logic [C_S_AXI_ADDR_WIDTH-1 : 0]       s_axi_araddr ;
   logic [2 : 0]                      	  s_axi_arprot ;
   logic                              	  s_axi_arvalid ;
   logic                              	  s_axi_arready;
   logic [C_S_AXI_DATA_WIDTH-1 : 0]       s_axi_rdata;
   logic [1 : 0]                      	  s_axi_rresp;
   logic                              	  s_axi_rvalid;
   logic                              	  s_axi_rready ;
//   logic                              	  start_axi_o ;
 //  logic                              	  ready_axi_i ;
  
    // control
    bit has_checks = 1;
    bit has_coverage = 1;
    
    // TODO : coverage and assertions go here...    

endinterface : axil_if


interface bram_curr_if(input clk, input rst);

	logic 							clk_curr;
	logic [ 31 : 0 ]				addr_curr;
	logic [ 31 : 0 ]				data_curr;
	logic 							en_curr;
	logic [ 3 : 0 ]					we_curr;
	logic 							rst_curr;	

endinterface : bram_curr_if


interface bram_ref_if(input clk, input rst);

	logic 							clk_ref;
	logic [ 31 : 0 ]				addr_ref;
	logic [ 31 : 0 ]				data_ref;
	logic 							en_ref;
	logic [ 3 : 0 ]					we_ref;
	logic 							rst_ref;

endinterface : bram_ref_if


interface bram_mv_if(input clk, input rst);

	logic 							clk_mv;
	logic [ 31 : 0 ]				addr_mv;
	logic [ 31 : 0 ]				data_mv;
	logic 							en_mv;
	logic [ 3 : 0 ]					we_mv;
	logic 							rst_mv;

endinterface : bram_mv_if


interface interrupt_if(input clk, input rst);

	logic						interrupt_o;

endinterface : interrupt_if


`endif

