class TestBase extends uvm_test;

    `uvm_component_utils(TestBase)

    virtual apb_interface vif_apb;
    virtual axi_interface vif_axi;

    extern         function      new(string name = "testBase", uvm_component parent);

    extern virtual function void build_phase(uvm_phase phase);
    extern virtual function void start_of_simulation_phase(uvm_phase phase);
    extern virtual task          run_phase(uvm_phase phase);

endclass

function TestBase::new(string name = "testBase", uvm_component parent);
    super.new(name, parent);
endfunction

function void TestBase::build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db#(virtual apb_interface)::get(this, "", "apb", vif_apb))
        `uvm_fatal("NOVIF", "No Interface Specified")

    if (!uvm_config_db#(virtual axi_interface)::get(this, "", "axi", vif_axi))
        `uvm_fatal("NOVIF", "No Interface Specified")

endfunction

function void TestBase::start_of_simulation_phase(uvm_phase phase);
    uvm_top.print_topology();
    uvm_pkg::uvm_factory::get().print();
endfunction

task TestBase::run_phase(uvm_phase phase);
    phase.raise_objection(this);
    uvm_top.set_timeout(100us, 0);
    $timeformat(-9, 0, "ns", 6);
    $display("Running test...");
    #1us;
    $display("Test completed.");
    phase.drop_objection(this);
endtask
