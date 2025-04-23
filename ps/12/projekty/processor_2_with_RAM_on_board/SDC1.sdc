create_clock -name CLOCK_50 -period "50 MHz" [get_ports {CLOCK_50}]
create_clock -name virt_CLOCK_50_in -period "50 MHz"
create_clock -name virt_CLOCK_50_out -period "50 MHz"
derive_pll_clocks -create_base_clocks
derive_clock_uncertainty
set_input_delay -clock { virt_CLOCK_50_in } -min 0 [get_ports {SW[*] KEY[*]}]
set_input_delay -clock { virt_CLOCK_50_in } -max 1 [get_ports {SW[*] KEY[*]}]
set_output_delay -clock { virt_CLOCK_50_out } -min 0 [get_ports {LEDR[*]}]
set_output_delay -clock { virt_CLOCK_50_out } -max 1 [get_ports {LEDR[*]}]
