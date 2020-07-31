/****************************************************************************
    +-+-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+-+-+-+-+ +-+-+ +-+-+-+-+-+-+-+-+
    |F|u|n|c|t|i|o|n|a|l| |V|e|r|i|f|i|c|a|t|i|o|n| |o|f| |H|a|r|d|w|a|r|e|
    +-+-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+-+-+-+-+ +-+-+ +-+-+-+-+-+-+-+-+

    FILE            ARPS_IP_test_top.sv

    DESCRIPTION     top module
                    - connects DUT and interface
                    - generates clk and reset
                    - runs UVM test

 ****************************************************************************/

`ifndef ARPS_IP_TEST_TOP_SV
`define ARPS_IP_TEST_TOP_SV

/**
 * Module: ARPS_IP_test_top
 */
module ARPS_IP_test_top;

    import uvm_pkg::*;            // import the UVM library
    `include "uvm_macros.svh"     // Include the UVM macros

    import ARPS_IP_pkg::*;            // import the ARPS_IP pkg
    
    `include "ARPS_IP_test_lib.sv"
    
    
    logic clock;
    logic reset;

    // interface
    axil_if axil_vif(clock, reset);
    bram_curr_if bram_curr_vif(clock, reset);
    bram_ref_if bram_ref_vif(clock, reset);
    bram_mv_if bram_mv_vif(clock, reset);
    interrupt_if interrupt_vif(clock, reset);


	AXI_ARPS_IP_v1_0 #(  .W_DATA(8),
	    .ROW_SIZE(256),
	    .COL_SIZE(256),
	    .MB_SIZE(16),
	    .P_SIZE(7),
		.C_S_AXI_DATA_WIDTH(32),
		.C_S_AXI_ADDR_WIDTH(4)
		) DUT_inst (
			.clk_mv_o(bram_mv_vif.clk_mv),
			.addrb_mv_o(bram_mv_vif.addr_mv),
			.dinb_mv_o(bram_mv_vif.data_mv),
			.enb_mv_o(bram_mv_vif.en_mv),
			.web_mv_o(bram_mv_vif.we_mv),
			.rstb_mv_o(bram_mv_vif.rst_mv),
			.clk_ref_o(bram_ref_vif.clk_ref),
			.addrb_ref_o(bram_ref_vif.addr_ref),
			.doutb_ref_i(bram_ref_vif.data_ref),
			.enb_ref_o(bram_ref_vif.en_ref),
			.web_ref_o(bram_ref_vif.we_ref),
			.rstb_ref_o(bram_ref_vif.rst_ref),
			.clk_curr_o(bram_curr_vif.clk_curr),
			.addrb_curr_o(bram_curr_vif.addr_curr),
			.doutb_curr_i(bram_curr_vif.data_curr),
			.enb_curr_o(bram_curr_vif.en_curr),
			.web_curr_o(bram_curr_vif.we_curr),
			.rstb_curr_o(bram_curr_vif.rst_curr),
            .s00_axi_aclk    (clock),
            .s00_axi_aresetn    (reset),
			.s00_axi_awaddr(axil_vif.s_axi_awaddr),
			.s00_axi_awprot(axil_vif.s_axi_awprot),
			.s00_axi_awvalid(axil_vif.s_axi_awvalid),
			.s00_axi_awready(axil_vif.s_axi_awready),
			.s00_axi_wdata(axil_vif.s_axi_wdata),
			.s00_axi_wstrb(axil_vif.s_axi_wstrb),
			.s00_axi_wvalid(axil_vif.s_axi_wvalid),
			.s00_axi_wready(axil_vif.s_axi_wready),
			.s00_axi_bresp(axil_vif.s_axi_bresp),
			.s00_axi_bvalid(axil_vif.s_axi_bvalid),
			.s00_axi_bready(axil_vif.s_axi_bready),
			.s00_axi_araddr(axil_vif.s_axi_araddr),
			.s00_axi_arprot(axil_vif.s_axi_arprot),
			.s00_axi_arvalid	(axil_vif.s_axi_arvalid),
			.s00_axi_arready(axil_vif.s_axi_arready),
			.s00_axi_rdata(axil_vif.s_axi_rdata),
			.s00_axi_rresp(axil_vif.s_axi_rresp),
			.s00_axi_rvalid(axil_vif.s_axi_rvalid),
			.s00_axi_rready(axil_vif.s_axi_rready),
			.interrupt(interrupt_vif.interrupt_o)
		);
    // set interface in db; run UVM test
    initial begin
        uvm_config_db#(virtual axil_if)::set(null,"uvm_test_top.*","axil_if", axil_vif);
        uvm_config_db#(virtual bram_curr_if)::set(null,"uvm_test_top.*","bram_curr_if", bram_curr_vif);
        uvm_config_db#(virtual bram_ref_if)::set(null,"uvm_test_top.*","bram_ref_if", bram_ref_vif);
        uvm_config_db#(virtual bram_mv_if)::set(null,"uvm_test_top.*","bram_mv_if", bram_mv_vif);
        uvm_config_db#(virtual interrupt_if)::set(null,"uvm_test_top.*","interrupt_if", interrupt_vif);
        run_test();
    end
    
    // initialize clock and reset
    initial begin
        clock <= 1'b0;
        reset <= 1'b1;
        #10 reset <= 1'b0;
		#110 reset <= 1'b1;
    end

    // generate clock
    always #5 clock = ~clock;    

endmodule : ARPS_IP_test_top

`endif

