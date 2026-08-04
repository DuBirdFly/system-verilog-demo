class Testcase_Utils extends TestBase;

    `uvm_component_utils(Testcase_Utils)

    extern function new(string name = "Testcase_Utils", uvm_component parent);
    extern virtual task run_phase(uvm_phase phase);
    extern virtual task test_task();

endclass

function Testcase_Utils::new(string name = "Testcase_Utils", uvm_component parent);
    super.new(name, parent);
endfunction

task Testcase_Utils::run_phase(uvm_phase phase);
    phase.raise_objection(this);
    uvm_top.set_timeout(100us, 0);
    $timeformat(-9, 0, "ns", 6);
    $display("Running test...");
    test_task();
    #1us;
    $display("Test completed.");
    phase.drop_objection(this);
endtask

task Testcase_Utils::test_task();
    int err_cnt = 0;
    logic [31:0] data, got, exp, rv;

    $display("============================================================");
    $display("get_bit_field / set_bit_field 位域读写测试 (仅合法参数)");
    $display("============================================================");

    $display("");
    $display("1) 边界: offset=0, width=32 (整寄存器)");
    data = utils::set_bit_field(.data(32'h0), .offset(0), .width(32), .value(32'hDEAD_BEEF));
    got  = utils::get_bit_field(.data(data), .offset(0), .width(32));
    $display("set 写入 (.val=DEAD_BEEF) -> data=0x%h, get 读出 -> got=0x%h", data, got);
    if (got !== 32'hDEAD_BEEF) begin
        err_cnt++;
        $display("[FAIL] off=0,w=32: got=0x%h, 期望 exp=0x%h", got, 32'hDEAD_BEEF);
    end

    $display("");
    $display("2) 边界: offset=0, width=1 (最低位)");
    data = utils::set_bit_field(.data(32'hFFFF_FFFF), .offset(0), .width(1), .value(1'b0));
    got  = utils::get_bit_field(.data(data), .offset(0), .width(1));
    $display("set 写入 (.val=0) -> data=0x%h, get 读出 -> got=0x%h", data, got);
    if (got !== 1'b0) begin
        err_cnt++;
        $display("[FAIL] off=0,w=1 清除最低位: got=0x%h, 期望 exp=0x%h", got, 1'b0);
    end

    $display("");
    $display("3) 边界: offset=31, width=1 (最高位)");
    data = utils::set_bit_field(.data(32'h0), .offset(31), .width(1), .value(1'b1));
    got  = utils::get_bit_field(.data(data), .offset(31), .width(1));
    $display("set 写入 (.val=1) -> data=0x%h, get 读出 -> got=0x%h", data, got);
    if (got !== 1'b1) begin
        err_cnt++;
        $display("[FAIL] off=31,w=1 置位最高位: got=0x%h, 期望 exp=0x%h", got, 1'b1);
    end

    $display("");
    $display("4) 多字段: 16/8/8 位并排拼接");
    data = 32'h0;
    data = utils::set_bit_field(.data(data), .offset(16), .width(16), .value(16'hABCD));
    $display("    写入后 set off=16,w=16 -> data=0x%h", data);
    data = utils::set_bit_field(.data(data), .offset(8),  .width(8),  .value(8'h12));
    $display("    写入后 set off=8,w=8  -> data=0x%h", data);
    data = utils::set_bit_field(.data(data), .offset(0),  .width(8),  .value(8'h34));
    $display("    写入后 set off=0,w=8  -> data=0x%h", data);
    exp  = 32'hABCD_1234;
    got  = utils::get_bit_field(.data(data), .offset(0), .width(32));
    $display("多字段 -> data=0x%h, get 读出 -> got=0x%h", data, got);
    if (got !== exp) begin
        err_cnt++;
        $display("[FAIL] 多字段: got=0x%h, 期望 exp=0x%h", got, exp);
    end

    $display("");
    $display("5) set 保留未选中位");
    data = utils::set_bit_field(.data(32'hFFFF_FFFF), .offset(8), .width(8), .value(8'h00));
    got  = utils::get_bit_field(.data(data), .offset(0), .width(32));
    exp  = 32'hFFFF_00FF;
    $display("set 写入 (.val=00) -> data=0x%h, get 读出 -> got=0x%h", data, got);
    if (got !== exp) begin
        err_cnt++;
        $display("[FAIL] 保留位: got=0x%h, 期望 exp=0x%h", got, exp);
    end

    $display("");
    $display("6) value 超出字段宽度被截断");
    data = utils::set_bit_field(.data(32'h0), .offset(4), .width(4), .value(32'h0000_00FF));
    got  = utils::get_bit_field(.data(data), .offset(4), .width(4));
    $display("set 写入 (.val=000000FF) -> data=0x%h, get 读出 -> got=0x%h", data, got);
    if (got !== 4'hF) begin
        err_cnt++;
        $display("[FAIL] value 截断: got=0x%h, 期望 exp=0x%h", got, 4'hF);
    end

    $display("");
    $display("7) 全组合往返 (所有合法 offset/width 组合)");
    for (int w = 1; w <= 32; w++) begin
        for (int off = 0; off + w <= 32; off++) begin
            // max value representable within the field width
            rv = (w == 32) ? 32'hFFFF_FFFF : ((32'h1 << w) - 1);
            data = utils::set_bit_field(.data(32'h0), .offset(off), .width(w), .value(rv));
            got  = utils::get_bit_field(.data(data), .offset(off), .width(w));
            $display("off=%2d w=%2d val=0x%08h -> data=0x%08h, get 读出 -> got=0x%08h", off, w, rv, data, got);
            if (got !== rv) begin
                err_cnt++;
                $display("[FAIL] 往返 off=%2d w=%2d: got=0x%08h, 期望 exp=0x%08h", off, w, got, rv);
            end
        end
    end

    $display("============================================================");
    if (err_cnt == 0)
        $display("[PASS] 全部测试通过");
    else
        $display("[FAIL] %0d 项检查失败.", err_cnt);
    $display("============================================================");
endtask
