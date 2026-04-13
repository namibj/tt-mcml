v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 200 -280 200 -260 {lab=VDD}
N 200 -140 200 -120 {lab=VGND}
N 120 -220 140 -220 {lab=VGND}
N 120 -180 140 -180 {lab=#net1}
N 260 -180 280 -180 {lab=bias}
N 500 -280 500 -260 {lab=VDD}
N 500 -140 500 -120 {lab=VGND}
N 420 -220 440 -220 {lab=#net1}
N 420 -180 440 -180 {lab=bias}
N 560 -220 580 -220 {lab=clk_p}
N 560 -180 580 -180 {lab=clk_n}
N 800 -300 800 -280 {lab=VDD}
N 800 -120 800 -100 {lab=VGND}
N 700 -240 720 -240 {lab=#net1}
N 700 -220 720 -220 {lab=bias}
N 700 -180 720 -180 {lab=clk_p}
N 700 -160 720 -160 {lab=clk_n}
N 880 -200 900 -200 {lab=#net2}
N 100 -450 100 -430 {lab=VDD}
N 200 -450 200 -430 {lab=#net3}
N 390 -450 390 -430 {lab=#net1}
N 350 -450 390 -450 {lab=#net1}
N 350 -450 350 -320 {lab=#net1}
N 110 -320 350 -320 {lab=#net1}
N 110 -320 110 -180 {lab=#net1}
N 110 -180 120 -180 {lab=#net1}
N 120 -120 200 -120 {lab=VGND}
N 90 -120 120 -120 {lab=VGND}
N 90 -220 90 -120 {lab=VGND}
N 90 -220 120 -220 {lab=VGND}
N 280 -180 350 -180 {lab=bias}
N 350 -320 350 -220 {lab=#net1}
N 350 -220 420 -220 {lab=#net1}
N 580 -220 700 -180 {lab=clk_p}
N 580 -180 700 -160 {lab=clk_n}
N 700 -320 700 -240 {lab=#net1}
N 350 -320 700 -320 {lab=#net1}
N 350 -180 420 -180 {lab=bias}
N 350 -180 350 -80 {lab=bias}
N 350 -80 640 -80 {lab=bias}
N 640 -220 640 -80 {lab=bias}
N 640 -220 700 -220 {lab=bias}
N 30 -370 100 -370 {lab=VGND}
N 580 -220 610 -220 {lab=clk_p}
N 580 -180 610 -180 {lab=clk_n}
C {bias_gen.sym} 200 -200 0 0 {name=x1}
C {clk_core.sym} 500 -200 0 0 {name=x2}
C {clk_div.sym} 800 -200 0 0 {name=x3}
C {devices/vsource.sym} 100 -400 0 0 {name=V1 value=1.8}
C {devices/gnd.sym} 100 -370 0 0 {name=l1 lab=VGND}
C {devices/vsource.sym} 200 -400 0 0 {name=V2 value="PULSE(0 1.8 1n 1n 1n 10u 20u)"}
C {devices/gnd.sym} 200 -370 0 0 {name=l2 lab=VGND}
C {devices/vsource.sym} 390 -400 0 0 {name=V3 value=0.4}
C {devices/gnd.sym} 390 -370 0 0 {name=l3 lab=VGND}
C {devices/code.sym} 500 -450 0 0 {name=TT_MODELS

only_toplevel=true

format="tcleval( @value )"

value="

** opencircuitdesign pdks install

.lib $::SKYWATER_MODELS/sky130.lib.spice tt

.include $::SKYWATER_STDCELLS/sky130_fd_sc_hd.spice

"

spice_ignore=false}
C {devices/code.sym} 700 -450 0 0 {name=SIMULATION

only_toplevel=false

value="

.param mc_mm_switch=0

.control

save all

tran 5p 1u
*plot CLK_OUT CLK_P CLK_N
plot diff=par(clk_n - clk_p)
plot bias

*quit 0

.endc

.end

"}
C {devices/gnd.sym} 200 -120 0 0 {name=l4 lab=VGND}
C {devices/gnd.sym} 500 -120 0 0 {name=l5 lab=VGND}
C {devices/gnd.sym} 800 -100 0 0 {name=l6 lab=VGND}
C {devices/vdd.sym} 100 -450 0 0 {name=l7 lab=VDD}
C {devices/vdd.sym} 200 -280 0 0 {name=l8 lab=VDD}
C {devices/vdd.sym} 500 -280 0 0 {name=l9 lab=VDD}
C {devices/vdd.sym} 800 -300 0 0 {name=l10 lab=VDD}
C {devices/lab_wire.sym} 350 -180 0 0 {name=p1 lab=bias}
C {devices/vsource.sym} 30 -340 0 0 {name=V4 value=0 savecurrent=false}
C {devices/gnd.sym} 30 -310 0 0 {name=l11 lab=0}
C {devices/lab_wire.sym} 610 -220 0 0 {name=p2 lab=clk_p}
C {devices/lab_wire.sym} 610 -180 0 0 {name=p3 lab=clk_n}
