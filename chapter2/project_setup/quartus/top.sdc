# Clock constraints
create_clock -name "clk" -period 20.000ns [get_ports {clk}]

# Automatically calculate clock uncertainty to jitter and other effects.
derive_clock_uncertainty