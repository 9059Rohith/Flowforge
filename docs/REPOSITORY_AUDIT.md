# FlowForge Repository Audit

This audit records the pre-change architecture map and the "do not touch" boundary used during the rebrand and deployment-readiness pass.

## Architecture Summary

FlowForge is a Rust 2021 application with a CLI, a tiny local HTTP server, and a static browser UI. It is not a conventional frontend/backend monorepo.

Main flow:

```text
User intent
  -> web/index.html + web/app.js or src/cli.rs
  -> src/server.rs API routes or CLI commands
  -> src/ops.rs shared operation layer
  -> src/spec_cycle.rs orchestration
  -> ports::BasePort and ports::ForgePort
  -> generated files, acceptance results, SBOM, attestation, run state
```

## Frontend

- Framework: no framework; static HTML/CSS/JavaScript.
- Entry points: `web/index.html`, `web/style.css`, `web/app.js`.
- Browser-mode backend: `web/ops_browser.js`, `web/fabengine.js`, `web/fabcrypto.js`, `web/forgepush.js`.
- Server delivery: files are embedded into `src/server.rs` with `include_str!`.
- Routing: single-page UI; API calls target `/api/*` in server mode and browser shims in browser mode.
- State: in-memory state in `web/app.js`; browser-mode persistence uses IndexedDB/localStorage.
- Styling: custom CSS variables and responsive CSS grid.
- Major screens: intent builder, live workflow, product/provenance inspector, draft/promote panel, approval panel, settings drawer.

## Backend

- Framework: Rust binary using `tiny_http`.
- API: implemented in `src/server.rs`.
- CLI: implemented in `src/cli.rs` with `clap`.
- Shared services: `src/ops.rs`.
- Orchestration: `src/spec_cycle.rs`.
- Persistence: `.openfab/runs`, `.openfab/allow`, `.openfab/identity`, `.openfab/maintainers` under the selected repo/workspace.
- Authentication: no application-login system. Trust identity is local `did:key` signing for fab and maintainers.
- Authorization/trust: `src/core/trust.rs`, `policy/trust.json`, `policy/trust.rego`.
- Database: none.
- Background jobs: run/feedback/promote operations spawn background threads in `src/server.rs`.

## Integrations

- Agent bases: Claude CLI, Codex CLI, AgentScope, HiClaw, agent-chat, OpenHands.
- LLM providers: Claude/Codex CLIs, OpenAI, Groq, Ollama-compatible endpoint, DashScope/Qwen.
- Forges: local git, GitHub via `gh`, Forgejo/Gitea/GitCode via REST + git.
- Static deployment: GitHub Pages workflow for `web/`.

## Do Not Touch Map

These areas are core behavior and were intentionally preserved:

- `src/core/*`: spec parsing, identity, provenance, SBOM, trust, conformance, reputation.
- `src/ports/*`: `BasePort` and `ForgePort` contracts.
- `src/adapters/*`: LLM, base, forge, and sandbox behavior.
- `src/ops.rs`: shared operation semantics and API response shapes.
- `src/spec_cycle.rs`: generation, acceptance, signing, provenance, and gate flow.
- `src/runstate.rs`: run-state schema and persistence paths.
- `schemas/*`: external schema contracts.
- `policy/*`: trust policy behavior.
- `specs/*`: sample/build specs.
- Environment variable names consumed by code.
- `openfab/generation` predicate identifiers and `OpenFab-*` commit trailers.

## Historical Baseline Validation

Attempted commands:

```text
cargo fmt --all -- --check
cargo clippy --all-targets --all-features -- -D warnings
cargo test
cargo build --release
```

Result: the initial audit shell did not have `cargo` on PATH. The installed stable GNU
toolchain was later invoked explicitly through `$HOME/.cargo/bin/cargo.exe`.

## Deployment Notes

- `.env.example` documents runtime configuration without secrets.
- `.gitignore` excludes `.env`, `.env.*`, `*.env`, and runtime signing seed directories.
- The GitHub Pages automation template no longer writes the previous custom-domain CNAME. It is stored outside the active workflow directory until the target GitHub credential has workflow scope.
- The CI automation is prepared as `.github/ci-workflow.yml` and remains outside the active workflow directory until the GitHub credential has `workflow` scope.
- No live deployment was performed because no deployment access or account authorization was provided.
- Server deployment preparation now includes an opt-in `serve --host` flag that preserves
  loopback binding by default, plus a non-root multi-stage `Dockerfile` with a healthcheck.

## Post-change Validation

- `cargo +stable-x86_64-pc-windows-gnu fmt --all -- --check` passed.
- `cargo +stable-x86_64-pc-windows-gnu clippy --all-targets --all-features -- -D warnings` passed.
- `cargo +stable-x86_64-pc-windows-gnu test` passed: 58 tests.
- `cargo +stable-x86_64-pc-windows-gnu build --release` passed.
- The release server returned HTTP 200 for `/`, `/api/bases`, and `/api/forges` in an isolated smoke workspace.
- The release server returned HTTP 200 and `{"status":"ok"}` for `/health` in an isolated smoke workspace.
- Node syntax checks passed for all five browser JavaScript modules.
- Python syntax checks passed for the AgentScope and HiClaw adapters.
- The intent builder includes responsive starter workflow patterns for triage, recurring reports, and release readiness.
- The offline fixture passed: three acceptance checks, signed provenance, SBOM output, and `verify-file` all completed without provider credentials.
- The multi-stage Docker image built successfully and its isolated container smoke test returned
  `/health` with HTTP 200, reached Docker `healthy`, and ran as the non-root `flowforge` user.
- A fresh visual screenshot of the modified UI remains unverified because no browser-control surface was available in the execution environment.
