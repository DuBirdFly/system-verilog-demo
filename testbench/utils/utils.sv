package utils;

    /*
     * 返回带颜色的字符串
     */

    function string color_msg(
        // attribute: 0: Normal, 1: Bold, 2: Dim, 3: Italic, 4: Underline, 5: Blink, 7: Reverse, 8: Hidden
        int attr,
        // foreground: 30: Black, 31: Red, 32: Green, 33: Yellow, 34: Blue, 35: Magenta, 36: Cyan, 37: White, 38/39: Default
        int fg,
        // background: 40: Black, 41: Red, 42: Green, 43: Yellow, 44: Blue, 45: Magenta, 46: Cyan, 47: White, 48/49: Default
        int bg,
        string msg
    );
        return $sformatf("\033[%0d;%0d;%0dm%s\033[0m", attr, fg, bg, msg);
    endfunction

    /*
     * 把 src_data 的 offset 位开始的 width 位设置为 value
     * 注: 相当于 src_data[offset + width - 1 : offset] = value
     * 注: 不能直接写 src_data[offset +: width] = value, 因为 sv 不支持变宽的 +: 语法
     */
    function automatic logic [31:0] set_bit(
        logic [31:0] src_data, int offset, int width, logic [31:0] value
    );
        logic [31:0] dst_data = src_data;

        if (offset < 0 || offset >= 32) begin
            $error("offset %0d out of range [0, 31]", offset);
            $finish;
        end

        if (width < 1 || width > 32) begin
            $error("width %0d out of range [1, 32]", width);
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
