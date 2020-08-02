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
typedef int queue_of_int[$];

class ARPS_IP_scoreboard extends uvm_scoreboard;
   

   // control fileds
   bit checks_enable = 1;
   bit coverage_enable = 1;
   
   queue_of_int curr_queue;
   queue_of_int ref_queue;
   queue_of_int mv_ref;
   
   int cnt_c = 0;
   int cnt_r = 0;
   
   bit done_write_frames = 1'b0;
   bit done_mv_flag = 1'b0;
   
   int num_of_mv = 0;

   int           num_of_assertions = 0;   
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
      `uvm_info(get_type_name(), $sformatf("Number of mismatch assertions for DUT is: %0d ", num_of_assertions), UVM_NONE);
      
   endfunction : report_phase

 
   function write_axil (ARPS_IP_axil_transaction tr);
      ARPS_IP_axil_transaction tr_clone;
      $cast(tr_clone, tr.clone()); 
      if(checks_enable) begin
	    if(tr_clone.addr==0 && tr_clone.wdata==1) begin
            //start ref model
//            mv_ref = motionARPS(curr_queue,ref_queue);// MV by ref model 
        end
         // do actual checking here
         // ...
         // ++num_of_tr;
      end
   endfunction : write_axil
   

   function write_bram_curr (ARPS_IP_bram_curr_transaction tr);  
      ARPS_IP_bram_curr_transaction tr_clone;
      $cast(tr_clone, tr.clone()); 
	  
      if(checks_enable) begin
	  
		//`uvm_info(get_type_name(),$sformatf("SCOREBOARD QUEUE 1"),UVM_HIGH)
		
		
