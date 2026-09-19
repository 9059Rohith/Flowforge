# FlowForge Agent Architecture

## Real execution path

```text
User intent
    |
    v
FlowForge spec author
    |
    v
TaskCard with acceptance contract
    |
    +--> Claude CLI
    +--> Codex CLI (`codex exec`)
    +--> AgentScope / HiClaw / agent-chat / OpenHands
    +--> Ollama or DashScope bridge
    |
    v
JSON file manifest
    |
    v
Policy-gated acceptance checks
    |
    v
SBOM + signed provenance + human gate
    |
    v
Reproduction and portable verification
```

## Codex evidence in source

- [`src/adapters/base_claude.rs`](../src/adapters/base_claude.rs) exposes `CliKind::Codex` through the shared `BasePort` implementation.
- [`src/adapters/llm_backend.rs`](../src/adapters/llm_backend.rs) invokes `codex exec`, captures the final response, and parses the JSON manifest.
- [`src/adapters/registry.rs`](../src/adapters/registry.rs) advertises the Codex base and probes whether the local CLI is connected.
- [`src/core/provenance.rs`](../src/core/provenance.rs) records the provider, model, agent identity, and optional tool list in the attestation.

## Permission boundary

Codex generation defaults to read-only sandbox execution. FlowForge itself writes the parsed manifest into the target workspace, then runs acceptance through its own policy gate. Workspace-write and danger-full-access Codex modes are explicit configuration choices, not silent defaults.

## Human control

The model cannot sign its own release. Draft mode is available for iteration; release mode requires the configured trust policy and maintainer identities before the result is represented as accepted.
