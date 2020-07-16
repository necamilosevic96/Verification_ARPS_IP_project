library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.utils_pkg.all;

entity AXI_ARPS_IP_v1_0 is
	generic (
		-- Users to add parameters here
        W_DATA:         integer:=8;
        --W_ADDRESS :     integer:=16;
        ROW_SIZE:       integer:=256;
        COL_SIZE:       integer:=256;
        MB_SIZE:         integer:=16;
        P_SIZE:          integer:=7;
		-- User parameters ends
		-- Do not modify the parameters beyond this line


		-- Parameters of Axi Slave Bus Interface S00_AXI
		C_S00_AXI_DATA_WIDTH	: integer	:= 32;
		C_S00_AXI_ADDR_WIDTH	: integer	:= 4
	);
	port (
		-- Users to add ports here
        interrupt: out std_logic;
        --BRAM interface MV
        clk_mv_o: out std_logic;
        addrb_mv_o: out std_logic_vector(31 downto 0);
        dinb_mv_o: out std_logic_vector(31 downto 0);
        enb_mv_o: out std_logic;
        web_mv_o: out std_logic_vector(3 downto 0);
        rstb_mv_o: out std_logic;
	    --doutb_vect_i:in std_logic_vector(31 downto 0); --not used
        --BRAM interface Ref Img
        clk_ref_o: out std_logic;
        addrb_ref_o: out std_logic_vector(31 downto 0);
        doutb_ref_i: in std_logic_vector(31 downto 0);
        enb_ref_o: out std_logic;
        web_ref_o: out std_logic_vector(3 downto 0);
        rstb_ref_o: out std_logic;
        --din_ref_o: out std_logic_vector(31 downto 0);
        --BRAM interface Curr Img
        clk_curr_o: out std_logic;
        addrb_curr_o: out std_logic_vector(31 downto 0);
        doutb_curr_i: in std_logic_vector(31 downto 0);
        enb_curr_o: out std_logic;
        web_curr_o: out std_logic_vector(3 downto 0);
        rstb_curr_o: out std_logic;
        --din_curr_o: out std_logic_vector(31 downto 0);
        -- User ports ends
        -- Do not modify the ports beyond this line


		-- Ports of Axi Slave Bus Interface S00_AXI
		s00_axi_aclk	: in std_logic;
		s00_axi_aresetn	: in std_logic;
		s00_axi_awaddr	: in std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0);
		s00_axi_awprot	: in std_logic_vector(2 downto 0);
		s00_axi_awvalid	: in std_logic;
		s00_axi_awready	: out std_logic;
		s00_axi_wdata	: in std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
		s00_axi_wstrb	: in std_logic_vector((C_S00_AXI_DATA_WIDTH/8)-1 downto 0);
		s00_axi_wvalid	: in std_logic;
		s00_axi_wready	: out std_logic;
		s00_axi_bresp	: out std_logic_vector(1 downto 0);
		s00_axi_bvalid	: out std_logic;
		s00_axi_bready	: in std_logic;
		s00_axi_araddr	: in std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0);
		s00_axi_arprot	: in std_logic_vector(2 downto 0);
		s00_axi_arvalid	: in std_logic;
		s00_axi_arready	: out std_logic;
		s00_axi_rdata	: out std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
		s00_axi_rresp	: out std_logic_vector(1 downto 0);
		s00_axi_rvalid	: out std_logic;
		s00_axi_rready	: in std_logic
	);
end AXI_ARPS_IP_v1_0;

architecture arch_imp of AXI_ARPS_IP_v1_0 is
constant W_ADDRESS: integer:= log2c(ROW_SIZE*COL_SIZE);
	-- component declaration
	component arps_ip is
    generic(
        W_DATA:         integer:=8;
        --W_ADDRESS:     integer:=16;
        ROW_SIZE:       integer:=256;
        COL_SIZE:       integer:=256;
        MB_SIZE:         integer:=16;
        P_SIZE:          integer:=7
        );
    port(
        clk_i:    in std_logic; --ok
        reset_i:  in std_logic; --ok
        start_i:  in std_logic; --ok
        ready_o:  out std_logic; --ok
        interrupt: out std_logic; --ok
        --BRAM inteface MV
        addrb_mv_o: out std_logic_vector(31 downto 0);
        dinb_mv_o: out std_logic_vector(31 downto 0);
        enb_mv_o: out std_logic;
        web_mv_o: out std_logic_vector(3 downto 0);
        rstb_mv_o: out std_logic;
        --doutb_vect_i:in std_logic_vector(31 downto 0); --not used
        --BRAM interface Ref Img
        addrb_ref_o: out std_logic_vector(31 downto 0);
        doutb_ref_i: in std_logic_vector(31 downto 0);
        enb_ref_o: out std_logic;
        web_ref_o: out std_logic_vector(3 downto 0);
        rstb_ref_o: out std_logic;
        --din_ref_o: out std_logic_vector(31 downto 0);
        --BRAM interface Curr Img
        addrb_curr_o: out std_logic_vector(31 downto 0);
        doutb_curr_i: in std_logic_vector(31 downto 0);
        enb_curr_o: out std_logic;
        web_curr_o: out std_logic_vector(3 downto 0);
        rstb_curr_o: out std_logic
        --din_curr_o: out std_logic_vector(31 downto 0)
        
        );
    end component;
	-- component declaration
	component AXI_ARPS_IP_v1_0_S00_AXI is
		generic (
        W_DATA:         integer:=8;
        --W_ADDRESS :     integer:=16;
        ROW_SIZE:       integer:=256;
        COL_SIZE:       integer:=256;
        MB_SIZE:         integer:=16;
        P_SIZE:          integer:=7;
		C_S_AXI_DATA_WIDTH	: integer	:= 32;
		C_S_AXI_ADDR_WIDTH	: integer	:= 4
		);
		port (
        start_o_axi:  out std_logic;
        ready_i_axi:  in std_logic;
		S_AXI_ACLK	: in std_logic;
		S_AXI_ARESETN	: in std_logic;
		S_AXI_AWADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		S_AXI_AWPROT	: in std_logic_vector(2 downto 0);
		S_AXI_AWVALID	: in std_logic;
		S_AXI_AWREADY	: out std_logic;
		S_AXI_WDATA	: in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		S_AXI_WSTRB	: in std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
		S_AXI_WVALID	: in std_logic;
		S_AXI_WREADY	: out std_logic;
		S_AXI_BRESP	: out std_logic_vector(1 downto 0);
		S_AXI_BVALID	: out std_logic;
		S_AXI_BREADY	: in std_logic;
		S_AXI_ARADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		S_AXI_ARPROT	: in std_logic_vector(2 downto 0);
		S_AXI_ARVALID	: in std_logic;
		S_AXI_ARREADY	: out std_logic;
		S_AXI_RDATA	: out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		S_AXI_RRESP	: out std_logic_vector(1 downto 0);
		S_AXI_RVALID	: out std_logic;
		S_AXI_RREADY	: in std_logic
		);
	end component AXI_ARPS_IP_v1_0_S00_AXI;
    signal start_o_axi_s: std_logic;
    signal ready_i_axi_s:   std_logic;
