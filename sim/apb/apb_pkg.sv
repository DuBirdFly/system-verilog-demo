package apb_pkg;

    parameter int APB_ADDR_WIDTH = 8;
    parameter int APB_DATA_WIDTH = 32;

    parameter int WAIT_PREADY_MAX = 8;
    parameter string ApbChn_LogFile = "log/ApbChn.log";

    // 把 src_data 的 offset 位开始的 width 位设置为 value
    // 但不能直接写 src_data[offset +: width] = value, 因为 sv 不支持变宽的 +: 语法
    function automatic logic [APB_DATA_WIDTH - 1:0] set_bit(
        logic [APB_DATA_WIDTH - 1:0] src_data,
        int offset,
        int width,
        logic [APB_DATA_WIDTH - 1:0] value
    );
        logic [APB_DATA_WIDTH - 1:0] dst_data = src_data;

        if (offset < 0 || offset >= APB_DATA_WIDTH) begin
            $error("offset %0d out of range [0, %0d]", offset, APB_DATA_WIDTH - 1);
            $finish;
        end

        if (width < 1 || width > APB_DATA_WIDTH) begin
            $error("width %0d out of range [1, %0d]", width, APB_DATA_WIDTH);
            $finish;
        end

        if (offset + width > 32) begin
            $error("offset %0d + width %0d out of range [0, 31]", offset, width);
            $finish;
        end

        for (int i = 0; i < width; i++) begin
            dst_data[offset + i - 1] = value[i];
        end

        return dst_data;
    endfunction

endpackage