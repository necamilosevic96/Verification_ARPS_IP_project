    clk_i:          1bit    global clock
    reset_i:        1bit    global reset   !!! active on 0  !!!
    interrupt:      1bit    zynq_interrupt
    
-------------------------------------------------------------
                    AXI_LITE REGISTERS
-------------------------------------------------------------
INPUTS:
    start_i:        1bit    slv_reg0        AXIL_BASE_ADDR
OUTPUTS:
    ready_o:        1bit    slv_reg1        AXIL_BASE_ADDR+4 
******************************************************************

                 3 BRAM CONTROLLERS
******************************************************************
BRAM_CURR: DATA_WIDTH=32  (4pix * 8 bits) exp. 0xff00ff00 (255 , 0 ,255 , 0)
           ADDR_WIDTH=32  (16384 locations)
--------------------------------------------
BRAM_REF:  DATA_WIDTH=32
           ADDR_WIDTH=32  (16384 locations)
--------------------------------------------
BRAM_MV:   DATA_WIDTH=32  (signed data)
           ADDR_WIDTH=32  (512 locations)
--------------------------------------------


res: 256x256 pix
data_width: 8bit (0:255) grayscale
MB_SIZE: 16 (block 16x16pix)
P_SIZE: 7 (search area from -7 to 7 [up,down,left,right])
------------------------------------





