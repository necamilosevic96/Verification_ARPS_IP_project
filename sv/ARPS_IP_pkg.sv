/****************************************************************************
    +-+-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+-+-+-+-+ +-+-+ +-+-+-+-+-+-+-+-+
    |F|u|n|c|t|i|o|n|a|l| |V|e|r|i|f|i|c|a|t|i|o|n| |o|f| |H|a|r|d|w|a|r|e|
    +-+-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+-+-+-+-+ +-+-+ +-+-+-+-+-+-+-+-+

    FILE            ARPS_IP_pkg.sv

    DESCRIPTION     package containing all parameters and includes

 ****************************************************************************/

`ifndef ARPS_IP_PKG_SV
`define ARPS_IP_PKG_SV

/*
 * Package: ARPS_IP_pkg
 */
package ARPS_IP_pkg;
    
    parameter int ADDR_WIDTH = 7;
    parameter int DATA_WIDTH = 8;
    
    typedef class ARPS_IP_axil_transaction;
    typedef class ARPS_IP_axil_config;
    typedef class ARPS_IP_axil_driver;
    typedef class ARPS_IP_axil_agent;
    typedef class ARPS_IP_config;
    typedef class ARPS_IP_axil_monitor;
    typedef class ARPS_IP_env;
	typedef class ARPS_IP_bram_curr_transaction;
    typedef class ARPS_IP_bram_curr_config;
    typedef class ARPS_IP_bram_curr_driver;
    typedef class ARPS_IP_bram_curr_agent;
    typedef class ARPS_IP_bram_curr_monitor;
	
	typedef class ARPS_IP_bram_ref_transaction;
    typedef class ARPS_IP_bram_ref_config;
    typedef class ARPS_IP_bram_ref_driver;
    typedef class ARPS_IP_bram_ref_agent;
    typedef class ARPS_IP_bram_ref_monitor;
	
	typedef class ARPS_IP_bram_mv_transaction;
    typedef class ARPS_IP_bram_mv_config;
//    typedef class ARPS_IP_bram_mv_driver;
    typedef class ARPS_IP_bram_mv_agent;
    typedef class ARPS_IP_bram_mv_monitor;
	
	typedef class ARPS_IP_interrupt_transaction;
    typedef class ARPS_IP_interrupt_config;
	typedef class ARPS_IP_interrupt_agent;
	typedef class ARPS_IP_interrupt_monitor;
	typedef class ARPS_IP_scoreboard;

    import uvm_pkg::*;
    `include "uvm_macros.svh"
    
    //`include "ARPS_IP_types.sv"
    
    `include "ARPS_IP_axil_config.sv"
    `include "ARPS_IP_axil_driver.sv"
    `include "ARPS_IP_axil_agent.sv"
    `include "sequences/ARPS_IP_axil_seq_lib.sv"
    `include "ARPS_IP_bram_curr_config.sv"
    `include "ARPS_IP_bram_curr_driver.sv"
    `include "ARPS_IP_bram_curr_agent.sv"
    `include "sequences/ARPS_IP_bram_curr_seq_lib.sv"
    `include "ARPS_IP_bram_ref_config.sv"
    `include "ARPS_IP_bram_ref_driver.sv"
    `include "ARPS_IP_bram_ref_agent.sv"
    `include "sequences/ARPS_IP_bram_ref_seq_lib.sv"
    `include "ARPS_IP_bram_mv_config.sv"
//    `include "ARPS_IP_bram_mv_driver.sv"
    `include "ARPS_IP_bram_mv_agent.sv"
//    `include "sequences/ARPS_IP_bram_mv_seq_lib.sv"
	`include "ARPS_IP_interrupt_config.sv"
	`include "ARPS_IP_interrupt_agent.sv"
	`include "ARPS_IP_scoreboard.sv"
    

    // top
    `include "ARPS_IP_axil_transaction.sv"
	`include "ARPS_IP_bram_curr_transaction.sv"
	`include "ARPS_IP_bram_ref_transaction.sv"
	`include "ARPS_IP_bram_mv_transaction.sv"
	`include "ARPS_IP_interrupt_transaction.sv"    
    `include "ARPS_IP_config.sv"
    `include "ARPS_IP_axil_monitor.sv"
    `include "ARPS_IP_bram_curr_monitor.sv"
    `include "ARPS_IP_bram_ref_monitor.sv"
    `include "ARPS_IP_bram_mv_monitor.sv"
	`include "ARPS_IP_interrupt_monitor.sv"
    `include "ARPS_IP_env.sv"

endpackage: ARPS_IP_pkg

`include "ARPS_IP_if.sv"

`endif

