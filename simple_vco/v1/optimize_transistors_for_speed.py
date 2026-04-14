import os
import re
import subprocess
import numpy as np
from bayes_opt import BayesianOptimization, NonLinearConstraint

# ==========================================
# 1. Caching & File Templating Setup
# ==========================================

# Dictionary to cache (freq, v_pp) results.
# Key: (WP_C, WP_D, WN_MAIN, WN_CC, WN_TAIL, V3_val)
simulation_cache = {}

def generate_schematic(wp_c, wp_d, wn_main, wn_cc, wn_tail, v3_val):
    """Reads the base schematic, replaces parameters, and writes to a temp file."""
    input_file = "tb_proto.sch"
    output_file = "tb_proto_opt.sch"
    
    try:
        with open(input_file, 'r') as f:
            content = f.read()
    except FileNotFoundError:
        print(f"Error: Base schematic '{input_file}' not found. Cannot proceed.")
        raise

    # 1. Dynamically replace the PARAMS block while keeping lengths at static defaults
    # Rebuilding the exact value string based on the user's required parameters
    new_param_str = (f'name=PARAMS only_toplevel=false value=".param '
                     f'WP_C={wp_c:.6g} LP_C=0.3+ '
                     f'WP_D={wp_d:.6g} LP_D=0.3+ '
                     f'WN_MAIN={wn_main:.6g} LN_MAIN=0.2+ '
                     f'WN_CC={wn_cc:.6g} LN_CC=0.2+ '
                     f'WN_TAIL={wn_tail:.6g} LN_TAIL=0.5"')
    
    # Regex to find the existing PARAMS line and replace the value attribute
    content = re.sub(r'name=PARAMS\s+only_toplevel=false\s+value="\.param[^"]+"', new_param_str, content)

    # 2. Dynamically replace the V3 voltage source value
    # Regex targets "name=V3 value=" followed by any numbers/decimals
    content = re.sub(r'(name=V3\s+value=)[0-9\.-]+', fr'\g<1>{v3_val:.6g}', content)

    with open(output_file, 'w') as f:
        f.write(content)

# ==========================================
# 2. Core Simulation Routine
# ==========================================

def run_simulation(WP_C, WP_D, WN_MAIN, WN_CC, WN_TAIL, V3_val):
    """Checks cache, templates files, runs xschem/ngspice, and parses output."""
    # Round parameters slightly for caching to avoid floating point mismatch issues
    params_key = (
        round(WP_C, 6), round(WP_D, 6), 
        round(WN_MAIN, 6), round(WN_CC, 6), 
        round(WN_TAIL, 6), round(V3_val, 6)
    )
    
    if params_key in simulation_cache:
        return simulation_cache[params_key]

    # Status update for the user
    print(f"\n[Run] Evaluating: WP_C={WP_C:.2f}, WP_D={WP_D:.2f}, WN_MAIN={WN_MAIN:.2f}, "
          f"WN_CC={WN_CC:.2f}, WN_TAIL={WN_TAIL:.2f}, V3={V3_val:.2f}")

    generate_schematic(WP_C, WP_D, WN_MAIN, WN_CC, WN_TAIL, V3_val)

    # Execute xschem netlisting
    try:
        subprocess.run(
            ['xschem', 'tb_proto_opt.sch', '--no_x', '--command', 'xschem netlist; exit'],
            check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True
        )
    except subprocess.CalledProcessError as e:
        print(f"  --> Xschem Error: Netlisting failed. \n{e.stderr}")
        simulation_cache[params_key] = (0.0, 0.0)
        return (0.0, 0.0)

    # Execute ngspice simulation with the interactive (-i) flag
    freq, v_pp = 0.0, 0.0
    try:
        result = subprocess.run(
            ['ngspice', 'simulation/tb_proto_opt.spice', '-i'],
            check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True
        )
        
        # Parse the stdout for freq and v_pp
        # Matches formats like "freq = 3.66055e+09   v_pp = 2.09264e+00"
        match = re.search(r'freq\s*=\s*([0-9\.eE+-]+).*?v_pp\s*=\s*([0-9\.eE+-]+)', result.stdout, re.IGNORECASE | re.DOTALL)
        
        if match:
            freq = float(match.group(1))
            v_pp = float(match.group(2))
            print(f"  --> Success: Freq = {freq / 1e9:.3f} GHz, V_pp = {v_pp:.3f} V")
        else:
            print("  --> Parse Error: Oscillation likely failed (freq/v_pp not found in output).")
            
    except subprocess.CalledProcessError as e:
        print(f"  --> Ngspice Error: Simulation crashed.\n{e.stderr}")

    # Cache and return
    simulation_cache[params_key] = (freq, v_pp)
    return freq, v_pp

# ==========================================
# 3. Objective and Constraint Functions
# ==========================================

def objective(WP_C, WP_D, WN_MAIN, WN_CC, WN_TAIL, V3_val):
    """Objective function: Returns only the frequency."""
    freq, _ = run_simulation(WP_C, WP_D, WN_MAIN, WN_CC, WN_TAIL, V3_val)
    return freq

def constraint_func(WP_C, WP_D, WN_MAIN, WN_CC, WN_TAIL, V3_val):
    """Constraint function: Returns only the peak-to-peak voltage."""
    _, v_pp = run_simulation(WP_C, WP_D, WN_MAIN, WN_CC, WN_TAIL, V3_val)
    return v_pp

# ==========================================
# 4. Bayesian Optimization Setup & Execution
# ==========================================

def main():
    # Define exploration bounds
    pbounds = {
        'WP_C': (0.42, 10.0),
        'WP_D': (0.42, 10.0),
        'WN_MAIN': (0.42, 10.0),
        'WN_CC': (0.42, 10.0),
        'WN_TAIL': (1.0, 20.0),
        'V3_val': (0.0, 1.8)
    }

    # Define the Non-Linear Constraint: v_pp >= 1.0 (Upper bound is infinity)
    constraint = NonLinearConstraint(constraint_func, lb=1.0, ub=np.inf)

    # Initialize the optimizer
    optimizer = BayesianOptimization(
        f=objective,
        pbounds=pbounds,
        constraint=constraint,
        random_state=42,
        verbose=2,
        allow_duplicate_points=True
    )

    # Crucial Step: Inject the known-working baseline to anchor the optimizer
    optimizer.probe(
        params={
            "WP_C": 1.0, 
            "WP_D": 1.0, 
            "WN_MAIN": 2.0, 
            "WN_CC": 0.42, 
            "WN_TAIL": 5.0, 
            "V3_val": 0.0
        },
        lazy=True
    )

    print("\nStarting Bayesian Optimization...")
    print("-----------------------------------------------------------------")
    # Run the maximization loop
    optimizer.maximize(
        init_points=5,
        n_iter=25
    )
    print("-----------------------------------------------------------------")

    # Print final optimized result
    print("\n[Optimization Complete]")
    if optimizer.max:
        best_params = optimizer.max['params']
        best_freq = optimizer.max['target']
        print(f"Maximum Frequency achieved: {best_freq / 1e9:.4f} GHz")
        print("Optimal Parameters:")
        for key, val in best_params.items():
            print(f"  {key}: {val:.4f}")
    else:
        print("Optimizer failed to find a valid maximum meeting the constraint.")

if __name__ == "__main__":
    main()