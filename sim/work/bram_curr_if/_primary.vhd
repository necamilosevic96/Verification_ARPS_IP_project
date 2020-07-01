library verilog;
use verilog.vl_types.all;
entity bram_curr_if is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic
    );
end bram_curr_if;
