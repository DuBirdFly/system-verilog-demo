`timescale 1ns/1ps

`default_nettype none
module top;

    import uvm_pkg::*;
    import test_pkg::*;

    initial begin
        `ifdef DUMP_VCD
            $display("Dumping VCD waveforms");
            $dumpfile("output/wave/out.vcd");
            $dumpvars(0);
        `endif

        `ifdef DUMP_FSDB
            $display("Dumping FSDB waveforms");
            $fsdbAutoSwitchDumpfile(1024, "output/wave/novas.fsdb", 2);    // 1024 MB
            $fsdbDumpvars(0, top, "+mda");
            // $fsdbDumpvarsToFile("dump_information.list");
        `endif
    end

    logic pclk;
    logic presetn;

    logic aclk;
    logic aresetn;

    clk_rst_gen #(
        .APB_FREQ       ( 20            ),
        .AXI_FREQ       ( 100           )
    )u_clk_rst_gen (
        .pclk           ( pclk          ),
        .presetn        ( presetn       ),

        .aclk           ( aclk          ),
        .aresetn        ( aresetn       )
    );

    apb_interface apb_if(
        .pclk           ( pclk          ),
        .presetn        ( presetn       )
    );

    axi_interface axi_if(
        .aclk           ( aclk          ),
        .aresetn        ( aresetn       )
    );

    wrapper_top u_wrapper_top (
        .apb            ( apb_if        ),
        .axi            ( axi_if        )
    );

    initial begin: config4uvm
        uvm_config_db#(virtual apb_interface)::set(null, "uvm_test_top", "apb", apb_if);
        uvm_config_db#(virtual axi_interface)::set(null, "uvm_test_top", "axi", axi_if);
        run_test();
    end

endmodule
`default_nettype wire
