import argparse
import sys
import subprocess
import os
import re

def parse_ngspice_output(output):
    vtail = None
    ugf = None

    for line in output.split('\n'):
        if 'vtail =' in line:
            parts = line.split('=')
            if len(parts) > 1:
                try:
                    vtail = float(parts[1].strip())
                except:
                    pass
        elif 'ugf =' in line:
            parts = line.split('=')
            if len(parts) > 1:
                try:
                    ugf = float(parts[1].strip())
                except:
                    pass

    return vtail, ugf

def generate_tb(args, w_list, l_list, output_file):
    itail = args.itail_base * (2**(args.levels - 1))
    vdiff_swing = args.vdiff_pp
    rload = vdiff_swing / itail

    models = {
        "01v8": "sky130_fd_pr__nfet_01v8",
        "01v8_lvt": "sky130_fd_pr__nfet_01v8_lvt",
        "03v3_nvt": "sky130_fd_pr__nfet_03v3_nvt"
    }
    model_name = models[args.model]

    # Find the skywater path from env or defaults
    skywater_models = os.environ.get('SKYWATER_MODELS', '')
    pdk_root = os.environ.get('PDK_ROOT', os.path.expanduser('~/.ciel/ciel/sky130/versions/7b70722e33c03fcb5dabcf4d479fb0822d9251c9'))
    if skywater_models:
        skywater_lib = f"{skywater_models}/sky130.lib.spice"
    else:
        skywater_lib = f"{pdk_root}/sky130A/libs.tech/ngspice/sky130.lib.spice"

    # Try to fallback to explicitly including the model corners if the general lib is not available
    fallback_includes = [
        f".include {pdk_root}/sky130A/libs.ref/sky130_fd_pr/spice/sky130_fd_pr__nfet_01v8__tt.corner.spice",
        f".include {pdk_root}/sky130A/libs.ref/sky130_fd_pr/spice/sky130_fd_pr__nfet_01v8_lvt__tt.corner.spice",
        f".include {pdk_root}/sky130A/libs.ref/sky130_fd_pr/spice/sky130_fd_pr__nfet_03v3_nvt__tt.corner.spice",
    ]

    with open(output_file, "w") as f:
        f.write(f"* {args.levels}-level MCML Testbench (Model={args.model})\n\n")
        if os.path.exists(skywater_lib) and not "libs.tech/ngspice/sky130.lib.spice" in skywater_lib:
            f.write(f".lib {skywater_lib} tt\n")
        else:
            f.write(f"*.lib {skywater_lib} tt\n")

        for inc in fallback_includes:
            f.write(f"{inc}\n")
        f.write("\n")
        f.write(".param mc_mm_switch=0\n")

        # Include hd library if user wants, but normally just the core lib is enough.
        skywater_stdcells = os.environ.get('SKYWATER_STDCELLS', '')
        if skywater_stdcells:
            f.write(f".include {skywater_stdcells}/sky130_fd_sc_hd.spice\n\n")

        f.write(f".param VDD = {args.vdd}\n")
        f.write(f".param VCM = {args.vcm}\n")
        f.write(f".param ITAIL = {itail}\n")
        f.write(f".param RLOAD = {rload}\n\n")

        f.write("Vdd VDD 0 VDD\n")
        f.write("I0 tail 0 ITAIL\n\n")

        f.write(f"V_in1_p in1_p 0 dc VCM ac 0.5\n")
        f.write(f"V_in1_n in1_n 0 dc VCM ac -0.5\n")

        for i in range(2, args.levels + 1):
            f.write(f"V_in{i}_p in{i}_p 0 dc VCM\n")
            f.write(f"V_in{i}_n in{i}_n 0 dc VCM\n")
        f.write("\n")

        nodes = ["tail"]
        next_nodes = []
        node_idx = 1

        for level in range(1, args.levels + 1):
            w = w_list[level-1]
            l = l_list[level-1]

            for base_node in nodes:
                node_p = f"n{node_idx}"
                node_n = f"n{node_idx+1}"
                next_nodes.extend([node_p, node_n])
                node_idx += 2

                f.write(f"XM_{base_node}_p {node_p} in{level}_p {base_node} 0 {model_name} W={w} L={l}\n")
                f.write(f"XM_{base_node}_n {node_n} in{level}_n {base_node} 0 {model_name} W={w} L={l}\n")

            nodes = next_nodes
            next_nodes = []
            f.write("\n")

        f.write("* Loads (XOR configuration)\n")
        def count_set_bits(n):
            count = 0
            while n:
                count += n & 1
                n >>= 1
            return count

        for i, top_node in enumerate(nodes):
            if count_set_bits(i) % 2 == 0:
                f.write(f"V_meas_{top_node} {top_node} out_p 0\n")
            else:
                f.write(f"V_meas_{top_node} {top_node} out_n 0\n")

        f.write(f"R_out_p VDD out_p {rload}\n")
        f.write(f"R_out_n VDD out_n {rload}\n\n")

        f.write(f"C_out_p out_p 0 10f\n")
        f.write(f"C_out_n out_n 0 10f\n\n")

        f.write(".control\n")
        f.write("op\n")
        f.write("let vtail = v(tail)\n")
        f.write("print vtail\n")

        f.write("ac dec 20 1M 1000G\n")
        f.write("let vout_diff = v(out_n) - v(out_p)\n")
        f.write("let vmag = mag(vout_diff)\n")
        f.write("meas ac ugf WHEN vmag=1.0 FALL=1\n")
        f.write("print ugf\n")
        f.write("quit\n")
        f.write(".endc\n")
        f.write(".end\n")

