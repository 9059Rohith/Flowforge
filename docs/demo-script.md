# FlowForge Demo Script

## Recording status

This is a prepared script. No video has been recorded in this workspace and no video URL is claimed.

## Target length

Approximately 3 minutes, using the local browser UI with a preconfigured provider or a recorded run already present in the workspace.

## Shot list and narration

### 0:00-0:20 - The problem

Show the FlowForge home screen.

Narration: "AI can generate a useful tool quickly, but teams still need to know what was generated, whether it passed the intended checks, and who approved the exact result. FlowForge turns that handoff into a visible, reviewable workflow."

### 0:20-0:45 - The product

Point to the intent field, base selector, mode selector, and approval policy.

Narration: "I describe the repetitive task in plain language, choose an agent base and release policy, and let FlowForge author both the implementation request and the acceptance contract."

### 0:45-1:35 - Generate and verify

Choose the "Triage repetitive requests" starter and submit a deterministic request queue tool. Show the Spec, Generate, and Verify steps as the timeline advances, then run the generated tool to reveal its prioritized action queue.

Narration: "The same operation layer serves the browser and CLI. The model generates the files, then the acceptance commands run through the configured policy gate. A failed check stays visible and cannot be presented as a successful release."

### 1:35-2:05 - Inspect the result

Open the product panel, run the generated app, and show the artifact tree.

Narration: "Before approval, I can run or inspect the generated product and review the artifacts that will travel with it. This keeps the workflow grounded in an outcome, not just a model response."

### 2:05-2:35 - Sign and gate

Show the approval panel, maintainer identity, gate policy, provenance, and SBOM.

Narration: "Release mode records the generated file digests, model metadata, prompt hash, acceptance result, SBOM, and local maintainer signatures. The gate is explicit, and the evidence is committed with the artifact."

### 2:35-3:00 - Reproduce

Click reproduce and show the verification result.

Narration: "Finally, FlowForge rechecks the signatures, hashes the source, and reruns the frozen acceptance contract. The forge is transport; the proof remains portable with the repository."

## Fallback path

If the configured provider is unavailable, use a previously completed local run or show the browser UI, the static capability notice, the artifact explorer, and the verification documentation. Do not simulate a passing run or claim that an unverified integration worked.

For a credential-free engineering fallback, run `powershell -ExecutionPolicy Bypass -File .\evals\run_offline_fixture.ps1` and show the real acceptance, signed provenance, SBOM, and `verify-file` output. Label this as the deterministic evidence fixture, not as provider-backed AI generation.

## Recording checklist

- Use a clean browser window with no personal tabs.
- Configure the provider before recording and never show the key field after entry.
- Use a small task with deterministic acceptance checks.
- Keep the timeline and gate panel readable at 1280px or wider.
- Capture the mobile screenshot separately; do not resize the live demo below its usable width.
