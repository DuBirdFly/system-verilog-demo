`timescale 1ns / 1ps

interface apb_interface (
    input logic pclk,
    input logic presetn
);

    logic                                   psel;
    logic                                   penable;
    logic                                   pwrite;
    logic [apb_pkg::APB_ADDR_WIDTH - 1:0]    paddr;
    logic [apb_pkg::APB_DATA_WIDTH - 1:0]    pwdata;
    logic [apb_pkg::APB_DATA_WIDTH - 1:0]    prdata;
    logic                                   pready;
    logic                                   pslverr;

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
