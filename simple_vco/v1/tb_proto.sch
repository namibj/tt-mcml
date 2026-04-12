v {xschem version=3.4.5 file_version=1.2}

G {}

K {}

V {}

S {}

E {}

N 200 -260 200 -280 {lab=VPWR}

N 200 -140 200 -120 {lab=VGND}

N 140 -220 120 -220 {lab=EN}

N 140 -180 120 -180 {lab=CTRL}

N 260 -200 280 -200 {lab=BIAS}

N 500 -260 500 -280 {lab=VPWR}

N 500 -140 500 -120 {lab=VGND}

N 440 -220 420 -220 {lab=CTRL}

N 440 -180 420 -180 {lab=BIAS}

N 560 -220 580 -220 {lab=CLK_P}

N 560 -180 580 -180 {lab=CLK_N}

N 800 -280 800 -300 {lab=VPWR}

N 800 -120 800 -100 {lab=VGND}

N 720 -240 700 -240 {lab=CTRL}

N 720 -220 700 -220 {lab=BIAS}

N 720 -180 700 -180 {lab=CLK_P}

N 720 -160 700 -160 {lab=CLK_N}

N 880 -200 900 -200 {lab=CLK_OUT}

N 100 -430 100 -450 {lab=VPWR}

N 200 -430 200 -450 {lab=EN}

N 300 -430 300 -450 {lab=CTRL}

C {bias_gen.sym} 200 -200 0 0 {name=x1}

C {clk_core.sym} 500 -200 0 0 {name=x2}

C {clk_div.sym} 800 -200 0 0 {name=x3}

C {devices/vsource.sym} 100 -400 0 0 {name=V1 value=1.8}

C {devices/gnd.sym} 100 -370 0 0 {name=l1 lab=VGND}

C {devices/vsource.sym} 200 -400 0 0 {name=V2 value="PULSE(0 1.8 1n 1n 1n 10u 20u)"}

C {devices/gnd.sym} 200 -370 0 0 {name=l2 lab=VGND}

C {devices/vsource.sym} 300 -400 0 0 {name=V3 value=0.9}

C {devices/gnd.sym} 300 -370 0 0 {name=l3 lab=VGND}

C {devices/code.sym} 500 -400 0 0 {name=TT_MODELS

only_toplevel=true

format="tcleval( @value )"

value="

** opencircuitdesign pdks install

.lib $::SKYWATER_MODELS/sky130.lib.spice tt

.include $::SKYWATER_STDCELLS/sky130_fd_sc_hd.spice

"

spice_ignore=false}

C {devices/code.sym} 700 -400 0 0 {name=SIMULATION

only_toplevel=false

value="

.param mc_mm_switch=0

.control

save all

tran 50p 5u

plot CLK_OUT CLK_P CLK_N

*quit 0

.endc

.end

"}