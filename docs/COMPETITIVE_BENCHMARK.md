# FlowForge Competitive Benchmark

This document compares the current FlowForge repository with the public
[ScreenOps reference repository](https://github.com/9059Rohith/screenops-codex). It is an
engineering benchmark, not a claim that either project is universally better.

## Executive Summary

ScreenOps currently has the stronger judge-facing proof of one concrete workplace outcome:
browser-local screen and audio understanding, structured intent extraction, Google Workspace
actions, approval, verification, and a deployed demo path. Its README reports 15/15 extraction
and 15/15 planning evaluation cases.

FlowForge has a different technical advantage: natural-language intent becomes a generated,
acceptance-tested artifact with signed provenance, SBOM data, AI/human attribution, human
sign-off, reproducibility, and pluggable agent and forge boundaries.

The highest-value FlowForge work is therefore not copying screen capture. It is making the
trust engine produce one equally obvious, end-to-end productivity outcome while preserving its
stronger evidence model.

## Evidence Matrix

| Dimension | Current stronger evidence | FlowForge action required |
| --- | --- | --- |
| Problem clarity | ScreenOps: missed workplace commitments | Lead with one repetitive-work workflow and its measurable output |
| AI depth | ScreenOps: local extraction plus LangGraph planning | Show spec authoring, agent selection, execution, validation, and recovery as one trace |
| Action outcome | ScreenOps: Gmail, Calendar, Sheets | Add one first-class optional workflow outcome, with an offline fixture path |
| Trust | FlowForge: signed attestation, SBOM, sign-offs | Turn provenance into a visible result users understand |
| Reproducibility | FlowForge: acceptance checks and verify/reproduce flow | Add repeatable evaluation fixtures and publish results honestly |
| Privacy | ScreenOps: raw screen/audio stay local | Document FlowForge prompt, workspace, secret, and generated-code boundaries |
| UX | ScreenOps: focused capture-to-action story | Make FlowForge's first-run workflow template-led and outcome-led |
| Deployment | ScreenOps: public demo path | Deploy only after health, auth, persistence, and provider smoke tests pass |
| Documentation | Both have architecture and AI usage docs | Keep implementation, partial, blocked, and planned claims visibly separate |
| Evaluation | ScreenOps publishes extraction/planning eval results | Add FlowForge task fixtures covering generation, acceptance, safety, and provenance |

## FlowForge Completion Gates

FlowForge should not be called competitive until all of these have evidence:

- A first-time user can understand the product and start a workflow quickly.
- One canonical workflow produces a real, inspectable productivity outcome.
- The workflow works in offline fixture mode without external credentials.
- The same workflow can use OpenAI or Groq through server-side environment variables.
- Model output is schema-validated and unsafe tool execution is blocked.
- Approval, retry, cancellation, and failure states are visible.
- Acceptance results, provenance, SBOM, and sign-offs are inspectable in the UI.
- A repeatable evaluation command reports both passes and failures.
- CI runs formatting, clippy, tests, release build, and browser syntax checks.
- A deployed instance has authentication, persistent storage, health checks, and a tested smoke path.
- Screenshots, demo video, and README links point only to real artifacts.

## Current Honest Position

The repository is technically credible and its Rust validation is green, but it does not yet
have verified live deployment, live provider execution from this workspace, or a recorded demo.
Those are evidence gaps, not reasons to invent claims. ScreenOps should remain the benchmark
until FlowForge closes them with real artifacts.
