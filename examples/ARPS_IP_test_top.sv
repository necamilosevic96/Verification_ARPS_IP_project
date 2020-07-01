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
    
//    `include "../dut/utils_pkg.vhd"
    
    logic clock;
    logic reset;

    // interface
    axil_if axil_vif(clock, reset);
    bram_curr_if bram_curr_vif(clock, reset);
    bram_ref_if bram_ref_vif(clock, reset);
    bram_mv_if bram_mv_vif(clock, reset);
    
    // DUT
    AXI_ARPS_IP_v1_0_S00_AXI #(  .W_DATA(8),
            .W_ADDRESS(16),
	    .ROW_SIZE(256),
	    .COL_SIZE(256),
	    .MB_SIZE(16),
	    .P_SIZE(7)
        ) AXI_ARPS_IP_v1_0_S00_AXI_inst (
            .S_AXI_ACLK    (clock),
            .S_AXI_ARESETN    (reset),
			.S_AXI_AWADDR(axil_vif.s_axi_awaddr),
			.S_AXI_AWPROT(axil_vif.s_axi_awprot),
			.S_AXI_AWVALID(axil_vif.s_axi_awvalid),
			.S_AXI_AWREADY(axil_vif.s_axi_awready),
			.S_AXI_WDATA(axil_vif.s_axi_wdata),
			.S_AXI_WSTRB(axil_vif.s_axi_wstrb),
			.S_AXI_WVALID(axil_vif.s_axi_wvalid),
			.S_AXI_WREADY(axil_vif.s_axi_wready),
			.S_AXI_BRESP(axil_vif.s_axi_bresp),
			.S_AXI_BVALID(axil_vif.s_axi_bvalid),
			.S_AXI_BREADY(axil_vif.s_axi_bready),
			.S_AXI_ARADDR(axil_vif.s_axi_araddr),
			.S_AXI_ARPROT(axil_vif.s_axi_arprot),
			.S_AXI_ARVALID(axil_vif.s_axi_arvalid),
			.S_AXI_ARREADY(axil_vif.s_axi_arready),
			.S_AXI_RDATA(axil_vif.s_axi_rdata),
			.S_AXI_RRESP(axil_vif.s_axi_rresp),
			.S_AXI_RVALID(axil_vif.s_axi_rvalid),
			.S_AXI_RREADY(axil_vif.s_axi_rready),
			.start_o_axi(axil_vif.start_axi_o),
			.ready_i_axi(axil_vif.ready_axi_i)

        );   


	AXI_ARPS_IP_v1_0 #(  .W_DATA(8),
            .W_ADDRESS(16),
	    .ROW_SIZE(256),
	    .COL_SIZE(256),
	    .MB_SIZE(16),
	    .P_SIZE(7)
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
			.rstb_curr_o(bram_curr_vif.rst_curr)
		);
    // set interface in db; run UVM test
    initial begin
        uvm_config_db#(virtual axil_if)::set(null,"uvm_test_top.*","axil_if", axil_vif);
        uvm_config_db#(virtual bram_curr_if)::set(null,"uvm_test_top.*","bram_curr_if", bram_curr_vif);
        uvm_config_db#(virtual bram_ref_if)::set(null,"uvm_test_top.*","bram_ref_if", bram_ref_vif);
        uvm_config_db#(virtual bram_mv_if)::set(null,"uvm_test_top.*","bram_mv_if", bram_mv_vif);
        run_test();
    end
    
    // initialize clock and reset
    initial begin
        clock <= 1'b0;
        reset <= 1'b0;
        #100 reset <= 1'b1;
		#4900 reset <= 1'b0;
    end

    // generate clock
    always #5 clock = ~clock;    

endmodule : ARPS_IP_test_top

`endif

