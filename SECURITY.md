# FlowForge Security

## Security posture

FlowForge treats generated output as untrusted until it passes the configured acceptance checks and release policy. The system records evidence about what was generated, what was checked, and which local identities signed the result.

Implemented controls include:

- Environment-based provider and forge credentials.
- Gitignored runtime identity and maintainer seed directories.
- Policy checks before sandbox command execution.
- Hard execution timeouts for acceptance and ad-hoc product commands.
- Process output capture with explicit failure results.
- Component-aware generated-file path validation with canonical workspace containment and symlink rejection.
- Provider model IDs and artifact metadata are rendered through DOM text nodes or escaped markup in the browser UI.
- Opaque-origin sandboxed iframes for browser-authored JavaScript checks.
- Signed attestations over artifact digests.
- N-of-M maintainer policy modes.
- Prompt hashes instead of raw prompt text in the attestation.
- A shared server lock around git-touching operations.
- Codex generation defaults to read-only sandbox execution; broader modes require explicit configuration.

## Important deployment limitation

The current server fallback is labeled `gated-host-subprocess`. It applies command policy and timeouts but does not provide the isolation strength of a container, VM, or gVisor boundary. Do not run untrusted generated code on a shared or internet-exposed host without adding a stronger execution boundary.

The local server also has no built-in application authentication. Keep it on localhost or put it behind an authenticated reverse proxy and TLS.

## Secret handling

Never commit:

- `.env` files
- API keys, tokens, passwords, or database credentials
- private signing seeds
- maintainer identity secrets
- OAuth client secrets
- exported browser storage containing provider credentials

Use [`.env.example`](.env.example) as the configuration template. A credential entered in browser mode remains in browser storage and is sent only to the configured provider or GitHub API path selected by the user.

## AI-specific boundaries

- The selected model can author specs and files, but it cannot bypass the release gate.
- Acceptance commands are checked by policy before execution.
- Acceptance results do not prove total correctness; they prove only the captured contract passed.
- Human sign-off can be required before a release is considered accepted.
- Tool and provider availability should be treated as untrusted external state.
- Codex full-access mode is disabled unless a separate dangerous-mode opt-in is present.

## Reporting a vulnerability

Do not publish credentials or exploit details in a public issue. Once the repository is connected to its maintainer account, use that repository's private security reporting channel. Until then, retain a local reproduction and remove any exposed secrets immediately from the provider or forge account.

## Security review status

Repository scans performed during preparation found no committed API keys, private keys, or known token-shaped secrets. A dedicated dependency audit and runtime penetration test have not been performed; the current verification covers source tests, static checks, secret scanning, and a local server smoke test.
