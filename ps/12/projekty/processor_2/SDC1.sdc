create_clock -name Clock -period "50 MHz" [get_ports {Clock}]
create_clock -name virt_Clock_in -period "50 MHz"
create_clock -name virt_Clock_out -period "50 MHz"
derive_pll_clocks -create_base_clocks
derive_clock_uncertainty
set_input_delay -clock { virt_Clock_in } -min 0 [get_ports {Resetn Run DIN[*]}]
set_input_delay -clock { virt_Clock_in } -max 1 [get_ports {Resetn Run DIN[*]}]
set_output_delay -clock { virt_Clock_out } -min 0 [get_ports {Done BusWires[*] ADDR[*] DOUT[*] W}]
set_output_delay -clock { virt_Clock_out } -max 1 [get_ports {Done BusWires[*] ADDR[*] DOUT[*] W}]
