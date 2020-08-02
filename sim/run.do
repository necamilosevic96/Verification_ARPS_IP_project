################################################################################
#    +-+-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+-+-+-+-+ +-+-+ +-+-+-+-+-+-+-+-+
#    |F|u|n|c|t|i|o|n|a|l| |V|e|r|i|f|i|c|a|t|i|o|n| |o|f| |H|a|r|d|w|a|r|e|
#    +-+-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+-+-+-+-+ +-+-+ +-+-+-+-+-+-+-+-+
#
#    FILE            run
#
#    DESCRIPTION
#
################################################################################

# Create the library.
if [file exists work] {
    vdel -all
}
vlib work

# compile DUT
vcom ../dut/utils_pkg.vhd
vcom ../dut/AXI_ARPS_IP_v1_0.vhd
vcom ../dut/AXI_ARPS_IP_v1_0_S00_AXI.vhd
vcom ../dut/bram_if.vhd
vcom ../dut/control_block.vhd
vcom ../dut/sad_block.vhd
vcom ../dut/arps_ip.vhd

# compile testbench
vlog -sv \
    +incdir+$env(UVM_HOME) \
    +incdir+../sv \
    +incdir+../examples \
    +incdir+../examples/tests \
    ../sv/ARPS_IP_pkg.sv \
    ../examples/ARPS_IP_test_top.sv
    
# run simulation
vsim ARPS_IP_test_top -novopt +UVM_TESTNAME=ARPS_IP_test_simple -sv_seed random
#vsim ARPS_IP_test_top -novopt +UVM_TESTNAME=ARPS_IP_test_simple_2 -sv_seed random

# disable warnings for dut

set NumericStdNoWarnings 1


add wave sim:/ARPS_IP_test_top/axil_vif/*
add wave sim:/ARPS_IP_test_top/bram_curr_vif/*
add wave sim:/ARPS_IP_test_top/bram_ref_vif/*
add wave sim:/ARPS_IP_test_top/bram_mv_vif/*
add wave sim:/ARPS_IP_test_top/interrupt_vif/*
    
#run -all
