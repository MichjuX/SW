create_clock -name clk -period 10 [get_ports {clk}]
create_clock -name virt_clk_in -period 10
create_clock -name virt_clk_out -period 10
derive_pll_clocks -create_base_clocks
derive_clock_uncertainty
set_input_delay -clock { virt_clk_in } -min 0 [get_ports {w aclr}]
set_input_delay -clock { virt_clk_in } -max 1 [get_ports {w aclr}]
set_output_delay -clock { virt_clk_out } -min 0 [get_ports {z y[*]}]
set_output_delay -clock { virt_clk_out } -max 1 [get_ports {z y[*]}]