# FlowForge Architecture

## Scope

FlowForge is a Rust 2021 application with two frontends over one operation path:

```text
CLI or browser UI
        |
        v
src/cli.rs or src/server.rs
        |
        v
src/ops.rs
        |
        v
src/spec_cycle.rs
        |
        +--> BasePort  --> native or bridged agent base
        |
        +--> ForgePort --> local git or remote forge adapter
        |
        +--> policy-gated acceptance checks
        |
        v
generated files + run state + SBOM + signed attestation
```

## Components

### User interface

`web/index.html`, `web/app.js`, and `web/style.css` provide the single-page workflow. The UI exposes intent entry, base and forge selection, live events, spec review, product launch, provenance inspection, refinement, sign-off, rejection, and reproduction.

`web/ops_browser.js`, `web/fabengine.js`, `web/fabcrypto.js`, and `web/forgepush.js` provide the static browser path. Browser mode uses IndexedDB and local storage for run records, identities, and provider configuration. It deliberately reports unsupported host capabilities instead of pretending that a static page can run shell commands or local git.

### Server and API

`src/server.rs` is a small blocking `tiny_http` server. It embeds the web files in the release binary, serves the same UI, and exposes JSON routes under `/api/` for bases, forges, maintainers, models, runs, artifacts, verification, audit, sign-off, reproduction, execution, app launch, and refinement.

Long-running generation and feedback work is dispatched to background threads. A shared mutex serializes git-touching operations for a workspace.

### Operations and spec cycle

`src/ops.rs` is the shared service layer. `src/spec_cycle.rs` owns the generation lifecycle:

```text
author spec -> generate -> acceptance -> provenance/SBOM -> sign -> gate -> commit
```

Draft mode stops before the release ceremony. Release mode writes the signed evidence and applies the selected trust policy.

### Core

`src/core/` contains specification parsing, identity, provenance, SBOM generation, trust policy, conformance, reputation, and hashing. Core code does not depend on a specific agent base or forge.

### Ports and adapters

`src/ports/base.rs` defines the agent-base boundary, including generation, collaboration, memory, and sandbox capability calls. `src/ports/forge.rs` defines clone, branch, commit, pull request, provenance, and worktree operations.

Adapters implement those contracts for native CLIs, HTTP bridges, local git, GitHub, Forgejo, Gitea, GitCode, and optional framework integrations.

## Data and Evidence

Run state is stored under the selected workspace's `.openfab/` directory. Release artifacts are committed into the generated repository, including provenance and SBOM files. The attestation binds the generated file digests, acceptance evidence, model metadata, prompt hash, and signatures.

The forge transports the evidence but is not the trust root. Verification reads the committed artifact and rechecks the exact source bytes and frozen checks.

## Deployment Modes

### Browser mode

Publish `web/` to a static host. It supports browser-safe generation, JavaScript acceptance checks in opaque-origin iframes, local signing, artifact download, and optional direct GitHub publishing. It does not provide host shell execution, local git, or the Rust server API.

### Server mode

Run the release binary with a writable workspace. The binary embeds the UI and handles local git, host adapter processes, acceptance commands, generated app launch, and filesystem artifacts. Place an authentication and TLS boundary in front of it before remote exposure.

## Non-Goals and Boundaries

- There is no application database in the current implementation.
- There is no built-in user login or multi-tenant authorization layer.
- The fallback sandbox is a policy-gated host subprocess with a timeout, not a container.
- The LLM does not decide whether its own output is trusted; acceptance checks and human policy do.
- The current architecture intentionally preserves `openfab` protocol and command identifiers.
