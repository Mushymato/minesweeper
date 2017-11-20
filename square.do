vlib work

vlog -timescale 1ns/1ns mineboard.v
vsim square

log {/*}
add wave {/*}

# force {clock} 1 0 ns, 0 1 ns -repeat 2 ns

# reset
#force {resetn} 0
#run 4ns
#force {resetn} 1

force {setbomb} 0
force {setreveal} 0
force {move} 0
force {dir} 00

force {adjbomb} 00000000
force {adjcursor} 0000

force {setmine} 1

run 2ns

force {adjcursor} 1000
force {move} 1

run 2ns

force {dir} 01

run 2ns

force {dir} 10

run 2ns

force {dir} 01

run 2ns

force {dir} 11

run 2ns