def run_simulation(args, w_list, l_list, output_file):
    generate_tb(args, w_list, l_list, output_file)
    try:
        result = subprocess.run(
            ["ngspice", "-b", output_file],
            check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True
        )
        return parse_ngspice_output(result.stdout)
    except subprocess.CalledProcessError as e:
        print(f"Ngspice failed with error:\n{e.stderr}")
        return None, None

def evaluate_design(args, w_list, l_list, output_file="tb_mcml.spice"):
    vtail, ugf = run_simulation(args, w_list, l_list, output_file)
    if vtail is None or ugf is None:
        return -1.0 # Invalid
    if vtail < 0.2:
        return -1.0 # Failed DC constraint
    return ugf

def main():
    parser = argparse.ArgumentParser(description="MCML Testbench Generator")
    parser.add_argument("--levels", type=int, default=1, help="Number of stacked MCML levels")
    parser.add_argument("--model", type=str, choices=["01v8", "01v8_lvt", "03v3_nvt"], default="01v8", help="NMOS model type")
    parser.add_argument("--w", type=str, default="2.0", help="Comma-separated widths for each level (bottom to top)")
    parser.add_argument("--l", type=str, default="0.15", help="Comma-separated lengths for each level (bottom to top)")
    parser.add_argument("--vdd", type=float, default=1.8, help="Supply voltage")
    parser.add_argument("--vcm", type=float, default=1.7, help="Input common-mode voltage")
    parser.add_argument("--vdiff_pp", type=float, default=0.4, help="Differential peak-to-peak voltage swing")
    parser.add_argument("--itail_base", type=float, default=100e-6, help="Base tail current (doubles each level)")
    parser.add_argument("--output", type=str, default="tb_mcml.spice", help="Output SPICE file")
    parser.add_argument("--run", action="store_true", help="Run ngspice after generating")

    args = parser.parse_args()

    w_str_list = args.w.split(',')
    l_str_list = args.l.split(',')

    if len(w_str_list) == 1:
        w_list = [float(w_str_list[0])] * args.levels
    elif len(w_str_list) == args.levels:
        w_list = [float(x) for x in w_str_list]
    else:
        print(f"Error: Provided {len(w_str_list)} widths for {args.levels} levels.")
        sys.exit(1)

    if len(l_str_list) == 1:
        l_list = [float(l_str_list[0])] * args.levels
    elif len(l_str_list) == args.levels:
        l_list = [float(x) for x in l_str_list]
    else:
        print(f"Error: Provided {len(l_str_list)} lengths for {args.levels} levels.")
        sys.exit(1)

    if args.run:
        print("Running ngspice...")
        vtail, ugf = run_simulation(args, w_list, l_list, args.output)
        print(f"Generated {args.output}")
        print("\n--- Simulation Results ---")
        if vtail is not None:
            print(f"Tail Voltage (Vtail): {vtail:.4f} V")
            if vtail < 0.2:
                print("  -> FAIL: vtail is below 0.2V (200mV constraint violated!)")
            else:
                print("  -> PASS: vtail >= 200mV")
        else:
            print("Tail Voltage: Not found")

        if ugf is not None:
            print(f"Unity Gain Freq (UGF): {ugf/1e9:.3f} GHz")
        else:
            print("Unity Gain Freq: Not found (Check if AC gain > 1)")
    else:
        generate_tb(args, w_list, l_list, args.output)
        print(f"Generated {args.output}")

