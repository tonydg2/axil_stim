

`timescale 1ns / 1ps  // <time_unit>/<time_precision>
  // time_unit: measurement of delays / simulation time (#10 = 10<time_unit>)
  // time_precision: how delay values are rounded before being used in simulation (degree of accuracy of the time unit)



//-------------------------------------------------------------------------------------------------
//
//-------------------------------------------------------------------------------------------------

module sim_top_tb ;

  logic clk=0, rstn=0;
  logic ACLK ;

  always #2 clk = ~clk; // 250mhz period = 4ns, invert every 2ns

  initial begin
    rstn <= 0;
    #200;
    rstn <= 1;
  end

  assign ACLK = clk;

  logic [31:0]  S_AXI_araddr  =0  , S_AXI_0_araddr  =0  ;         
  logic [2:0]   S_AXI_arprot  =0  , S_AXI_0_arprot  =0  ;     
  logic         S_AXI_arready =0  , S_AXI_0_arready     ;// =0 ;     
  logic         S_AXI_arvalid =0  , S_AXI_0_arvalid =0  ;     
  logic [31:0]  S_AXI_awaddr  =0  , S_AXI_0_awaddr  =0  ;
  logic [2:0]   S_AXI_awprot  =0  , S_AXI_0_awprot  =0  ;     
  logic         S_AXI_awready =0  , S_AXI_0_awready =0  ;     
  logic         S_AXI_awvalid =0  , S_AXI_0_awvalid =0  ;     
  logic         S_AXI_bready  =0  , S_AXI_0_bready  =0  ;     
  logic [1:0]   S_AXI_bresp   =0  , S_AXI_0_bresp   =0  ;   
  logic         S_AXI_bvalid  =0  , S_AXI_0_bvalid  =0  ;     
  logic [31:0]  S_AXI_rdata   =0  , S_AXI_0_rdata   =0  ;   
  logic         S_AXI_rready  =0  , S_AXI_0_rready  =0  ;     
  logic [1:0]   S_AXI_rresp   =0  , S_AXI_0_rresp   =0  ;   
  logic         S_AXI_rvalid  =0  , S_AXI_0_rvalid  =0  ;     
  logic [31:0]  S_AXI_wdata   =0  , S_AXI_0_wdata   =0  ;   
  logic         S_AXI_wready  =0  , S_AXI_0_wready  =0  ;     
  logic [3:0]   S_AXI_wstrb   ='1 , S_AXI_0_wstrb   ='1 ;   
  logic         S_AXI_wvalid  =0  , S_AXI_0_wvalid  =0  ;     


  sim_top_wrapper  sim_top_wrapper_i (
    .S_AXI_araddr    (S_AXI_araddr ),       
    .S_AXI_arprot    (S_AXI_arprot ),       
    .S_AXI_arready   (S_AXI_arready),      
    .S_AXI_arvalid   (S_AXI_arvalid),      
    .S_AXI_awaddr    (S_AXI_awaddr ),      
    .S_AXI_awprot    (S_AXI_awprot ),      
    .S_AXI_awready   (S_AXI_awready),      
    .S_AXI_awvalid   (S_AXI_awvalid),      
    .S_AXI_bready    (S_AXI_bready ),      
    .S_AXI_bresp     (S_AXI_bresp  ),      
    .S_AXI_bvalid    (S_AXI_bvalid ),      
    .S_AXI_rdata     (S_AXI_rdata  ),      
    .S_AXI_rready    (S_AXI_rready ),      
    .S_AXI_rresp     (S_AXI_rresp  ),      
    .S_AXI_rvalid    (S_AXI_rvalid ),      
    .S_AXI_wdata     (S_AXI_wdata  ),      
    .S_AXI_wready    (S_AXI_wready ),      
    .S_AXI_wstrb     (S_AXI_wstrb  ),      
    .S_AXI_wvalid    (S_AXI_wvalid ),      

    .S_AXI_0_araddr  (S_AXI_0_araddr ),       
    .S_AXI_0_arprot  (S_AXI_0_arprot ),       
    .S_AXI_0_arready (S_AXI_0_arready),      
    .S_AXI_0_arvalid (S_AXI_0_arvalid),      
    .S_AXI_0_awaddr  (S_AXI_0_awaddr ),      
    .S_AXI_0_awprot  (S_AXI_0_awprot ),      
    .S_AXI_0_awready (S_AXI_0_awready),      
    .S_AXI_0_awvalid (S_AXI_0_awvalid),      
    .S_AXI_0_bready  (S_AXI_0_bready ),      
    .S_AXI_0_bresp   (S_AXI_0_bresp  ),      
    .S_AXI_0_bvalid  (S_AXI_0_bvalid ),      
    .S_AXI_0_rdata   (S_AXI_0_rdata  ),      
    .S_AXI_0_rready  (S_AXI_0_rready ),      
    .S_AXI_0_rresp   (S_AXI_0_rresp  ),      
    .S_AXI_0_rvalid  (S_AXI_0_rvalid ),      
    .S_AXI_0_wdata   (S_AXI_0_wdata  ),      
    .S_AXI_0_wready  (S_AXI_0_wready ),      
    .S_AXI_0_wstrb   (S_AXI_0_wstrb  ),      
    .S_AXI_0_wvalid  (S_AXI_0_wvalid ),      

    .aclk   (clk  ),
    .arstn  (rstn )
  );


  axil_stim  # (
    .DATA_WIDTH (32),
    .ADDR_WIDTH (32)
  ) axil_stim_i (
    .M_AXI_aclk       (clk),
    .M_AXI_aresetn    (rstn),
    .M_AXI_araddr     (S_AXI_0_araddr ),       
    .M_AXI_arprot     (S_AXI_0_arprot ),       
    .M_AXI_arready    (S_AXI_0_arready),      
    .M_AXI_arvalid    (S_AXI_0_arvalid),      
    .M_AXI_awaddr     (S_AXI_0_awaddr ),      
    .M_AXI_awprot     (S_AXI_0_awprot ),      
    .M_AXI_awready    (S_AXI_0_awready),      
    .M_AXI_awvalid    (S_AXI_0_awvalid),      
    .M_AXI_bready     (S_AXI_0_bready ),      
    .M_AXI_bresp      (S_AXI_0_bresp  ),      
    .M_AXI_bvalid     (S_AXI_0_bvalid ),      
    .M_AXI_rdata      (S_AXI_0_rdata  ),      
    .M_AXI_rready     (S_AXI_0_rready ),      
    .M_AXI_rresp      (S_AXI_0_rresp  ),      
    .M_AXI_rvalid     (S_AXI_0_rvalid ),      
    .M_AXI_wdata      (S_AXI_0_wdata  ),      
    .M_AXI_wready     (S_AXI_0_wready ),      
    .M_AXI_wstrb      (S_AXI_0_wstrb  ),      
    .M_AXI_wvalid     (S_AXI_0_wvalid )
  );

  axil_stim2  # (
    .DATA_WIDTH (32),
    .ADDR_WIDTH (32)
  ) axil_stim2_i (
    .M_AXI_aclk       (clk),
    .M_AXI_aresetn    (rstn),
    .M_AXI_araddr     (S_AXI_araddr ),       
    .M_AXI_arprot     (S_AXI_arprot ),       
    .M_AXI_arready    (S_AXI_arready),      
    .M_AXI_arvalid    (S_AXI_arvalid),      
    .M_AXI_awaddr     (S_AXI_awaddr ),      
    .M_AXI_awprot     (S_AXI_awprot ),      
    .M_AXI_awready    (S_AXI_awready),      
    .M_AXI_awvalid    (S_AXI_awvalid),      
    .M_AXI_bready     (S_AXI_bready ),      
    .M_AXI_bresp      (S_AXI_bresp  ),      
    .M_AXI_bvalid     (S_AXI_bvalid ),      
    .M_AXI_rdata      (S_AXI_rdata  ),      
    .M_AXI_rready     (S_AXI_rready ),      
    .M_AXI_rresp      (S_AXI_rresp  ),      
    .M_AXI_rvalid     (S_AXI_rvalid ),      
    .M_AXI_wdata      (S_AXI_wdata  ),      
    .M_AXI_wready     (S_AXI_wready ),      
    .M_AXI_wstrb      (S_AXI_wstrb  ),      
    .M_AXI_wvalid     (S_AXI_wvalid )
  );




endmodule