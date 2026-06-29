interface axi_interface (
    input logic aclk,
    input logic aresetn
);

    timeunit 1ns/1ps;

    logic [axi_pkg::AXI_ID_WIDTH-1:0]       awid;
    logic [axi_pkg::AXI_ADDR_WIDTH-1:0]     awaddr;
    logic [axi_pkg::AXI_LEN_WIDTH-1:0]      awlen;
    logic [axi_pkg::AXI_SIZE_WIDTH-1:0]     awsize;
    logic [axi_pkg::AXI_BURST_WIDTH-1:0]    awburst;
    logic                                   awvalid;
    logic                                   awready;

    logic [axi_pkg::AXI_DATA_WIDTH-1:0]     wdata;
    logic [axi_pkg::AXI_WSTRB_WIDTH-1:0]    wstrb;
    logic                                   wlast;
    logic                                   wvalid;
    logic                                   wready;

    logic [axi_pkg::AXI_ID_WIDTH-1:0]       bid;
    logic [axi_pkg::AXI_RESP_WIDTH-1:0]     bresp;
    logic                                   bvalid;
    logic                                   bready;

    logic [axi_pkg::AXI_ID_WIDTH-1:0]       arid;
    logic [axi_pkg::AXI_ADDR_WIDTH-1:0]     araddr;
    logic [axi_pkg::AXI_LEN_WIDTH-1:0]      arlen;
    logic [axi_pkg::AXI_SIZE_WIDTH-1:0]     arsize;
    logic [axi_pkg::AXI_BURST_WIDTH-1:0]    arburst;
    logic                                   arvalid;
    logic                                   arready;

    logic [axi_pkg::AXI_ID_WIDTH-1:0]       rid;
    logic [axi_pkg::AXI_RESP_WIDTH-1:0]     rresp;
    logic [axi_pkg::AXI_DATA_WIDTH-1:0]     rdata;
    logic                                   rlast;
    logic                                   rvalid;
    logic                                   rready;

    clocking drv @(posedge aclk);
        default input #1 output #1;

        output awid, awaddr, awlen, awsize, awburst;
        output awvalid;
        input  awready;

        output wdata, wstrb, wlast;
        output wvalid;
        input  wready;

        input  bid, bresp;
        input  bvalid;
        output bready;

        output arid, araddr, arlen, arsize, arburst;
        output arvalid;
        input  arready;

        input  rid, rdata, rresp, rlast;
        input  rvalid;
        output rready;
    endclocking

    clocking mon @(posedge aclk);
        default input #1 output #1;

        input  awid, awaddr, awlen, awsize, awburst;
        input  awvalid;
        input  awready;

        input  wdata, wstrb, wlast;
        input  wvalid;
        input  wready;

        input  bid, bresp;
        input  bvalid;
        input  bready;

        input  arid, araddr, arlen, arsize, arburst;
        input  arvalid;
        input  arready;

        input  rid, rdata, rresp, rlast;
        input  rvalid;
        input  rready;
    endclocking

endinterface
