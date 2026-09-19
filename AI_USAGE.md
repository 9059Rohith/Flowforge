# FlowForge AI Usage

## Where AI is used

FlowForge uses AI in two product roles:

1. **Spec author:** converts a natural-language request into a structured spec, assumptions, and machine-checkable acceptance criteria.
2. **Base generator:** creates or refines the requested files through a selected agent base.

The acceptance and provenance stages are deterministic application logic. They do not ask a model to declare its own output safe.

## Supported runtime paths

- Claude CLI and Codex CLI can provide native local bases when installed and authenticated.
- AgentScope, HiClaw, agent-chat, and OpenHands can be used through their configured adapters.
- Ollama-compatible and DashScope/Qwen paths can provide LLM-backed generation where configured.
- Browser mode uses a user-selected OpenAI-compatible provider from the page and keeps the key in browser storage.

The exact provider and model are recorded in run metadata when available. Configuration is supplied through environment variables or explicit browser settings; credentials are not part of the repository.

The Codex adapter runs `codex exec` with a read-only sandbox and no approval prompts by default. `workspace-write` is an explicit configuration choice. `danger-full-access` is rejected unless `OPENFAB_CODEX_ALLOW_DANGEROUS=1` is also set, and should only be used inside a separately isolated environment.

## Prompt and context handling

The agent guidance file is [`web/openfab-agent.md`](web/openfab-agent.md). The server embeds it and browser mode can load it as the shipped guidance baseline. Browser users may override guidance in settings; those overrides are local to the browser.

The release attestation stores a prompt hash and model metadata rather than the full prompt. This supports attribution without putting private prompt content into a portable artifact.

## Validation and human oversight

The flow is:

```text
intent -> model-authored spec -> generated files -> deterministic checks
       -> artifact digests -> signatures -> human gate -> reproduction
```

Draft mode is intended for iteration. Release mode adds the signing, SBOM, and approval ceremony. A human can inspect the generated product, request refinement, reject a run, or sign it according to policy.

## Failure handling

- Unavailable bases are surfaced as unavailable unless explicit bridging is allowed.
- Provider errors and malformed model output are returned as failed operations.
- Acceptance failures remain visible and prevent a release from being represented as accepted.
- Run events and status are persisted so the UI can show progress and failure context.
- Reproduction rechecks signatures, source hashes, and the frozen acceptance contract.

## Limitations

- LLM generation is not bit-for-bit reproducible.
- The acceptance contract covers only the behavior it exercises.
- The current server fallback is a policy-gated host subprocess, not container isolation.
- Provider quality, model availability, and external forge behavior are outside FlowForge's trust root.
- No claim of universal correctness or autonomous safe execution is made.

## Development use of AI

AI assistance was used for repository inspection, documentation, UI iteration, and validation planning in this workspace. No external benchmark, user metric, or test result is claimed without local evidence.
