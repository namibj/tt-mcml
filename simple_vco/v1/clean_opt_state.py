#!/usr/bin/env python3
"""Clean BayesianOptimization saved state files by zeroing invalid targets.

This script is aimed at state files like `opt_state.json` produced by the
`bayesian-optimization` package. It uses a minimum signal amplitude threshold
(from `constraint_values`) to decide whether a recorded objective value in
`target` should be treated as invalid.

Default policy:
- If constraint/amplitude < threshold, set target to 0.0
- Otherwise leave target unchanged

The script preserves all other fields exactly as loaded.
"""

from __future__ import annotations

import argparse
import json
import math
import shutil
from pathlib import Path
from typing import Any, Dict, List, Tuple


def load_json(path: Path) -> Dict[str, Any]:
    with path.open("r", encoding="utf-8") as f:
        return json.load(f)


def validate_state(data: Dict[str, Any]) -> Tuple[List[Any], List[Any]]:
    if "target" not in data:
        raise KeyError("State file is missing required key: 'target'")
    if "constraint_values" not in data:
        raise KeyError("State file is missing required key: 'constraint_values'")

    targets = data["target"]
    constraints = data["constraint_values"]

    if not isinstance(targets, list):
        raise TypeError("'target' must be a list")
    if not isinstance(constraints, list):
        raise TypeError("'constraint_values' must be a list")
    if len(targets) != len(constraints):
        raise ValueError(
            f"Length mismatch: len(target)={len(targets)} != "
            f"len(constraint_values)={len(constraints)}"
        )
    return targets, constraints


def sanitize_targets(
    data: Dict[str, Any],
    threshold: float,
    replacement: float,
    only_positive_targets: bool,
) -> Dict[str, Any]:
    targets, constraints = validate_state(data)

    cleaned = dict(data)
    new_targets: List[float] = []

    changed_indices: List[int] = []
    invalid_constraint_count = 0
    nan_constraint_count = 0

    for i, (target, constraint) in enumerate(zip(targets, constraints)):
        new_target = target
        invalid = False

        if constraint is None:
            invalid = True
            invalid_constraint_count += 1
        else:
            try:
                c = float(constraint)
            except (TypeError, ValueError):
                invalid = True
                invalid_constraint_count += 1
            else:
                if not math.isfinite(c):
                    invalid = True
                    nan_constraint_count += 1
                elif c < threshold:
                    invalid = True
                    invalid_constraint_count += 1

        if invalid:
            if (not only_positive_targets) or (float(target) > replacement):
                new_target = replacement
                if float(target) != float(new_target):
                    changed_indices.append(i)

        new_targets.append(float(new_target))

    cleaned["target"] = new_targets
    cleaned["cleaning_report"] = {
        "rule": f"constraint_values < {threshold} => target = {replacement}",
        "threshold_volts": threshold,
        "replacement_target": replacement,
        "only_positive_targets": only_positive_targets,
        "total_points": len(targets),
        "changed_points": len(changed_indices),
        "invalid_constraint_points": invalid_constraint_count,
        "nonfinite_constraint_points": nan_constraint_count,
        "changed_indices_preview": changed_indices[:25],
    }
    return cleaned


def save_json(path: Path, data: Dict[str, Any]) -> None:
    with path.open("w", encoding="utf-8") as f:
        json.dump(data, f, indent=2)
        f.write("\n")


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Clean a BayesianOptimization opt_state.json using an amplitude threshold."
    )
    parser.add_argument(
        "input",
        type=Path,
        help="Path to the source opt_state.json",
    )
    parser.add_argument(
        "-o",
        "--output",
        type=Path,
        help="Path to write the cleaned JSON. Defaults to '<input>.cleaned.json'.",
    )
    parser.add_argument(
        "--threshold-mv",
        type=float,
        default=1.0,
        help="Minimum valid amplitude in millivolts. Default: 1.0 mV",
    )
    parser.add_argument(
        "--replacement",
        type=float,
        default=0.0,
        help="Replacement target value for invalid points. Default: 0.0",
    )
    parser.add_argument(
        "--rewrite-in-place",
        action="store_true",
        help="Rewrite the input file in place instead of creating a cleaned copy.",
    )
    parser.add_argument(
        "--backup",
        action="store_true",
        help="When rewriting in place, also create '<input>.bak'.",
    )
    parser.add_argument(
        "--force-all-invalid",
        action="store_true",
        help=(
            "Also replace invalid targets that are already <= replacement. "
            "By default the script only overwrites targets that are above the replacement value."
        ),
    )
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Print what would change without writing any file.",
    )
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    input_path = args.input
    threshold_v = args.threshold_mv * 1e-3

    if not input_path.exists():
        raise FileNotFoundError(f"Input file not found: {input_path}")

    if args.rewrite_in_place and args.output is not None:
        raise ValueError("Use either --rewrite-in-place or --output, not both")

    if args.rewrite_in_place:
        output_path = input_path
    else:
        output_path = args.output or input_path.with_suffix(input_path.suffix + ".cleaned")

    data = load_json(input_path)
    cleaned = sanitize_targets(
        data=data,
        threshold=threshold_v,
        replacement=args.replacement,
        only_positive_targets=not args.force_all_invalid,
    )

    report = cleaned["cleaning_report"]
    print("Cleaning summary")
    print("----------------")
    print(f"Input file:         {input_path}")
    print(f"Output file:        {output_path}")
    print(f"Threshold:          {args.threshold_mv} mV ({threshold_v:.6g} V)")
    print(f"Replacement target: {args.replacement}")
    print(f"Total points:       {report['total_points']}")
    print(f"Changed points:     {report['changed_points']}")
    print(f"Invalid points:     {report['invalid_constraint_points']}")
    print(f"Preview indices:    {report['changed_indices_preview']}")

    if args.dry_run:
        print("\nDry run only. No file written.")
        return 0

    if args.rewrite_in_place and args.backup:
        backup_path = input_path.with_suffix(input_path.suffix + ".bak")
        shutil.copy2(input_path, backup_path)
        print(f"Backup written to:  {backup_path}")

    save_json(output_path, cleaned)
    print(f"\nWrote cleaned state to: {output_path}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())