if __name__ == '__main__':
    main()

# Optimization Loop
def optimize_design(args):
    # This is a simple grid search / sweep example to find the optimal widths
    # for a given configuration to maximize UGF.
    print(f"Starting optimization for {args.levels}-level tree using {args.model}")
    print(f"Goal: Maximize UGF while keeping Vtail >= 0.2V")

    # We will just do a simple sweep for now since BayesianOptimization isn't imported here,
    # or we can rely on the user to use `evaluate_design` from their own optimizer.

    best_ugf = -1.0
    best_w = None

    # Simple search for 1 level:
    w_options = [0.5, 1.0, 2.0, 4.0, 8.0, 16.0]

    if args.levels == 1:
        for w in w_options:
            ugf = evaluate_design(args, [w], [float(args.l.split(',')[0])])
            if ugf > best_ugf:
                best_ugf = ugf
                best_w = [w]

    elif args.levels == 2:
        for w1 in w_options:
            for w2 in w_options:
                ugf = evaluate_design(args, [w1, w2], [float(x) for x in args.l.split(',')][:2])
                if ugf > best_ugf:
                    best_ugf = ugf
                    best_w = [w1, w2]

    # For more levels, it would be better to use bayesian optimization or similar.
    # But this provides a basic evaluation loop.
    if best_ugf > 0:
        print(f"Best UGF: {best_ugf/1e9:.3f} GHz with W={best_w}")
    else:
        print("No configuration met the constraints.")

if __name__ == '__main__':
    # Modifying the main to optionally run optimization
    import sys
    if '--optimize' in sys.argv:
        # Just run the simple optimizer
        sys.argv.remove('--optimize')
        parser = argparse.ArgumentParser(description="MCML Testbench Generator")
        parser.add_argument("--levels", type=int, default=1, help="Number of stacked MCML levels")
        parser.add_argument("--model", type=str, choices=["01v8", "01v8_lvt", "03v3_nvt"], default="01v8", help="NMOS model type")
        parser.add_argument("--w", type=str, default="2.0", help="Comma-separated widths for each level (bottom to top)")
        parser.add_argument("--l", type=str, default="0.15", help="Comma-separated lengths for each level (bottom to top)")
        parser.add_argument("--vdd", type=float, default=1.8, help="Supply voltage")
        parser.add_argument("--vcm", type=float, default=1.7, help="Input common-mode voltage")
        parser.add_argument("--vdiff_pp", type=float, default=0.4, help="Differential peak-to-peak voltage swing")
        parser.add_argument("--itail_base", type=float, default=100e-6, help="Base tail current (doubles each level)")
        parser.add_argument("--output", type=str, default="tb_mcml.spice", help="Output SPICE file")
        parser.add_argument("--run", action="store_true", help="Run ngspice after generating")
        args = parser.parse_args()
        optimize_design(args)