begin
    
-- Instantiation of Axi Bus Interface S00_AXI
AXI_ARPS_IP_v1_0_S00_AXI_inst : AXI_ARPS_IP_v1_0_S00_AXI
	generic map (
        W_DATA=>W_DATA,
        --W_ADDRESS=>W_ADDRESS,
        ROW_SIZE=>ROW_SIZE,
        COL_SIZE=>COL_SIZE,
        MB_SIZE=>MB_SIZE,
        P_SIZE=>P_SIZE,
		C_S_AXI_DATA_WIDTH	=> C_S00_AXI_DATA_WIDTH,
		C_S_AXI_ADDR_WIDTH	=> C_S00_AXI_ADDR_WIDTH
	)
	port map (
        start_o_axi=>start_o_axi_s,
        ready_i_axi=>ready_i_axi_s,
		S_AXI_ACLK	=> s00_axi_aclk,
		S_AXI_ARESETN	=> s00_axi_aresetn,
		S_AXI_AWADDR	=> s00_axi_awaddr,
		S_AXI_AWPROT	=> s00_axi_awprot,
		S_AXI_AWVALID	=> s00_axi_awvalid,
		S_AXI_AWREADY	=> s00_axi_awready,
		S_AXI_WDATA	=> s00_axi_wdata,
		S_AXI_WSTRB	=> s00_axi_wstrb,
		S_AXI_WVALID	=> s00_axi_wvalid,
		S_AXI_WREADY	=> s00_axi_wready,
		S_AXI_BRESP	=> s00_axi_bresp,
		S_AXI_BVALID	=> s00_axi_bvalid,
		S_AXI_BREADY	=> s00_axi_bready,
		S_AXI_ARADDR	=> s00_axi_araddr,
		S_AXI_ARPROT	=> s00_axi_arprot,
		S_AXI_ARVALID	=> s00_axi_arvalid,
		S_AXI_ARREADY	=> s00_axi_arready,
		S_AXI_RDATA	=> s00_axi_rdata,
		S_AXI_RRESP	=> s00_axi_rresp,
		S_AXI_RVALID	=> s00_axi_rvalid,
		S_AXI_RREADY	=> s00_axi_rready
	);

	-- Add user logic here
    arps_ip_inst: arps_ip
    generic map(
        W_DATA=>W_DATA,
        --W_ADDRESS=>W_ADDRESS,
        ROW_SIZE=>ROW_SIZE,
        COL_SIZE=>COL_SIZE,
        MB_SIZE=>MB_SIZE,
        P_SIZE=>P_SIZE
        )
    port map(
        clk_i=>s00_axi_aclk,
        reset_i=>s00_axi_aresetn,
        start_i=>start_o_axi_s,
        ready_o=>ready_i_axi_s,
        interrupt=>interrupt,
        addrb_mv_o=>addrb_mv_o,
        dinb_mv_o=>dinb_mv_o,
        enb_mv_o=>enb_mv_o,
        web_mv_o=>web_mv_o,
        rstb_mv_o=>rstb_mv_o,
        --doutb_vect_i=>doutb_vect_i,
        --BRAM interface Ref Img
        addrb_ref_o=>addrb_ref_o,
        doutb_ref_i=>doutb_ref_i,
        enb_ref_o=>enb_ref_o,
        web_ref_o=>web_ref_o,
        rstb_ref_o=>rstb_ref_o,
        --din_ref_o=>din_ref_o,
        --BRAM interface Curr Img
        addrb_curr_o=>addrb_curr_o,
        doutb_curr_i=>doutb_curr_i,
        enb_curr_o=>enb_curr_o,
        web_curr_o=>web_curr_o,
        rstb_curr_o=>rstb_curr_o
        --din_curr_o=>din_curr_o
        );
     clk_mv_o<=s00_axi_aclk;
     clk_ref_o<=s00_axi_aclk;
     clk_curr_o<=s00_axi_aclk;
	-- User logic ends

end arch_imp;
