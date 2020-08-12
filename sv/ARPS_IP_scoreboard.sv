/*******************************************************************************
 +-+-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+-+-+-+-+ +-+-+ +-+-+-+-+-+-+-+-+
 |F|u|n|c|t|i|o|n|a|l| |V|e|r|i|f|i|c|a|t|i|o|n| |o|f| |H|a|r|d|w|a|r|e|
 +-+-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+-+-+-+-+ +-+-+ +-+-+-+-+-+-+-+-+

 FILE            ARPS_IP_scoreboard.sv

 DESCRIPTION     

 *******************************************************************************/


`ifndef ARPS_IP_SCOREBOARD_SV
 `define ARPS_IP_SCOREBOARD_SV
 
`uvm_analysis_imp_decl(_axil)
`uvm_analysis_imp_decl(_bram_curr)
`uvm_analysis_imp_decl(_bram_ref)
`uvm_analysis_imp_decl(_bram_mv)
`uvm_analysis_imp_decl(_interrupt)


`define MB_SIZE 16
`define ROW 256
`define COL 256
`define P_SIZE 7
`define MAX2(x, y) (((x) > (y)) ? (x) : (y))
//`define DISPLAY_DATA 1

typedef int queue_of_int[2][$]; //0 position is data, 1 position is flag(write)
typedef int queue_of_int_m[$];

class ARPS_IP_scoreboard extends uvm_scoreboard;
   

    // control fileds
    bit checks_enable = 1;
    bit coverage_enable = 1;
    bit init_flag = 1'b1;
    bit finish_flag_curr = 1'b0;
    bit finish_flag_ref = 1'b0;
    bit start_flag = 1'b0;
   
    int num_of_mv_bram =0;
    int num_of_assertions = 0; 
   
    queue_of_int curr_queue;//2d
    queue_of_int ref_queue;//2d
    queue_of_int_m mv_ref;//one dimension
    logic [31:0] mv_bram_q [$];
   

   
    // This TLM port is used to connect the scoreboard to the monitor
    uvm_analysis_imp_axil#(ARPS_IP_axil_transaction, ARPS_IP_scoreboard) port_axil;
    uvm_analysis_imp_bram_curr#(ARPS_IP_bram_curr_transaction, ARPS_IP_scoreboard) port_bram_curr;
    uvm_analysis_imp_bram_ref#(ARPS_IP_bram_ref_transaction, ARPS_IP_scoreboard) port_bram_ref;
    uvm_analysis_imp_bram_mv#(ARPS_IP_bram_mv_transaction, ARPS_IP_scoreboard) port_bram_mv;
    uvm_analysis_imp_interrupt#(ARPS_IP_interrupt_transaction, ARPS_IP_scoreboard) port_interrupt;

    int num_of_tr;

    `uvm_component_utils_begin(ARPS_IP_scoreboard)
        `uvm_field_int(checks_enable, UVM_DEFAULT)
        `uvm_field_int(coverage_enable, UVM_DEFAULT)
    `uvm_component_utils_end

    function new(string name = "ARPS_IP_scoreboard", uvm_component parent = null);
        super.new(name,parent);
        port_axil = new("port_axil", this);
        port_bram_curr = new("port_bram_curr", this);
        port_bram_ref = new("port_bram_ref", this);
        port_bram_mv = new("port_bram_mv", this);
        port_interrupt = new("port_interrupt", this);
    endfunction : new
   
    function void report_phase(uvm_phase phase);
      `uvm_info(get_type_name(), $sformatf("ARPS_IP scoreboard examined: %0d transactions", num_of_tr), UVM_LOW);
      //`uvm_info(get_type_name(), $sformatf("Number of mismatch assertions for DUT is: %0d ", num_of_assertions), UVM_NONE);
      
    endfunction : report_phase
    
    
 
    function write_axil (ARPS_IP_axil_transaction tr);
        ARPS_IP_axil_transaction tr_clone;
        $cast(tr_clone, tr.clone()); 
        if(checks_enable) begin
            if(tr_clone.addr==0 && tr_clone.wdata==1) begin
                 
            end
            // do actual checking here
            // ...
            //++num_of_tr;
        end
    endfunction : write_axil
   
