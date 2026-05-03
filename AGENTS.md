# MCML Testbench Optimization

## Environment Setup

To run the `mcml_optimizer.py` and `mcml_tb.py` scripts successfully, ngspice must be able to locate the correct model libraries for the SkyWater 130nm process (`sky130_fd_pr`).

The scripts support automatic model resolution if `ciel` is used.

### Setup using Ciel

If you use `ciel` to manage your PDKs, the script will automatically discover the `PDK_ROOT` and include the correct models:

```bash
pip3 install ciel
ciel enable -l sky130_fd_pr --pdk-family sky130 7b70722e33c03fcb5dabcf4d479fb0822d9251c9
```

Run the optimizer specifying the model (e.g., `01v8`, `01v8_lvt`, or `03v3_nvt`):

```bash
python3 src/mcml_optimizer.py --levels 1 --model 01v8 --l 0.15
```

### Manual Setup

If you are not using `ciel` or if you have a custom PDK installation, you can explicitly set the `SKYWATER_MODELS` or `PDK_ROOT` environment variables before running the python scripts:

```bash
export PDK_ROOT=/path/to/your/pdk
# OR
export SKYWATER_MODELS=/path/to/your/sky130.lib.spice/directory

python3 src/mcml_optimizer.py --levels 2
```

## Running the scripts

* `src/mcml_tb.py`: Use this to generate a specific SPICE netlist and optionally run it (`--run`). It supports parameterized lengths (`--l`), widths (`--w`), and number of MCML stack levels (`--levels`).
* `src/mcml_optimizer.py`: Wraps the generator with a Bayesian Optimizer to find the optimal widths to maximize the unity gain frequency, while ensuring the lowest differential pair source voltage remains above 200mV for sufficient tail current headroom.
