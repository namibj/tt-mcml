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
N 610 -220 680 -105 {lab=clk_p}
N 610 -180 680 -45 {lab=clk_n}
C {bias_gen.sym} 200 -200 0 0 {name=x1}
C {clk_core.sym} 500 -200 0 0 {name=x2}
C {clk_div.sym} 800 -200 0 0 {name=x3}
C {devices/vsource.sym} 100 -400 0 0 {name=V1 value=1.8}
C {devices/gnd.sym} 100 -370 0 0 {name=l1 lab=VGND}
C {devices/vsource.sym} 200 -400 0 0 {name=V2 value="PULSE(0 1.8 1n 1n 1n 10u 20u)"}
C {devices/gnd.sym} 200 -370 0 0 {name=l2 lab=VGND}
C {devices/vsource.sym} 390 -400 0 0 {name=V3 value=0.0}
C {devices/gnd.sym} 390 -370 0 0 {name=l3 lab=VGND}
C {devices/code.sym} 450 -450 0 0 {name=TT_MODELS

only_toplevel=true

format="tcleval( @value )"

value="

** opencircuitdesign pdks install

.lib $::SKYWATER_MODELS/sky130.lib.spice tt

.include $::SKYWATER_STDCELLS/sky130_fd_sc_hd.spice

"

spice_ignore=false}
C {devices/code.sym} 565 -450 0 0 {name=SIMULATION

only_toplevel=false

value="

.param mc_mm_switch=0
*.option savecurrents
.control

*save all

tran 5p 50n
*plot CLK_OUT CLK_P CLK_N
*plot diff_out
*plot bias

quit 0

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
C {devices/code_shown.sym} 830 -440 0 0 {name=PARAMS only_toplevel=false value=".param WP_C=1 LP_C=0.3
+ WP_D=1 LP_D=0.3
+ WN_MAIN=2 LN_MAIN=0.2
+ WN_CC=0.42 LN_CC=0.2
+ WN_TAIL=5 LN_TAIL=0.5
"}
C {devices/isource.sym} 680 -75 0 0 {name=I0 value="PULSE(0 100u 1n 20p 20p 80p 0 1)"}
C {devices/code.sym} 680 -450 0 0 {name=MEASUREMENTS

only_toplevel=false

value="
* 1. Create a continuous differential signal
*B_diff_clk diff_out 0 V=V(clk_p) - V(clk_n)

* 2. Frequency Measurement 
* (Wait for the 30th crossing to ensure any startup jitter is gone)
*.meas tran t_start TRIG V(diff_out) VAL=0 RISE=30
*.meas tran t_end   TRIG V(diff_out) VAL=0 RISE=41
*.meas tran period  PARAM='t_end - t_start'
*.meas tran freq    PARAM='1/period'

* 3. Amplitude / Robustness Measurement
* (Measure the peak differential voltage during that exact period)
*.meas tran v_peak MAX V(diff_out) FROM=t_start TO=t_end
*.meas tran v_pp PP V(diff_out) from=30n to=40n


* 1. Create a continuous differential signal
B_diff_clk diff_out 0 V=V(clk_p) - V(clk_n)

* 2. Frequency Measurement 
* (Using WHEN to grab exact timestamps)
.meas tran t_start WHEN V(diff_out)=0 RISE=30
.meas tran t_end   WHEN V(diff_out)=0 RISE=41

* (Divide by 11 because RISE 30 to 41 is 11 cycles)
.meas tran period  PARAM='(t_end - t_start) / 11'
.meas tran freq    PARAM='1 / period'

* 3. Amplitude / Robustness Measurement
* (Your static window Peak-to-Peak approach)
.meas tran v_pp PP V(diff_out) FROM=30n TO=40n
"}
