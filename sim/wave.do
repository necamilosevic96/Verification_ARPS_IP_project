onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /ARPS_IP_test_top/axil_vif/clk
add wave -noupdate -radix hexadecimal /ARPS_IP_test_top/axil_vif/rst
add wave -noupdate -group AXI_LITE -radix hexadecimal /ARPS_IP_test_top/axil_vif/s_axi_awaddr
add wave -noupdate -group AXI_LITE -radix hexadecimal /ARPS_IP_test_top/axil_vif/s_axi_awprot
add wave -noupdate -group AXI_LITE -radix hexadecimal /ARPS_IP_test_top/axil_vif/s_axi_awvalid
add wave -noupdate -group AXI_LITE -radix hexadecimal /ARPS_IP_test_top/axil_vif/s_axi_awready
add wave -noupdate -group AXI_LITE -radix hexadecimal /ARPS_IP_test_top/axil_vif/s_axi_wdata
add wave -noupdate -group AXI_LITE -radix hexadecimal /ARPS_IP_test_top/axil_vif/s_axi_wstrb
add wave -noupdate -group AXI_LITE -radix hexadecimal /ARPS_IP_test_top/axil_vif/s_axi_wvalid
add wave -noupdate -group AXI_LITE -radix hexadecimal /ARPS_IP_test_top/axil_vif/s_axi_wready
add wave -noupdate -group AXI_LITE -radix hexadecimal /ARPS_IP_test_top/axil_vif/s_axi_bresp
add wave -noupdate -group AXI_LITE -radix hexadecimal /ARPS_IP_test_top/axil_vif/s_axi_bvalid
add wave -noupdate -group AXI_LITE -radix hexadecimal /ARPS_IP_test_top/axil_vif/s_axi_bready
add wave -noupdate -group AXI_LITE -radix hexadecimal /ARPS_IP_test_top/axil_vif/s_axi_araddr
add wave -noupdate -group AXI_LITE -radix hexadecimal /ARPS_IP_test_top/axil_vif/s_axi_arprot
add wave -noupdate -group AXI_LITE -radix hexadecimal /ARPS_IP_test_top/axil_vif/s_axi_arvalid
add wave -noupdate -group AXI_LITE -radix hexadecimal /ARPS_IP_test_top/axil_vif/s_axi_arready
add wave -noupdate -group AXI_LITE -radix hexadecimal /ARPS_IP_test_top/axil_vif/s_axi_rdata
add wave -noupdate -group AXI_LITE -radix hexadecimal /ARPS_IP_test_top/axil_vif/s_axi_rresp
add wave -noupdate -group AXI_LITE -radix hexadecimal /ARPS_IP_test_top/axil_vif/s_axi_rvalid
add wave -noupdate -group AXI_LITE -radix hexadecimal /ARPS_IP_test_top/axil_vif/s_axi_rready
add wave -noupdate -expand -group BRAM_CURR -radix hexadecimal /ARPS_IP_test_top/bram_curr_vif/clk
add wave -noupdate -expand -group BRAM_CURR -radix hexadecimal /ARPS_IP_test_top/bram_curr_vif/rst
add wave -noupdate -expand -group BRAM_CURR -radix hexadecimal /ARPS_IP_test_top/bram_curr_vif/clk_curr
add wave -noupdate -expand -group BRAM_CURR -radix hexadecimal /ARPS_IP_test_top/bram_curr_vif/addr_curr
add wave -noupdate -expand -group BRAM_CURR -radix hexadecimal /ARPS_IP_test_top/bram_curr_vif/data_curr
add wave -noupdate -expand -group BRAM_CURR -radix hexadecimal /ARPS_IP_test_top/bram_curr_vif/en_curr
add wave -noupdate -expand -group BRAM_CURR -radix hexadecimal /ARPS_IP_test_top/bram_curr_vif/we_curr
add wave -noupdate -expand -group BRAM_CURR -radix hexadecimal /ARPS_IP_test_top/bram_curr_vif/rst_curr
add wave -noupdate -expand -group BRAM_REF -radix hexadecimal /ARPS_IP_test_top/bram_ref_vif/clk
add wave -noupdate -expand -group BRAM_REF -radix hexadecimal /ARPS_IP_test_top/bram_ref_vif/rst
add wave -noupdate -expand -group BRAM_REF -radix hexadecimal /ARPS_IP_test_top/bram_ref_vif/clk_ref
add wave -noupdate -expand -group BRAM_REF -radix hexadecimal /ARPS_IP_test_top/bram_ref_vif/addr_ref
add wave -noupdate -expand -group BRAM_REF -radix hexadecimal /ARPS_IP_test_top/bram_ref_vif/data_ref
add wave -noupdate -expand -group BRAM_REF -radix hexadecimal /ARPS_IP_test_top/bram_ref_vif/en_ref
add wave -noupdate -expand -group BRAM_REF -radix hexadecimal /ARPS_IP_test_top/bram_ref_vif/we_ref
add wave -noupdate -expand -group BRAM_REF -radix hexadecimal /ARPS_IP_test_top/bram_ref_vif/rst_ref
add wave -noupdate -expand -group BRAM_MV -radix hexadecimal /ARPS_IP_test_top/bram_mv_vif/clk
add wave -noupdate -expand -group BRAM_MV -radix hexadecimal /ARPS_IP_test_top/bram_mv_vif/rst
add wave -noupdate -expand -group BRAM_MV -radix hexadecimal /ARPS_IP_test_top/bram_mv_vif/clk_mv
add wave -noupdate -expand -group BRAM_MV -radix hexadecimal /ARPS_IP_test_top/bram_mv_vif/addr_mv
add wave -noupdate -expand -group BRAM_MV -radix hexadecimal /ARPS_IP_test_top/bram_mv_vif/data_mv
add wave -noupdate -expand -group BRAM_MV -radix hexadecimal /ARPS_IP_test_top/bram_mv_vif/en_mv
add wave -noupdate -expand -group BRAM_MV -radix hexadecimal /ARPS_IP_test_top/bram_mv_vif/we_mv
add wave -noupdate -expand -group BRAM_MV -radix hexadecimal /ARPS_IP_test_top/bram_mv_vif/rst_mv
add wave -noupdate -expand -group INTERRUPT -radix hexadecimal /ARPS_IP_test_top/interrupt_vif/interrupt_o
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
configure wave -namecolwidth 365
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {2570 ns}
