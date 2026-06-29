module wrapper_top (
    interface apb,      // or apb_interface apb
    interface axi       // or axi_interface axi
);

    timeunit 1ns/1ps;

    apb_ram #(
        .PADDR_WIDTH    ( 8             )
    ) u_apb_ram (
        .pclk           ( apb.pclk      ),
        .presetn        ( apb.presetn   ),
        .psel           ( apb.psel      ),
        .penable        ( apb.penable   ),
        .pwrite         ( apb.pwrite    ),
        .paddr          ( apb.paddr     ),
        .pwdata         ( apb.pwdata    ),
        .prdata         ( apb.prdata    ),
        .pready         ( apb.pready    ),
        .pslverr        ( apb.pslverr   )
    );

    axi_ram #(
        .DATA_WIDTH     ( 128           ),
        .ADDR_WIDTH     ( 16            ),
        .ID_WIDTH       ( 4             )
    ) u_axi_ram (
        .clk            ( axi.aclk      ),
        .rst            ( ~axi.aresetn  ),

        .s_axi_awid     ( axi.awid      ),
        .s_axi_awaddr   ( axi.awaddr    ),
        .s_axi_awlen    ( axi.awlen     ),
        .s_axi_awsize   ( axi.awsize    ),
        .s_axi_awburst  ( axi.awburst   ),
        .s_axi_awvalid  ( axi.awvalid   ),
        .s_axi_awready  ( axi.awready   ),

        .s_axi_wdata    ( axi.wdata     ),
        .s_axi_wstrb    ( axi.wstrb     ),
        .s_axi_wlast    ( axi.wlast     ),
        .s_axi_wvalid   ( axi.wvalid    ),
        .s_axi_wready   ( axi.wready    ),

        .s_axi_bid      ( axi.bid       ),
        .s_axi_bresp    ( axi.bresp     ),
        .s_axi_bvalid   ( axi.bvalid    ),
        .s_axi_bready   ( axi.bready    ),

        .s_axi_arid     ( axi.arid      ),
        .s_axi_araddr   ( axi.araddr    ),
        .s_axi_arlen    ( axi.arlen     ),
        .s_axi_arsize   ( axi.arsize    ),
        .s_axi_arburst  ( axi.arburst   ),
        .s_axi_arvalid  ( axi.arvalid   ),
        .s_axi_arready  ( axi.arready   ),

        .s_axi_rid      ( axi.rid       ),
        .s_axi_rdata    ( axi.rdata     ),
        .s_axi_rresp    ( axi.rresp     ),
        .s_axi_rlast    ( axi.rlast     ),
        .s_axi_rvalid   ( axi.rvalid    ),
        .s_axi_rready   ( axi.rready    )
    );

endmodule