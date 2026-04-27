# MCML Testbench Optimizer

This folder contains a fully parameterized testbench generation script to optimize and evaluate MCML configurations in the SkyWater 130nm process.

## Usage

You can generate and run testbenches manually:

```bash
python3 src/mcml_tb.py --levels 1 --model 01v8 --w 2.0 --l 0.15 --run
```

Or you can use the optimization script to automatically find the device sizes that maximize the unity gain frequency (UGF):

```bash
python3 src/mcml_optimizer.py --levels 2 --model 01v8 --l 0.15
```

Note: To run ngspice correctly, ensure you have the `SKYWATER_MODELS` environment variable pointing to the correct model library directory (the one containing `sky130.lib.spice`).
