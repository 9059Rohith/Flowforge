# Contributing to FlowForge

## Before changing code

Read [`AGENTS.md`](AGENTS.md), [`docs/OpenFab_MVP_Design_and_PRD.md`](docs/OpenFab_MVP_Design_and_PRD.md), and [`ARCHITECTURE.md`](ARCHITECTURE.md). Keep the core independent from concrete bases and forges.

## Change boundaries

- Preserve API payloads and environment variable names unless a compatibility change is explicitly required.
- Define or adjust the port/spec boundary before implementing a new adapter behavior.
- Keep generated or untrusted code behind the sandbox path.
- Never commit credentials, runtime identities, or provider logs containing secrets.
- Prefer small, reviewable changes with tests proportional to the risk.

## Local checks

```bash
cargo fmt --all
cargo clippy --all-targets --all-features -- -D warnings
cargo test
cargo build --release
```

For browser-only edits, also run `node --check` on every changed JavaScript module and inspect desktop and mobile captures.

## Pull requests

Describe the user-visible effect, preserved compatibility boundaries, validation commands, and any remaining environment-dependent checks. Do not claim deployment, integration, or security results that were not verified.
