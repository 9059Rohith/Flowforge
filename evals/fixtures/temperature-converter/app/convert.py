#!/usr/bin/env python3
"""Small deterministic fixture for FlowForge's offline trust-evidence evaluation."""

import sys


def convert(value: float, code: str) -> float:
    formulas = {
        "c2f": lambda x: x * 9 / 5 + 32,
        "f2c": lambda x: (x - 32) * 5 / 9,
        "c2k": lambda x: x + 273.15,
        "k2c": lambda x: x - 273.15,
    }
    if code not in formulas:
        raise ValueError(f"unsupported conversion: {code}")
    return formulas[code](value)


def selftest() -> None:
    checks = [(100, "c2f", 212), (32, "f2c", 0), (0, "c2k", 273.15), (273.15, "k2c", 0)]
    for value, code, expected in checks:
        if abs(convert(value, code) - expected) > 1e-9:
            raise AssertionError(f"{code} failed")


def main() -> int:
    if len(sys.argv) == 2 and sys.argv[1] == "--selftest":
        selftest()
        print("selftest: ok")
        return 0
    if len(sys.argv) != 3:
        print("usage: convert.py VALUE c2f|f2c|c2k|k2c", file=sys.stderr)
        return 2
    try:
        print(convert(float(sys.argv[1]), sys.argv[2]))
    except (ValueError, TypeError) as exc:
        print(str(exc), file=sys.stderr)
        return 2
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
