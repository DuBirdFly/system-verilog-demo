interface apb_interface #(
    parameter int ADDR_WIDTH = apb_pkg::APB_ADDR_WIDTH,
    parameter int DATA_WIDTH = apb_pkg::APB_DATA_WIDTH
)(
    input logic pclk,
    input logic presetn
);

    logic                       psel;
    logic                       penable;
    logic                       pwrite;
    logic [ADDR_WIDTH - 1:0]    paddr;
    logic [DATA_WIDTH - 1:0]    pwdata;
    logic [DATA_WIDTH - 1:0]    prdata;
    logic                       pready;
    logic                       pslverr;

    clocking drv @(posedge pclk);
        default input #1 output #1;

        output psel;
        output penable;
        output pwrite;
        output paddr;
        output pwdata;
        input  prdata;
        input  pready;
        input  pslverr;
    endclocking

endinterface
