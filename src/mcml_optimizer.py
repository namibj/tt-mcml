import argparse
import sys
import os
from bayes_opt import BayesianOptimization
from mcml_tb import evaluate_design

class Args:
    pass

def main():
    parser = argparse.ArgumentParser(description="MCML Bayesian Optimizer")
    parser.add_argument("--levels", type=int, default=1, help="Number of stacked levels")
    parser.add_argument("--model", type=str, default="01v8")
    parser.add_argument("--l", type=float, default=0.15)
    args_in = parser.parse_args()

    args = Args()
    args.levels = args_in.levels
    args.model = args_in.model
    args.vdd = 1.8
    args.vcm = 1.7
    args.vdiff_pp = 0.4
    args.itail_base = 100e-6

    def target_function(**kwargs):
        # kwargs contains w1, w2, ..., wN
        w_list = [kwargs[f'w{i+1}'] for i in range(args.levels)]
        l_list = [args_in.l] * args.levels

        ugf = evaluate_design(args, w_list, l_list, output_file=f"tb_opt_{args.levels}_{args.model}.spice")

        # If constraint failed, it returns -1.0. We want to maximize UGF,
        # so return a small value if constraint fails.
        if ugf < 0:
            return 1.0 # 1 Hz

        return ugf

    pbounds = {}
    for i in range(args.levels):
        pbounds[f'w{i+1}'] = (0.42, 20.0)

    optimizer = BayesianOptimization(
        f=target_function,
        pbounds=pbounds,
        random_state=42,
        verbose=2
    )

    print(f"Starting Optimization for {args.levels}-level tree with {args.model}")
    optimizer.maximize(init_points=5, n_iter=15)

    if optimizer.max and optimizer.max['target'] > 1.0:
        print("\nOptimization Complete!")
        print(f"Max UGF: {optimizer.max['target']/1e9:.3f} GHz")
        print("Optimal Widths:")
        for k, v in optimizer.max['params'].items():
            print(f"  {k}: {v:.3f} um")
    else:
        print("Failed to find a configuration that meets the constraints.")

if __name__ == '__main__':
    main()