//****************WRITE-BRAM-CURRENT-FRAME*******************************************************************************
    function write_bram_curr (ARPS_IP_bram_curr_transaction tr);  
        ARPS_IP_bram_curr_transaction tr_clone;
        $cast(tr_clone, tr.clone());
        
        if(init_flag == 1'b1) begin
            init_flag = 1'b0;
            init_queues(65536, 512, 1);
        end
        
        if(checks_enable) begin
            if(curr_queue[1][tr_clone.address_curr] == 0) begin //chech if flag is 0
                `uvm_info(get_type_name(),$sformatf("WRITE_BRAM_CURR: addr_curr = %x data_curr = %x \n",tr_clone.address_curr,tr_clone.data_curr_frame),UVM_HIGH)
                //DATA
                curr_queue[0][tr_clone.address_curr + 0] = ((tr_clone.data_curr_frame >> 24) & 32'h000000FF);
                curr_queue[0][tr_clone.address_curr + 1] = ((tr_clone.data_curr_frame >> 16) & 32'h000000FF);
                curr_queue[0][tr_clone.address_curr + 2] = ((tr_clone.data_curr_frame >>  8) & 32'h000000FF);
                curr_queue[0][tr_clone.address_curr + 3] = ((tr_clone.data_curr_frame >>  0) & 32'h000000FF);
                
                //FLAGS
                curr_queue[1][tr_clone.address_curr + 0] = 1;
                curr_queue[1][tr_clone.address_curr + 1] = 1;
                curr_queue[1][tr_clone.address_curr + 2] = 1;
                curr_queue[1][tr_clone.address_curr + 3] = 1;
                
               `ifdef DISPLAY_DATA
                    $display("curr_address=%x  curr_data=%x",tr_clone.address_curr,tr_clone.data_curr_frame);
                    $display("currp[%d]=%x", tr_clone.address_curr + 0, curr_queue[0][tr_clone.address_curr + 0]);
                    $display("currp[%d]=%x", tr_clone.address_curr + 1, curr_queue[0][tr_clone.address_curr + 1]);
                    $display("currp[%d]=%x", tr_clone.address_curr + 2, curr_queue[0][tr_clone.address_curr + 2]);
                    $display("currp[%d]=%x", tr_clone.address_curr + 3, curr_queue[0][tr_clone.address_curr + 3]);
                    $display("*******************************");
                `endif
                if(tr_clone.address_curr == 32'h0000FFFC) begin
                    //$display("FLAG_CURR=1");
                    `uvm_info(get_type_name(),"WRITE_BRAM_CURR: Data for REF model stored in queue for current frame.",UVM_LOW);
                    finish_flag_curr = 1'b1;
                    
                end
            end
            //`uvm_info(get_type_name(), $sformatf("SCOREBOARD QUEUE 3    %p\n", curr_queue),UVM_HIGH)
            //`uvm_info(get_type_name(),$sformatf("SCOREBOARD QUEUE \n"),UVM_HIGH)
            // do actual checking here
            // ...
             ++num_of_tr;
        end
    endfunction : write_bram_curr 


//****************WRITE-BRAM-REFERENC-FRAME*******************************************************************************   
    function write_bram_ref (ARPS_IP_bram_ref_transaction tr);
        ARPS_IP_bram_ref_transaction tr_clone;
        $cast(tr_clone, tr.clone()); 
        if(init_flag == 1'b1) begin
            init_flag = 1'b0;
            init_queues(65536, 512, 1);      
        end
        
        if(checks_enable) begin
        
            if(ref_queue[1][tr_clone.address_ref] == 0) begin //chech if flag is 0    
                `uvm_info(get_type_name(),$sformatf("WRITE_BRAM_REF: addr_ref = %x data_ref = %x \n",tr_clone.address_ref,tr_clone.data_ref_frame),UVM_HIGH)
                //DATA
                ref_queue[0][tr_clone.address_ref + 0] = ((tr_clone.data_ref_frame >> 24) & 32'h000000FF);
                ref_queue[0][tr_clone.address_ref + 1] = ((tr_clone.data_ref_frame >> 16) & 32'h000000FF);
                ref_queue[0][tr_clone.address_ref + 2] = ((tr_clone.data_ref_frame >>  8) & 32'h000000FF);
                ref_queue[0][tr_clone.address_ref + 3] = ((tr_clone.data_ref_frame >>  0) & 32'h000000FF);
                
                //FLAGS
                ref_queue[1][tr_clone.address_ref + 0] = 1;
                ref_queue[1][tr_clone.address_ref + 1] = 1;
                ref_queue[1][tr_clone.address_ref + 2] = 1;
                ref_queue[1][tr_clone.address_ref + 3] = 1;
                
               `ifdef DISPLAY_DATA
                    $display("ref_address=%x  ref_data=%x",tr_clone.address_ref,tr_clone.data_ref_frame);
                    $display("refp[%d]=%x", tr_clone.address_ref + 0, ref_queue[0][tr_clone.address_ref + 0]);
                    $display("refp[%d]=%x", tr_clone.address_ref + 1, ref_queue[0][tr_clone.address_ref + 1]);
                    $display("refp[%d]=%x", tr_clone.address_ref + 2, ref_queue[0][tr_clone.address_ref + 2]);
                    $display("refp[%d]=%x", tr_clone.address_ref + 3, ref_queue[0][tr_clone.address_ref + 3]);
                    $display("*******************************");
                `endif
                if(tr_clone.address_ref == 32'h0000FFFC) begin
                    finish_flag_ref = 1'b1;
                    `uvm_info(get_type_name(),"WRITE_BRAM_REF: Data for REF model stored in queue for reference frame.",UVM_LOW);
                    
                end
            end
            // do actual checking here
            // ...
             ++num_of_tr;
        end
    endfunction : write_bram_ref 
//******************************************************************************   
    function write_bram_mv (ARPS_IP_bram_mv_transaction tr);
        ARPS_IP_bram_mv_transaction tr_clone;
        $cast(tr_clone, tr.clone()); 
        if(checks_enable) begin
            if(num_of_mv_bram<512) begin
                mv_bram_q[num_of_mv_bram]=tr_clone.data_mv_frame;
                `uvm_info(get_type_name(),$sformatf("WRITE_BRAM_MV: \naddr = 0h%x \ndata = 0h%x \nnum_of_mv_bram = %0d\n",tr_clone.address_mv,tr_clone.data_mv_frame,num_of_mv_bram),UVM_MEDIUM)
                num_of_mv_bram++;
            end
            
            if(finish_flag_curr == 1'b1 && finish_flag_ref == 1'b1 && num_of_mv_bram ==512) begin
                for( int a=0; a<65536 ;a++) begin
                    if(ref_queue[1][a] == 0 || curr_queue[1][a] == 0) begin
                        `uvm_fatal(get_type_name(), $sformatf("SCOREBOARD: Data is not written to ref_queue or curr_queue. Position: %d",a ))
                    end
                end
                `uvm_info(get_type_name(),"WRITE_BRAM_MV: Data is ready for checking.",UVM_LOW)
                finish_flag_curr =1'b0;
                finish_flag_ref =1'b0;
                num_of_mv_bram = 0;
                mv_ref = motionARPS(curr_queue,ref_queue);
                for(int i=0;i<512;i++) begin
                    assert(mv_bram_q[i] == mv_ref[i])
                        `uvm_info(get_type_name(),$sformatf("ASSERT:  BRAM_MV[%d]=%x REF_MV[%d]=%x , OK",i,mv_bram_q[i],i,mv_ref[i]),UVM_LOW)
                        //$display("ASSERT: BRAM_MV[%d]=%x REF_MV[%d]=%x , OK",i,mv_bram_q[i],i,mv_ref[i]);
                    else begin
                        `uvm_fatal(get_type_name(), $sformatf("MISMATCH MV: BRAM_MV[%d]= %h \t REF_MV[%d]= %h",i, mv_bram_q[i], i,mv_ref[i] ))
                    end
                end
                mv_ref.delete;
                init_queues(65536,512,1);
            end
            // do actual checking here
            // ...
            // ++num_of_tr;
        end
    endfunction : write_bram_mv 

//*******************************************************************************
    function write_interrupt (ARPS_IP_interrupt_transaction tr);
        ARPS_IP_interrupt_transaction tr_clone;
        $cast(tr_clone, tr.clone()); 
        if(checks_enable) begin
	  
            if(tr_clone.interrupt_flag)begin
                init_queues(65536,512,1);
                finish_flag_curr = 1'b0;
                finish_flag_ref = 1'b0;
                `uvm_info(get_type_name(), "SCOREBOARD - Interrupt = 1", UVM_MEDIUM)
            end
            // do actual checking here
            // ...
            // ++num_of_tr;
        end
    endfunction : write_interrupt

//*****************INIT_QUEUES**************************************
    function void init_queues(int size_p, int size_mv, int en_mv);
    
        for(int i=0;i<size_p;i++) begin
            curr_queue[0][i]= 0;
            ref_queue[0][i] = 0;
        
            curr_queue[1][i] = 0;
            ref_queue[1][i] = 0;
            if(i<size_mv && en_mv==1) begin
                mv_ref[i] = 0; //1d
                mv_bram_q[i] = 0;
            end
        end
    endfunction
//********************************************************************************
    function automatic int costSAD (const ref int curr_img[2][$], 
                                    const ref int ref_img[2][$],
                                        input int i_curr_in, 
                                        input int j_curr_in,
                                        input int i_ref_in, 
                                        input int j_ref_in);
        int err=0;
        int ref_addr;
        int curr_addr;
        for(int i=0;i<`MB_SIZE;i++) begin
            for(int j=0;j<`MB_SIZE;j++) begin
                curr_addr=256*(i+i_curr_in)+(j+j_curr_in);
                ref_addr=256*(i+i_ref_in)+(j+j_ref_in);
                err = err + abs(curr_img[0][curr_addr] - ref_img[0][ref_addr]);
            end
        end
        return err;
    endfunction
//********************************************************************************
    function int abs (input int x);
        int x_abs;
        if(x<0) begin
            x_abs=-(x);
            //$display ("x=%d x_abs=%d",x,x_abs);
        end
        else begin
            x_abs=x;
        end
        return x_abs;
    endfunction
//*******************************************************************************
    function automatic queue_of_int_m motionARPS (const ref int curr_img[2][$], 
                                                  const ref int ref_img[2][$]);  
        queue_of_int_m mv_q;
        int mbCount=0;
        int point;
        int x,y;  
        int ref_bl_jx,ref_bl_iy;

        int stepSize;
        int maxIndex;
        bit doneFlag;
        int vect_iy,vect_jx;
        
        int cost;
        int costs = 65535;
        static int SDSP_jx[5]={0,-1,0,1,0};
        static int SDSP_iy[5]={-1,0,0,0,1};
        int LDSP_jx[$];//={0,0,0,0,0,0};
        int LDSP_iy[$];//={0,0,0,0,0,0};
        //init
        for(int i=0;i<6;i++)begin
            LDSP_jx.push_back(0);
            LDSP_iy.push_back(0);
        end
        
        for(int i=0;i<`ROW-`MB_SIZE+1;i+=`MB_SIZE) begin
            for(int j=0;j<`COL-`MB_SIZE+1;j+=`MB_SIZE) begin
                //costs = 65535;
                x=j;
                y=i;
                costs = costSAD(curr_img,ref_img,i,j,i,j);
                if(j==0) begin 
                    stepSize=2;
                    maxIndex=5;
                    vect_iy=0;
                    vect_jx=0;
                end
                else begin
                    stepSize=`MAX2(abs(vect_iy),abs(vect_jx));
                    if(((abs(vect_iy)==stepSize) && (abs(vect_jx)==0)) || (abs(vect_jx)==stepSize) && (abs(vect_iy)==0)) begin
                        maxIndex=5;
                    end
                    else begin 
                        maxIndex=6;
                        LDSP_jx[5]=vect_jx;
                        LDSP_iy[5]=vect_iy;	
                    end
                end
                //LARGE DIAMOND SEARCH PATTERN
                LDSP_jx[0]=0;         LDSP_iy[0]=-stepSize;
                LDSP_jx[1]=-stepSize; LDSP_iy[1]=0;
                LDSP_jx[2]=0;         LDSP_iy[2]=0;
                LDSP_jx[3]=stepSize;  LDSP_iy[3]=0;
                LDSP_jx[4]=0;         LDSP_iy[4]=stepSize;
            
                //$display ("LDSP_jx=%p",LDSP_jx);
                cost=costs;
                point=2;
            
                for(int k=0;k<maxIndex;k++) begin 
                    ref_bl_iy=y+LDSP_iy[k];//ROW
                    ref_bl_jx=x+LDSP_jx[k];//COL
                    if( (ref_bl_iy<0) || 
                       ((ref_bl_iy+`MB_SIZE)>=`ROW) || 
                        (ref_bl_jx<0) || 
                       ((ref_bl_jx+`MB_SIZE)>=`COL)) begin 
                        continue;
                    end
                    if((k==2) || (stepSize==0)) begin
                        continue;
                    end
                    costs = costSAD (curr_img, ref_img, i, j, ref_bl_iy, ref_bl_jx);
                    if(costs<cost)begin
                        cost=costs;
                        point=k;
                    end 
                end//for
                x=x+LDSP_jx[point];
                y=y+LDSP_iy[point];
          
                costs=cost;
                doneFlag=1'b0;
                while(doneFlag==1'b0) begin
                    point = 2;
                    for(int k=0;k<5;k++) begin
                        ref_bl_iy = y + SDSP_iy[k];//ROW
                        ref_bl_jx = x + SDSP_jx[k];//COL
                        if( (ref_bl_iy<0) || 
                           ((ref_bl_iy+`MB_SIZE)>=`ROW) || 
                            (ref_bl_jx<0) || 
                           ((ref_bl_jx+`MB_SIZE)>=`COL)|| k==2) begin
                            continue;
                        end
                        else if((ref_bl_jx < (j-`P_SIZE))||
                                    (ref_bl_jx>(j+`P_SIZE)) || 
                                    (ref_bl_iy<(i-`P_SIZE)) || 
                                    (ref_bl_iy>(i+`P_SIZE)))begin
                            continue;
                        end
                        costs= costSAD(curr_img,ref_img,i,j,ref_bl_iy,ref_bl_jx);
                        if(costs<cost)begin
                            cost=costs;
                            point=k;
                        end
                    end //for
                    doneFlag = 1'b1;
                    if(point!=2) begin
                        doneFlag = 1'b0;
                        y=y+SDSP_iy[point];
                        x=x+SDSP_jx[point];	
                        costs=cost;
                    end
                end//while
                vect_jx = x-j;
                vect_iy = y-i;
                //$display("MV_REF[%d]=%d",mbCount,vect_jx);
                //$display("MV_REF[%d]=%d",mbCount+1,vect_iy);
                mbCount=mbCount+2;
                
                mv_q.push_back(x-j);
                mv_q.push_back(y-i);
                
            end//for j
        end//for i
        LDSP_jx.delete;
        LDSP_iy.delete;
        return mv_q;
    endfunction

endclass : ARPS_IP_scoreboard


`endif
