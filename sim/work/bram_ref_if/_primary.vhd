library verilog;
use verilog.vl_types.all;
entity bram_ref_if is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic
    );
end bram_ref_if;
