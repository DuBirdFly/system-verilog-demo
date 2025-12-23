`timescale 1ns/1ps

module clk_rst_gen #(
    parameter APB_FREQ = 50, // 50MHz
    parameter AXI_FREQ = 100 // 100MHz
)(
    output logic pclk,
    output logic presetn,

    output logic aclk,
    output logic aresetn
);

    localparam PERIOD_APB = 1_000 / APB_FREQ;
    localparam PERIOD_AXI = 1_000 / AXI_FREQ;

    initial begin
        pclk = 0;
        forever #(PERIOD_APB / 2) pclk = ~pclk;
    end

    initial begin
        aclk = 0;
        forever #(PERIOD_AXI / 2) aclk = ~aclk;
    end

    initial begin
        presetn = 0;
        repeat(2) @(posedge pclk);
        #1 presetn = 1;
    end

    initial begin
        aresetn = 0;
        repeat(2) @(posedge aclk);
        #1 aresetn = 1;
    end

endmodule