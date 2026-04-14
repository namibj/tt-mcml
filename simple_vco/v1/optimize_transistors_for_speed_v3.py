import os
import re
import subprocess
import numpy as np
from bayes_opt import BayesianOptimization
from scipy.optimize import NonlinearConstraint

# ==========================================
# 1. Caching & File Templating Setup
# ==========================================

# In-memory cache to prevent double-execution when objective 
# and constraint are evaluated for the exact same point.
simulation_cache = {}
STATE_FILE = "opt_state.json"

def generate_schematic(wp_c, wp_d, wn_main, wn_cc, wn_tail, v3_val):
    """Reads base schematic, replaces parameters with line breaks, writes temp file."""
    input_file = "tb_proto.sch"
    output_file = "tb_proto_opt.sch"
    
    try:
        with open(input_file, 'r') as f:
            content = f.read()
    except FileNotFoundError:
        print(f"Error: Base schematic '{input_file}' not found. Cannot proceed.")
        raise

    new_param_str = (
        f'name=PARAMS only_toplevel=false value=".param WP_C={wp_c:.6g} LP_C=0.3\n'
        f'+ WP_D={wp_d:.6g} LP_D=0.3\n'
        f'+ WN_MAIN={wn_main:.6g} LN_MAIN=0.2\n'
        f'+ WN_CC={wn_cc:.6g} LN_CC=0.2\n'
        f'+ WN_TAIL={wn_tail:.6g} LN_TAIL=0.5"'
    )
    
    content = re.sub(
        r'name=PARAMS\s+only_toplevel=false\s+value="\.param[^"]+"', 
        new_param_str, 
        content
    )

    content = re.sub(r'(name=V3\s+value=)[0-9\.-]+', fr'\g<1>{v3_val:.6g}', content)

    with open(output_file, 'w') as f:
        f.write(content)

# ==========================================
# 2. Core Simulation Routine
# ==========================================

def run_simulation(WP_C, WP_D, WN_MAIN, WN_CC, WN_TAIL, V3_val):
    """Checks memory cache, templates files, runs ngspice, and parses output."""
    params_key = (
        round(WP_C, 6), round(WP_D, 6), 
        round(WN_MAIN, 6), round(WN_CC, 6), 
        round(WN_TAIL, 6), round(V3_val, 6)
    )
    
    if params_key in simulation_cache:
        return simulation_cache[params_key]

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

    # Execute ngspice simulation
    freq, v_pp = 0.0, 0.0
    try:
        result = subprocess.run(
            ['ngspice', 'simulation/tb_proto_opt.spice', '-i'],
            check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True
        )
        
        match = re.search(r'freq\s*=\s*([0-9\.eE+-]+).*?v_pp\s*=\s*([0-9\.eE+-]+)', result.stdout, re.IGNORECASE | re.DOTALL)
        
        if match:
            freq = float(match.group(1))
            v_pp = float(match.group(2))
            print(f"  --> Success: Freq = {freq / 1e9:.3f} GHz, V_pp = {v_pp:.3f} V")
        else:
            print("  --> Parse Error: Oscillation likely failed.")
            
    except subprocess.CalledProcessError as e:
        print(f"  --> Ngspice Error: Simulation crashed.\n{e.stderr}")

    simulation_cache[params_key] = (freq, v_pp)
    return freq, v_pp

# ==========================================
# 3. Objective and Constraint Functions
# ==========================================

def objective(WP_C, WP_D, WN_MAIN, WN_CC, WN_TAIL, V3_val):
    freq, _ = run_simulation(WP_C, WP_D, WN_MAIN, WN_CC, WN_TAIL, V3_val)
    return freq

def constraint_func(WP_C, WP_D, WN_MAIN, WN_CC, WN_TAIL, V3_val):
    _, v_pp = run_simulation(WP_C, WP_D, WN_MAIN, WN_CC, WN_TAIL, V3_val)
    return v_pp

# ==========================================
# 4. Bayesian Optimization Setup & Execution
# ==========================================

def main():
    pbounds = {
        'WP_C': (0.42, 10.0),
        'WP_D': (0.42, 10.0),
        'WN_MAIN': (0.42, 10.0),
        'WN_CC': (0.42, 10.0),
        'WN_TAIL': (1.0, 20.0),
        'V3_val': (0.0, 1.8)
    }

    constraint = NonlinearConstraint(constraint_func, lb=1.0, ub=np.inf)

    optimizer = BayesianOptimization(
        f=objective,
        pbounds=pbounds,
        constraint=constraint,
        random_state=42,
        verbose=2,
        allow_duplicate_points=True
    )

    # State Loading Logic
    if os.path.exists(STATE_FILE):
        print(f"\n[Checkpoint Found] Loading previous state from {STATE_FILE}...")
        optimizer.load_state(STATE_FILE)
        print(f"Resuming optimization. Currently evaluated points: {len(optimizer.space)}")
    else:
        # Inject the baseline only if we are starting completely fresh
        optimizer.probe(
            params={
                "WP_C": 1.0, "WP_D": 1.0, "WN_MAIN": 2.0, 
                "WN_CC": 0.42, "WN_TAIL": 5.0, "V3_val": 0.0
            },
            lazy=True
        )

    print("\nStarting Bayesian Optimization...")
    print("-----------------------------------------------------------------")
    
    # Execution parameters
    init_points = 5 if not os.path.exists(STATE_FILE) else 0
    n_iterations = 60

    # 1. Evaluate any initial/probe points first and save
    if init_points > 0 or not os.path.exists(STATE_FILE):
        optimizer.maximize(init_points=init_points, n_iter=0)
        optimizer.save_state(STATE_FILE)

    # 2. Iteratively execute and save state to protect against interruptions
    for i in range(n_iterations):
        optimizer.maximize(init_points=0, n_iter=1)
        optimizer.save_state(STATE_FILE)
    
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
