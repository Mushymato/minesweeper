vlib work

vlog -timescale 1ns/1ns mineboard.v
vsim board

log {/*}
add wave {/*}

force {bombGrid} 100010000
force {revealGrid} 000000000
force {cursorGrid} 000010000
force {move} 0
force {dir} 00
run 4ns
force {move} 1
run 4ns
force {dir} 01
run 4ns
force {dir} 10
run 4ns
force {dir} 11
run 4ns