# Hackathon Alignment

## Track

Next-Gen Productivity and Automation.

## Factual mapping

| Track need | FlowForge capability | Evidence |
| --- | --- | --- |
| Automate repetitive work | Plain-language intent becomes a generated utility or workflow | `web/index.html`, `src/spec_cycle.rs` |
| Streamline workflows | One flow covers authoring, generation, checks, release, and verification | `src/ops.rs`, `src/server.rs`, `src/cli.rs` |
| Delegate work to agents | BasePort supports swappable native and bridged agent runtimes | `src/ports/base.rs`, `src/adapters/` |
| Organize information | Specs, events, artifacts, SBOMs, attestations, and run state are structured | `src/runstate.rs`, `src/core/` |
| Make execution understandable | Live timeline, spec review, artifact explorer, and gate inspection are visible in the UI | `web/app.js`, `web/index.html` |
| Improve reliability | Acceptance checks, policy gates, signatures, and reproduction are part of the release path | `src/spec_cycle.rs`, `src/core/trust.rs` |
| Preserve team control | Maintainer identities and N-of-M sign-off policies are explicit | `src/core/identity.rs`, `src/core/trust.rs` |

## Product narrative

FlowForge focuses on the handoff where AI-generated work becomes a reusable team artifact. The productivity gain is not an invented percentage; it is the reduction of repeated manual steps needed to describe, generate, check, approve, and later verify a small tool or workflow.

## What makes it distinct

The project is designed around portable trust evidence. A forge can host the result, but the signed attestation, SBOM, acceptance contract, and source digests travel with the repository. This is the central distinction from an ordinary agent chat or one-off code generation flow.

## Reviewer risks and honest responses

- **Risk:** server mode is not yet a remote multi-tenant service. **Response:** it is documented as a local-first binary and requires an external authentication boundary before remote exposure.
- **Risk:** the fallback sandbox is not container isolation. **Response:** provenance records the actual `gated-host-subprocess` runtime and the roadmap names container isolation as unfinished.
- **Risk:** there is no live demo in this workspace. **Response:** the README does not claim one; the local demo path and recording script are prepared.
- **Risk:** the Rust toolchain is unavailable in this environment. **Response:** the exact blocked commands are documented rather than presented as passing.

## Benchmark comparison

The referenced ScreenOps repository sets a strong benchmark for submission storytelling: it exposes a clear problem statement, explicit AI usage, screenshots, deployment information, and repeatable extraction/planning evals. FlowForge should meet that documentation standard while standing on its own product axis: signed, forge-portable evidence for generated software and workflows.

This comparison is directional and evidence-based. It does not claim that FlowForge has ScreenOps capabilities such as browser-local screen capture, Google Workspace actions, LangGraph execution, or its published eval counts.
