onerror {resume}
radix define redlight {
  "1'b0" "OFF" -color "white",
  "1'b1" "ON" -color "red",
  -default binary
}
radix define greenlight {
  "1'b0" "OFF" -color "white",
  "1'b1" "ON" -color "green",
  -default binary
}
radix define yelllight {
  "1'b0" "OFF" -color "white",
  "1'b1" "ON" -color "yellow",
  -default binary
}
quietly WaveActivateNextPane {} 0
add wave -noupdate /traffic_light_tb/clk
add wave -noupdate /traffic_light_tb/res_n
add wave -noupdate /traffic_light_tb/btn_n
add wave -noupdate -divider {Internal Signals}
add wave -noupdate -expand /traffic_light_tb/dut/s
add wave -noupdate /traffic_light_tb/dut/s_nxt
add wave -noupdate -divider {Pedestrian Light}
add wave -noupdate -radix greenlight /traffic_light_tb/pgreen
add wave -noupdate -radix redlight /traffic_light_tb/pred
add wave -noupdate -divider {Car Light}
add wave -noupdate -radix greenlight /traffic_light_tb/cgreen
add wave -noupdate -radix yelllight /traffic_light_tb/cyell
add wave -noupdate -radix redlight /traffic_light_tb/cred
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1217664207 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {21063 ms}
