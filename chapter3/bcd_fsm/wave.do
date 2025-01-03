onerror {resume}
radix define ssd_digit {
    "7'b1111111" "OFF" -color "white",
    "7'b0111111" "-" -color "white",
    "7'b1000000" "0" -color "white",
    "7'b1111001" "1" -color "white",
    "7'b0100100" "2" -color "white",
    "7'b0110000" "3" -color "white",
    "7'b0011001" "4" -color "white",
    "7'b0010010" "5" -color "white",
    "7'b0000010" "6" -color "white",
    "7'b1111000" "7" -color "white",
    "7'b0000000" "8" -color "white",
    "7'b0010000" "9" -color "white",
    "7'b0001000" "A" -color "white",
    "7'b0000011" "B" -color "white",
    "7'b1000110" "C" -color "white",
    "7'b0100001" "D" -color "white",
    "7'b0000110" "E" -color "white",
    "7'b0001110" "F" -color "white",
    "7'b1000010" "G" -color "white",
    "7'b1000111" "L" -color "white",
    "7'b1000000" "O" -color "white",
    "7'b0001100" "P" -color "white",
    "7'b1000110" "(" -color "white",
    "7'b1110000" ")" -color "white",
    "7'b0000011" "b" -color "white",
    "7'b0100001" "d" -color "white",
    "7'b1101111" "i" -color "white",
    "7'b0101111" "r" -color "white",
    -default binary
}
quietly WaveActivateNextPane {} 0
add wave -noupdate /bcd_fsm_tb/clk
add wave -noupdate /bcd_fsm_tb/res_n
add wave -noupdate -radix decimal /bcd_fsm_tb/input_data
add wave -noupdate /bcd_fsm_tb/signed_mode
add wave -noupdate -radix ssd_digit /bcd_fsm_tb/hex_digit1000
add wave -noupdate -radix ssd_digit /bcd_fsm_tb/hex_digit100
add wave -noupdate -radix ssd_digit /bcd_fsm_tb/hex_digit10
add wave -noupdate -radix ssd_digit /bcd_fsm_tb/hex_digit1
add wave -noupdate -radix ssd_digit /bcd_fsm_tb/hex_sign
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
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
WaveRestoreZoom {0 ps} {1008 ns}
