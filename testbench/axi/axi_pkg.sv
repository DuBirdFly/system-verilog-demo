package axi_pkg;

    parameter int AXI_ID_WIDTH       = 4;
    parameter int AXI_ADDR_WIDTH     = 16;
    parameter int AXI_LEN_WIDTH      = 8;   // 固定宽度
    parameter int AXI_SIZE_WIDTH     = 3;   // 固定宽度
    parameter int AXI_BURST_WIDTH    = 2;   // 固定宽度

    parameter int AXI_DATA_WIDTH     = 128;
    parameter int AXI_WSTRB_WIDTH    = AXI_DATA_WIDTH / 8;
    
    parameter int AXI_RESP_WIDTH     = 2;   // 固定宽度

endpackage