//		if(tr_clone.address_curr <= 32'h0000FFFF) begin
            if(curr_queue.size() < 65536) begin
             curr_queue.push_back((tr_clone.data_curr_frame >> 24) & 32'h000000FF);
             curr_queue.push_back((tr_clone.data_curr_frame >> 16) & 32'h000000FF);
             curr_queue.push_back((tr_clone.data_curr_frame >>  8) & 32'h000000FF);
             curr_queue.push_back((tr_clone.data_curr_frame >>  0) & 32'h000000FF);
			 $display("currp[%d]=%x", cnt_c, curr_queue[cnt_c]);
			 cnt_c++;
			 $display("currp[%d]=%x", cnt_c, curr_queue[cnt_c]);
			 cnt_c++;
			 $display("currp[%d]=%x", cnt_c, curr_queue[cnt_c]);
			 cnt_c++;
			 $display("currp[%d]=%x", cnt_c, curr_queue[cnt_c]);
			 cnt_c++;
            end
//		end
		
		
		//curr_queue_1.push_back(tr.data_curr_frame);
		//if (curr_queue[10]==curr_queue_1[10])begin
		//`uvm_error(get_type_name(), $sformatf("INVALID CAST"))
		//end
		//`uvm_info(get_type_name(), $sformatf("SCOREBOARD QUEUE 2"),UVM_HIGH)
		//for (int i=0; i<)
		//`uvm_info(get_type_name(), $sformatf("SCOREBOARD QUEUE 3    %p\n", curr_queue),UVM_HIGH)
		//`uvm_info(get_type_name(),$sformatf("SCOREBOARD QUEUE \n"),UVM_HIGH)
         // do actual checking here
         // ...
         // ++num_of_tr;
      end
   endfunction : write_bram_curr 
   
   function write_bram_ref (ARPS_IP_bram_ref_transaction tr);
      ARPS_IP_bram_ref_transaction tr_clone;
      $cast(tr_clone, tr.clone()); 
      if(checks_enable) begin
	  
//		if(tr_clone.address_ref <= 32'h0000FFFF) begin
            if(ref_queue.size() < 65536) begin
             done_write_frames = 1'b0;
             ref_queue.push_back((tr_clone.data_ref_frame >> 24) & 32'h000000FF); 
             ref_queue.push_back((tr_clone.data_ref_frame >> 16) & 32'h000000FF);
             ref_queue.push_back((tr_clone.data_ref_frame >>  8) & 32'h000000FF);
             ref_queue.push_back((tr_clone.data_ref_frame >>  0) & 32'h000000FF);
			 $display("refp[%d]=%x", cnt_r, ref_queue[cnt_r]);/*[SS] BUG: changed refp name and cnt_r name*/
			 cnt_r++;
			 $display("refp[%d]=%x", cnt_r, ref_queue[cnt_r]);
			 cnt_r++;
			 $display("refp[%d]=%x", cnt_r, ref_queue[cnt_r]);
			 cnt_r++;
			 $display("refp[%d]=%x", cnt_r, ref_queue[cnt_r]);
			 cnt_r++;
			end
            
//		end
		
		if(ref_queue.size() == 65536 && curr_queue.size() == 65536) begin
			mv_ref = motionARPS(curr_queue,ref_queue);// MV by ref model
		end
		
         // do actual checking here
         // ...
         // ++num_of_tr;
      end
   endfunction : write_bram_ref 
   
   
   function write_bram_mv (ARPS_IP_bram_mv_transaction tr);
      ARPS_IP_bram_mv_transaction tr_clone;
      $cast(tr_clone, tr.clone()); 
     // arps_ip();
      if(checks_enable) begin
	    assert(tr_clone.data_mv_frame == mv_ref[num_of_mv++])
        else begin
            `uvm_error(get_type_name(), $sformatf("pixel mismatch reference modele[%d]: %h \t deskew[%d]: %h",
                  num_of_mv, tr_clone.data_mv_frame, num_of_mv,mv_ref[num_of_mv] ));
        end
         // do actual checking here
         // ...
         // ++num_of_tr;
      end
   endfunction : write_bram_mv 



   //write_interrupt function is not needed 
   function write_interrupt (ARPS_IP_interrupt_transaction tr);
      ARPS_IP_interrupt_transaction tr_clone;
      $cast(tr_clone, tr.clone()); 
      if(checks_enable) begin
         // do actual checking here
         // ...
         // ++num_of_tr;
      end
   endfunction : write_interrupt
/*   
 function void arps_ip();

    
    int curr_img [$];
    int ref_img [$];
    //int mv_q [$];//queue for motion vectors
  	int f_curr;//file descriptors
    int f_ref;
    int curr_data;
    int ref_data;
    queue_of_int mv;
	
	for(int i=0; i< curr_queue.size(); i++)begin
		curr_img[i] = curr_queue[i];
		ref_img[i] = ref_queue[i];
	end
	
	
/*    
    f_curr = $fopen ("C:/Users/Nemanja/Desktop/Working/Verification_ARPS_IP_project/images_for_arps/sample51.txt", "r");
    if (f_curr) $display("File was opened successfully : %0d", f_curr);
    else        $display("File was NOT opened successfully : %0d", f_curr);
    
    f_ref = $fopen ("C:/Users/Nemanja/Desktop/Working/Verification_ARPS_IP_project/images_for_arps/sample50.txt", "r");
    if (f_ref)  $display("File was opened successfully : %0d", f_ref);
    else        $display("File was NOT opened successfully : %0d", f_ref);
    //init queue-s
    for(int i=0;i<65536;i++) begin
        curr_img.push_back(0);
        ref_img.push_back(0);
    end 
    
    for(int i=0;i<16384;i++) begin
        $fscanf (f_curr, "0x%x\n",curr_data);
        curr_img[4*i]=(curr_data>>24) & 32'h000000ff;
        curr_img[4*i+1]=(curr_data>>16) & 32'h000000ff;
        curr_img[4*i+2]=(curr_data>>8) & 32'h000000ff;
        curr_img[4*i+3]=(curr_data>>0) & 32'h000000ff;
      
        $fscanf (f_ref, "0x%x\n",ref_data);
        ref_img[4*i]=(ref_data>>24) & 32'h000000ff;
        ref_img[4*i+1]=(ref_data>>16) & 32'h000000ff;
        ref_img[4*i+2]=(ref_data>>8) & 32'h000000ff;
        ref_img[4*i+3]=(ref_data>>0) & 32'h000000ff;
    end
    
    $fclose(f_curr);  
    $fclose(f_ref);
*/    
/*    $display ("Starting");
    
    mv=motionARPS(curr_img,ref_img);
  	for(int i=0;i<512;i++) begin
        $display("mv[%d]=%d",i,mv[i]);
    end
    
//end // initial
//endmodule
endfunction */

 function automatic int costSAD (const ref int curr_img[$], 
                        const ref int ref_img[$],
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
        err = err + abs(curr_img[curr_addr] - ref_img[ref_addr]);
      end
    end
    return err;
  endfunction

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

  function automatic queue_of_int motionARPS (const ref int curr_img[$], 
                                    const ref int ref_img[$]);  
    queue_of_int mv_q;
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
            mv_q.push_back(x-j);
            mv_q.push_back(y-i);
            //mbCount=mbCount+2;
        end//for j
    end//for i
   
    return mv_q;
endfunction

endclass : ARPS_IP_scoreboard


`endif
