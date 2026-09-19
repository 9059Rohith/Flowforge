# FlowForge Evaluation

This directory describes a reproducible evaluation plan for the productivity and automation track. It intentionally reports engineering evidence instead of inventing task-completion percentages.

## Evaluation dimensions

| Dimension | Procedure | Current evidence |
| --- | --- | --- |
| Build integrity | `cargo fmt`, clippy with warnings denied, tests, release build | Passed locally with stable GNU Windows toolchain |
| Workflow availability | Start the release server and query `/`, `/api/bases`, and `/api/forges` | Passed in an isolated smoke workspace |
| Contract enforcement | Run the Rust trust, provenance, conformance, sandbox, and Codex safety unit tests | 55 tests passed locally |
| Browser safety | Syntax-check all browser modules and inspect the opaque-origin iframe path | Passed locally |
| Secret hygiene | Scan tracked and hidden files for key-shaped material | Clean after removing a secret-shaped example value |
| Product workflow | Run the demo temperature-converter spec through an authenticated provider | Requires a configured provider and is not claimed as completed here |

## Killer workflow case

The canonical demo case is [`specs/demo-temp-converter.spec.yaml`](../specs/demo-temp-converter.spec.yaml): generate a CLI converter, run its self-test, verify Celsius/Fahrenheit conversions, inspect the artifact, and release it only after the selected human gate.

The acceptance contract is intentionally small and deterministic:

```text
python3 app/convert.py --selftest
python3 app/convert.py 100 c2f | grep -q 212
python3 app/convert.py 32 f2c | grep -q '^0'
```

## Run the engineering evaluation

```bash
cargo fmt --all -- --check
cargo clippy --all-targets --all-features -- -D warnings
cargo test
cargo build --release
node --check web/app.js
node --check web/fabengine.js
node --check web/fabcrypto.js
node --check web/forgepush.js
node --check web/ops_browser.js
```

For a full product run, configure one of the supported providers, then use [`docs/DEMO.md`](../docs/DEMO.md). Do not substitute a fake result when a provider is unavailable.

## Future measured metrics

Once a provider-backed benchmark corpus exists, add measurements for task completion, acceptance pass rate, retry recovery, tool selection, runtime, and human approval rate. Each metric must include the task set, model, environment, sample size, and failure cases.
