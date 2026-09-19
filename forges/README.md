# FlowForge Live-Forge Matrix

This directory provides an optional local Gitea + Forgejo stack for testing live forge adapters instead of the default offline local-git fallback.

| Forge | Host URL | Runtime |
| --- | --- | --- |
| Gitea | `http://localhost:3000` | `gitea/gitea:1.22` |
| Forgejo | `http://localhost:3001` | `codeberg.org/forgejo/forgejo:7.0` |

## Adapter Contract

`src/adapters/forge_rest.rs` covers Gitea, Forgejo, and GitCode. A forge is classified as live only when all three variables are set:

```bash
OPENFAB_<KIND>_URL=<base-url>
OPENFAB_<KIND>_TOKEN=<access-token>
OPENFAB_<KIND>_REPO=<owner/repo>
```

`<KIND>` is uppercased, for example `OPENFAB_GITEA_URL`.

GitHub is live when `OPENFAB_GITHUB_REMOTE=<git-url>` is set and the `gh` CLI is authenticated.

## Plain HTTP Push Support

The REST forge adapter preserves the URL scheme from `OPENFAB_<KIND>_URL`, so local HTTP forges use an HTTP push URL and HTTPS deployments keep HTTPS. Tokens are read from the environment and must not be committed.

## Quick Start

```bash
docker compose up -d

# Provision your local admin/token/repo, then export the variables.
# Keep forges.env gitignored if you create it.
source forges/forges.env

./target/release/openfab serve --repo /tmp/flowforge-runs --port 7800
curl -s localhost:7800/api/forges | python3 -m json.tool
```

## Files

- `docker-compose.yml`: local Gitea and Forgejo services with sqlite storage.
- `forges.env`: optional local-only env file; do not commit it.
- volumes: `gitea-data` and `forgejo-data`.

## Teardown

```bash
cd forges
docker compose down
docker compose down -v
```

## Verification Checklist

- `GET /api/forges` with no env reports local instances.
- `GET /api/forges` with env configured reports those forges as live.
- Gitea and Forgejo health checks pass at `/api/healthz`.
- A test run can create a branch, push, and open a pull request using the configured URL scheme.
