
module axil_stim #
	(
		parameter integer DATA_WIDTH	= 32,
		parameter integer ADDR_WIDTH	= 32
	)
	(
		input   										    M_AXI_aclk		,
		input   										    M_AXI_aresetn	,
		output [ADDR_WIDTH-1 : 0] 	    M_AXI_awaddr	,
		output [2 : 0] 							    M_AXI_awprot	,
		output  										    M_AXI_awvalid	,
		input   										    M_AXI_awready	,
		output [DATA_WIDTH-1 : 0] 	    M_AXI_wdata		,
		output [(DATA_WIDTH/8)-1 : 0]   M_AXI_wstrb		,
		output  										    M_AXI_wvalid	,
		input   										    M_AXI_wready	,
		input  [1 : 0] 							    M_AXI_bresp		,
		input   										    M_AXI_bvalid	,
		output  										    M_AXI_bready	,
		output [ADDR_WIDTH-1 : 0] 	    M_AXI_araddr	,
		output [2 : 0] 							    M_AXI_arprot	,
		output  										    M_AXI_arvalid	,
		input   										    M_AXI_arready	,
		input  [DATA_WIDTH-1 : 0] 	    M_AXI_rdata		,
		input  [1 : 0] 							    M_AXI_rresp		,
		input   										    M_AXI_rvalid	,
		output  										    M_AXI_rready
	);

//-------------------------------------------------------------------------------------------------
// STIMULUS: Read/Write task control
//-------------------------------------------------------------------------------------------------

  initial begin 
    #600;   
    
    WR(32'h00000010, 32'hDEADBEEF); //reg4
    WR(32'h00001010, 32'hDEAD8888); //reg4
    RD(32'h00000010);
    WR(32'h00000014, 32'hBEEFCAFE); //reg5
    WR(32'h00001014, 32'hBEEF8888); //reg5
    RD(32'h00000014);
    WR(32'h00000018, 32'hA6660666); //reg6
    WR(32'h00001018, 32'hA6660888); //reg6
    RD(32'h00000018);
    
    RD(32'h00000010); //reg4
    RD(32'h00000014); //reg5
    RD(32'h00000018); //reg6
    RD(32'h00001010); //reg4
    RD(32'h00001014); //reg5
    RD(32'h00001018); //reg6
    
  end 

//-------------------------------------------------------------------------------------------------
// signals
//-------------------------------------------------------------------------------------------------

  logic [ADDR_WIDTH-1:0]      araddr=0  ;
  logic                       arvalid=0 ;
  logic [ADDR_WIDTH-1:0]      awaddr=0  ;
  logic                       awvalid=0 ;
  logic                       bready=0  ;
  logic                       rready=0  ;
  logic [DATA_WIDTH-1:0]      wdata=0, rdata   ;
  logic                       wvalid=0  ;
  logic                       bvalid    ;

  logic [2:0] awprot, arprot;
  logic [(DATA_WIDTH/8)-1 : 0]  wstrb;

  logic  clk;
  assign clk = M_AXI_aclk;

  assign M_AXI_awaddr   = awaddr  ;
  assign M_AXI_awprot   = awprot  ;
  assign M_AXI_awvalid  = awvalid ;
  assign M_AXI_wdata	  = wdata	  ;
  assign M_AXI_wstrb	  = wstrb	  ;
  assign M_AXI_wvalid   = wvalid  ;
  assign M_AXI_bready   = bready  ;
  assign M_AXI_araddr   = araddr  ;
  assign M_AXI_arprot   = arprot  ;
  assign M_AXI_arvalid  = arvalid ;
  assign M_AXI_rready   = rready  ;
  assign bvalid         = M_AXI_bvalid;
  assign rdata	        = M_AXI_rdata ;

  logic awready, wready, arready, rvalid;
  assign awready  = M_AXI_awready ;
  assign wready   = M_AXI_wready  ;
  assign arready  = M_AXI_arready ;     
  assign rvalid   = M_AXI_rvalid  ; 


//-------------------------------------------------------------------------------------------------
/* NOTE: 
  "=" is blocking,      in an always block, line of code executes after previous, squentially
  "<=" is non-blocking, in an always block, every line executed in parallel.
*/
//-------------------------------------------------------------------------------------------------

//-------------------------------------------------------------------------------------------------
// Read
//-------------------------------------------------------------------------------------------------

// ADDRESS    // DATA
//  araddr	  //  rdata		    
//  arprot	  //  rresp		    
//  arvalid	  //  rvalid	    
//  arready	  //  rready    


  task RD;
    input  [31:0] addr;
    reg    [31:0] data;
    begin

      @(posedge clk);
      araddr <= addr; arprot <= '0; arvalid <= 1;
      rready <= 1;

      fork
        begin 
          wait(arready == 1);
          @(posedge clk);
          araddr <= '0; arprot <= '0; arvalid <= 0;
        end 

        begin 
          wait(rvalid == 1); //rready <= 1;
          @(posedge clk);
          data = rdata; rready <= 0;
        end
      join
    
    //rready <= 0;
    $display("%m - Addr %h: %h", addr, data);
    end
  endtask


//-------------------------------------------------------------------------------------------------
// Write 
//-------------------------------------------------------------------------------------------------

// ADDRESS      // DATA       // RESPONSE       
//  awaddr	    //  wdata	    //  bresp		     
//  awprot	    //  wstrb	    //  bvalid	     
//  awvalid	    //  wvalid    //  bready	     
//  awready	    //  wready  

  task WR;
    input [31:0] addr;
    input [31:0] data;
    begin

      @(posedge clk);
      awaddr <= addr; awprot <= '0; awvalid <= 1;
      wdata  <= data; wstrb  <= '1; wvalid  <= 1;

      fork // start all processes (begin/end statements) parallel, and wait for all to complete
        begin
          wait(awready == 1);
          @(posedge clk);
          awaddr <= '0; awprot <= '0; awvalid <= 0;
        end

        begin
          wait(wready == 1);
          @(posedge clk);
          wdata  <= '0; wstrb  <= '0; wvalid  <= 0;
        end
      join
      
      bready <= '1;
      wait(bvalid == 1);
      @(posedge clk);
      bready <= '0;
    
    $display("%m - Addr %h: %h", addr, data);
    end
  endtask
  

endmodule