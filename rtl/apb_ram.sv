module apb_ram #(
    parameter   PADDR_WIDTH = 16,
    localparam  PDATA_WIDTH = 32,
    localparam  MEM_ADDR_WIDTH = PADDR_WIDTH - 2,
    localparam  MEM_ADDR_DEPTH = 2 << MEM_ADDR_WIDTH

)(
    input  logic                    pclk,
    input  logic                    presetn,

    input  logic                    psel,
    input  logic                    penable,
    input  logic                    pwrite,
    input  logic [PADDR_WIDTH-1:0]  paddr,
    input  logic [PDATA_WIDTH-1:0]  pwdata,

    output logic [PDATA_WIDTH-1:0]  prdata,
    output logic                    pready,
    output logic                    pslverr
);


    wire [MEM_ADDR_WIDTH-1:0] mem_addr = paddr[MEM_ADDR_WIDTH-1:0];
    wire pstart = psel & ~penable;
    wire paccept = psel & penable & pready;

    logic [31:0] ram [MEM_ADDR_DEPTH];

    enum {IDLE, SETUP, ACCEPT} state, state_next;
    logic [7:0] paccept_cnt, paccept_cnt_max;

    assign prdata = ram[mem_addr];
    assign pslverr = 1'b0;

    always_ff @(posedge pclk or negedge presetn) begin
        if (!presetn) begin
            state <= IDLE;
        end else begin
            state <= state_next;
        end
    end

    always_comb begin
        case (state)
            IDLE: begin
                if (pstart)
                    state_next = SETUP;
                else
                    state_next = IDLE;
            end
            SETUP: begin
                state_next = ACCEPT;
            end
            ACCEPT: begin
                if (pready)
                    if (pstart)
                        state_next = SETUP;
                    else
                        state_next = IDLE;
                else
                    state_next = ACCEPT;
            end
        endcase
    end

    always_ff @(posedge pclk) begin
        if (pstart) begin
            paccept_cnt <= $urandom_range(0, 1);
        end
        else if (paccept_cnt > 0) begin
            paccept_cnt <= paccept_cnt - 1;
        end

    end

    always_comb begin
        if (state_next == ACCEPT && paccept_cnt != 0)
            pready = 1'b0;
        else
            pready = 1'b1;
    end

    always_ff @(posedge pclk) begin
        if (paccept & pwrite)
            ram[mem_addr] <= pwdata;
    end

    // TIME + EVENTS
    // @(敏感事件) 断言表达式序列/单个表达式
    property property_pslverr;
        @(posedge pclk) ~pslverr;
    endproperty

    // psel 有效的同一周期, paddr 的所有位都有效
    // psel 有效的同一周期, paddr 的低位对齐
    property property_paddr;
        @(posedge pclk) psel |-> !$isunknown(paddr) && paddr[1:0] == 2'b00;
    endproperty

    // psel 拉高的下一周期, penable 拉高
    // 注: 也可以用 ##1 代替 |=> 符号
    property property_penable;
        @(posedge pclk) $rose(psel) |=> $rose(penable);
    endproperty

    assert_pslverr: assert property (property_pslverr);
    assert_paddr: assert property (property_paddr);
    assert_penable: assert property (property_penable);

endmodule