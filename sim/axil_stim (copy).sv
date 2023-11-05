
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

  parameter [19:0]  MOD2 = 0;
  parameter [19:0]  MOD3 = 20'h00001;

  initial begin 
    #600;
    //RD({MOD2,12'h000});
    //RD({MOD3,12'h000});
    //WR({MOD2,12'h010}, 32'hB00BFEED);
    //WR({MOD3,12'h010}, 32'h00000011);
    //WR({MOD2,12'h014}, 32'hFF000077);
    //WR({MOD3,12'h014}, 32'h30000044);
    //RD({MOD2,12'h010});
    //RD({MOD3,12'h010});
    //RD({MOD2,12'h014});
    //RD({MOD3,12'h014});

    RD(32'h00000000);
    RD(32'h00001000);
    WR(32'h00000010, 32'hB00BFEED);
    WR(32'h00001010, 32'h00000011);
    WR(32'h00000014, 32'hFF000077);
    WR(32'h00001014, 32'h30000044);
    RD(32'h00000010);
    RD(32'h00001010);
    RD(32'h00000014);
    RD(32'h00001014);



    //RD(32'h00000004);
    //RD(32'h00000008);
    //RD(32'h0000000C);

    //RD(32'h00000010);#100;
    //WR(32'h00000010, 32'habbff666);#100;
    //RD(32'h00000010);#100;
    //WR(32'h00000014, 32'h55771234);#100;
    //RD(32'h00000014);#100;

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
  logic [DATA_WIDTH-1:0]      wdata=0   ;
  logic                       wvalid=0  ;

  logic                       waddr_en = 0;
  logic [ADDR_WIDTH-1:0]      waddr;
  logic                       wdata_en = 0;
  logic [DATA_WIDTH-1:0]      wdata_i;
  logic                       wresp_en = 0;
  logic [ADDR_WIDTH-1:0]      raddr;
  logic                       raddr_en = 0;
  logic                       rdata_en = 0;

  logic ACLK;
  assign ACLK = M_AXI_aclk;


  assign M_AXI_awaddr   = awaddr  ;
  assign M_AXI_awprot   = 0       ;
  assign M_AXI_awvalid  = awvalid ;
  assign M_AXI_wdata	  = wdata	  ;
  assign M_AXI_wstrb	  = '1	    ;
  assign M_AXI_wvalid   = wvalid  ;
  assign M_AXI_bready   = bready  ;
  assign M_AXI_araddr   = araddr  ;
  assign M_AXI_arprot   = 0       ;
  assign M_AXI_arvalid  = arvalid ;
  assign M_AXI_rready   = rready  ;

//-------------------------------------------------------------------------------------------------
// Read / Write tasks
//-------------------------------------------------------------------------------------------------

  task RD;
    input  [31:0] addr;
    reg    [31:0] data;
    begin

      @(negedge ACLK);
      raddr_en  = 1;
      raddr     = addr;
      
      // data follows address immediately
      rdata_en  = 1;

      @(negedge ACLK);
      raddr_en  = 0;
      raddr     = 0;

      while (M_AXI_rvalid == 1'b0) 
        @(negedge ACLK);

      data = M_AXI_rdata;

      @(negedge ACLK);
      rdata_en  = 0;  

      $display("%m - Addr %h: %h", addr, data);
      @(negedge ACLK);@(negedge ACLK);//delay
    end
  endtask

  // 
  always @ (posedge ACLK) begin : axi_read_ch
    // raddr chan
    if (raddr_en) begin
      araddr  <= raddr;
      arvalid <= 1;
    end else if (M_AXI_arready) begin
      araddr  <= 0;
      arvalid <= 0;
    end
    // rdata chan
    if (!rdata_en)
      rready <= 0;
    else if (rdata_en && M_AXI_rvalid) 
      rready <= 1;
    else if (rdata_en && M_AXI_rready)
      rready <= 0;
  end


  task WR;
    input [31:0] addr;
    input [31:0] data;
    begin
    // address and data on same cycle 
      @(negedge ACLK);
      waddr_en = 1;
      waddr = addr;
      wdata_en = 1;
      wdata_i = data;
      @(negedge ACLK);
      waddr_en = 0;
      waddr = 0;
      wdata_en = 0;
      wdata_i = 0;
    // response
      wresp_en = 1;
      @(negedge ACLK);
      wresp_en = 0;
      @(negedge ACLK);@(negedge ACLK);//delay
    end 
  endtask

  // 
  always @ (posedge ACLK) begin : axi_write_ch
    // waddr chan
    if (waddr_en) begin
      awaddr  <= waddr;
      awvalid <= 1;
    end else if (M_AXI_awready) begin
      awaddr  <= 0;
      awvalid <= 0;
    end
    // wdata chan
    if (wdata_en) begin
      wdata   <= wdata_i;
      wvalid  <= 1;
    end else if (M_AXI_wready) begin
      wdata   <= 0;
      wvalid  <= 0;
    end 
    // wresp chan
    if (wresp_en)
      bready  <= 1;
    else if (M_AXI_bvalid)
      bready  <= 0;
  end 

endmodule