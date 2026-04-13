v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
L 4 90 100 420 100 {}
L 4 90 -410 420 -410 {}
L 4 420 -410 420 100 {}
L 4 90 -410 90 100 {}
L 4 -240 100 90 100 {}
L 4 -240 -410 -240 100 {}
L 4 -240 -410 90 -410 {}
L 4 -620 100 -240 100 {}
L 4 -620 -410 -620 100 {}
L 4 -620 -410 -240 -410 {}
L 4 -1250 100 -620 100 {}
L 4 -1250 -410 -1250 100 {}
L 4 -1250 -410 -620 -410 {}
L 4 -1570 100 -1250 100 {}
L 4 -1570 -410 -1570 100 {}
L 4 -1570 -410 -1250 -410 {}
T {Half-Buffer Replica} 150 -400 0 0 0.4 0.4 {}
T {Differential Amplifier} -180 -400 0 0 0.4 0.4 {}
T {Amplifier Bias} -500 -400 0 0 0.4 0.4 {}
T {Bias Initialization} -1040 -400 0 0 0.4 0.4 {}
T {Integrated Power Gate} -1520 -400 0 0 0.4 0.4 {}
N 160 -180 160 -160 {lab=#net1}
N 160 -160 300 -160 {lab=#net1}
N 340 -100 390 -100 {lab=VPWR}
N 160 -320 300 -320 {lab=VPWR}
N 390 -320 390 -100 {lab=VPWR}
N 300 -320 390 -320 {lab=VPWR}
N 340 -210 360 -210 {lab=#net1}
N 360 -210 360 -160 {lab=#net1}
N 300 -160 360 -160 {lab=#net1}
N 100 -210 120 -210 {lab=ctrl}
N 300 -70 300 -20 {lab=#net2}
N 300 40 300 70 {lab=VGND}
N 160 -150 300 -150 {lab=#net1}
N 160 -150 160 -100 {lab=#net1}
N 50 -100 160 -100 {lab=#net1}
N 10 -150 10 -130 {lab=#net3}
N -70 -150 10 -150 {lab=#net3}
N -150 -150 -70 -150 {lab=#net3}
N -150 -150 -150 -130 {lab=#net3}
N -70 -40 -70 10 {lab=#net4}
N 10 -40 10 -20 {lab=#net4}
N 10 -70 10 -40 {lab=#net4}
N -70 10 -30 10 {lab=#net4}
N -70 -40 10 -40 {lab=#net4}
N 160 10 260 10 {lab=bias_out}
N 160 -50 160 10 {lab=bias_out}
N -150 -50 160 -50 {lab=bias_out}
N -150 -50 -150 -20 {lab=bias_out}
N -150 -70 -150 -50 {lab=bias_out}
N -70 -320 160 -320 {lab=VPWR}
N 10 40 10 70 {lab=VGND}
N -150 40 -150 70 {lab=VGND}
N -800 70 -520 70 {lab=VGND}
N -210 -100 -190 -100 {lab=ctrl}
N -300 -210 -110 -210 {lab=#net5}
N -330 -210 -300 -210 {lab=#net5}
N -300 -210 -300 -160 {lab=#net5}
N -330 10 -290 10 {lab=bias_out}
N -290 -50 -150 -50 {lab=bias_out}
N -290 -50 -290 10 {lab=bias_out}
N -370 -40 -370 -20 {lab=#net6}
N -520 40 -520 70 {lab=VGND}
N -370 40 -370 70 {lab=VGND}
N -520 -40 -520 -20 {lab=#net6}
N -520 -40 -370 -40 {lab=#net6}
N 10 70 300 70 {lab=VGND}
N -370 -320 -70 -320 {lab=VPWR}
N -210 -360 100 -360 {lab=ctrl}
N -800 40 -800 70 {lab=VGND}
N -690 10 -560 10 {lab=#net7}
N -690 -100 -690 10 {lab=#net7}
N 300 -150 300 -130 {lab=#net1}
N -70 -180 -70 -150 {lab=#net3}
N -370 -160 -300 -160 {lab=#net5}
N -370 -160 -370 -130 {lab=#net5}
N 300 -320 300 -240 {lab=VPWR}
N 160 -320 160 -240 {lab=VPWR}
N 100 -360 100 -210 {lab=ctrl}
N -70 -320 -70 -240 {lab=VPWR}
N -210 -360 -210 -100 {lab=ctrl}
N -800 -100 -690 -100 {lab=#net7}
N -800 -180 -800 -100 {lab=#net7}
N -800 -100 -800 -20 {lab=#net7}
N -800 -320 -800 -240 {lab=VPWR}
N -980 40 -980 70 {lab=VGND}
N -980 -180 -980 -100 {lab=#net8}
N -980 -100 -980 -20 {lab=#net8}
N -980 -320 -980 -240 {lab=VPWR}
N -890 -210 -840 -210 {lab=#net8}
N -890 -210 -890 -100 {lab=#net8}
N -980 -100 -890 -100 {lab=#net8}
N -890 -100 -890 10 {lab=#net8}
N -890 10 -840 10 {lab=#net8}
N -1070 -210 -1020 -210 {lab=#net9}
N -1070 -210 -1070 -100 {lab=#net9}
N -1070 -100 -1070 10 {lab=#net9}
N -1070 10 -1020 10 {lab=#net9}
N -1160 -100 -1070 -100 {lab=#net9}
N -1160 -180 -1160 -100 {lab=#net9}
N -1160 -100 -1160 -20 {lab=#net9}
N -1240 10 -1200 10 {lab=bias_out}
N -1240 -50 -1240 10 {lab=bias_out}
N -1240 -50 -290 -50 {lab=bias_out}
N -1160 -320 -980 -320 {lab=VPWR}
N -1160 40 -1160 70 {lab=VGND}
N -1160 -320 -1160 -240 {lab=VPWR}
N -1260 -210 -1200 -210 {lab=en}
N -1330 -50 -1240 -50 {lab=bias_out}
N -1460 -100 -1160 -100 {lab=#net9}
N -450 -100 -410 -100 {lab=VPWR}
N -370 -320 -370 -240 {lab=VPWR}
N -800 -320 -370 -320 {lab=VPWR}
N -370 70 -150 70 {lab=VGND}
N -1460 -100 -1460 -20 {lab=#net9}
N -1330 -50 -1330 -20 {lab=bias_out}
N 300 -180 300 -160 {lab=#net1}
N 300 -160 300 -150 {lab=#net1}
N -110 10 -70 10 {lab=#net4}
N -150 70 10 70 {lab=VGND}
N -520 70 -370 70 {lab=VGND}
N -370 -70 -370 -40 {lab=#net6}
N -980 70 -800 70 {lab=VGND}
N -370 -180 -370 -160 {lab=#net5}
N -450 -360 -210 -360 {lab=ctrl}
N -980 -320 -800 -320 {lab=VPWR}
N -1160 70 -980 70 {lab=VGND}
N -1330 40 -1330 70 {lab=VGND}
N -1460 40 -1460 70 {lab=VGND}
N -450 -320 -450 -100 {lab=VPWR}
N -1500 10 -1370 10 {lab=en}
N -1540 -210 -1260 -210 {lab=en}
N -1540 -210 -1540 10 {lab=en}
N -1570 -360 -450 -360 {lab=ctrl}
N -1570 -320 -1160 -320 {lab=VPWR}
N -1570 10 -1500 10 {lab=en}
N -1570 70 -1160 70 {lab=VGND}
N 160 -50 420 -50 {lab=bias_out}
C {devices/iopin.sym} -1570 -320 0 1 {name=p1 lab=VPWR sim_pinnumber=1}
C {devices/iopin.sym} -1570 70 2 0 {name=p2 lab=VGND sim_pinnumber=2}
C {devices/ipin.sym} -1570 10 0 0 {name=p3 lab=en sim_pinnumber=3}
C {devices/ipin.sym} -1570 -360 0 0 {name=p4 lab=ctrl sim_pinnumber=4}
C {devices/opin.sym} 420 -50 2 1 {name=p5 lab=bias_out sim_pinnumber=5}
C {sky130_fd_pr/pfet3_01v8.sym} -350 -210 0 1 {name=M8
W=5
L=0.3
body=VPWR
nf=1
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=pfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/pfet3_01v8.sym} -170 -100 0 0 {name=M7
W=2
L=0.3
body=VPWR
nf=1
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=pfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/pfet3_01v8.sym} 30 -100 0 1 {name=M6
W=2
L=0.3
body=VPWR
nf=1
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=pfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/pfet3_01v8.sym} 140 -210 0 0 {name=M3
W=1
L=0.3
body=VPWR
nf=1
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=pfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/pfet3_01v8.sym} 320 -210 0 1 {name=M1
W=1
L=0.3
body=VPWR
nf=1
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=pfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/pfet3_01v8.sym} -90 -210 0 0 {name=M5
W=5
L=0.3
body=VPWR
nf=1
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=pfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/nfet3_01v8.sym} -130 10 0 1 {name=M9
W=5
L=0.5
body=VGND
nf=1
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=nfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/nfet3_01v8.sym} -10 10 0 0 {name=M10
W=5
L=0.5
body=VGND
nf=1
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=nfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/nfet3_01v8.sym} -390 -100 0 0 {name=M11
W=2
L=0.2
body=VGND
nf=1
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=nfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/nfet3_01v8.sym} -350 10 0 1 {name=M12
W=5
L=0.5
body=VGND
nf=1
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=nfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/nfet3_01v8.sym} -540 10 0 0 {name=M13
W=5
L=0.15
body=VGND
nf=1
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=nfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/pfet3_01v8.sym} -820 -210 0 0 {name=M14
W=1
L=0.15
body=VPWR
nf=1
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=pfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/nfet3_01v8.sym} -820 10 0 0 {name=M15
W=1
L=0.15
body=VGND
nf=1
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=nfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/pfet3_01v8.sym} -1000 -210 0 0 {name=M16
W=1
L=0.15
body=VPWR
nf=1
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=pfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/nfet3_01v8.sym} -1000 10 0 0 {name=M17
W=1
L=0.15
body=VGND
nf=1
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=nfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/nfet3_01v8.sym} -1180 10 0 0 {name=M19
W=1
L=0.15
body=VGND
nf=1
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=nfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/pfet3_01v8_hvt.sym} -1180 -210 0 0 {name=M18
W=0.42
L=8
body=VPWR
nf=1
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=pfet_01v8_hvt
spiceprefix=X
}
C {sky130_fd_pr/nfet3_01v8.sym} -1350 10 0 0 {name=M20
W=0.42
L=0.15
body=VGND
nf=1
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=nfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/nfet3_01v8.sym} -1480 10 0 0 {name=M21
W=0.42
L=0.15
body=VGND
nf=1
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=nfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/nfet3_01v8.sym} 280 10 0 0 {name=M4
W=5
L=0.5
body=VGND
nf=1
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=nfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/nfet3_01v8.sym} 320 -100 0 1 {name=M2
W=2
L=0.2
body=VGND
nf=1
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=nfet_01v8
spiceprefix=X
}
