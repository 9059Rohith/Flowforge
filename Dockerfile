# FlowForge server image. Keep the runtime behind authentication and TLS before exposing it.
FROM rust:1.85-bookworm AS builder

WORKDIR /app
COPY Cargo.toml Cargo.lock ./
COPY src ./src
COPY web ./web
COPY policy ./policy

RUN cargo build --release --locked

FROM debian:bookworm-slim

RUN apt-get update \
    && apt-get install --no-install-recommends -y ca-certificates curl git python3 \
    && rm -rf /var/lib/apt/lists/* \
    && useradd --system --create-home --home-dir /var/lib/flowforge flowforge \
    && mkdir -p /app/policy /var/lib/flowforge/workspace \
    && chown -R flowforge:flowforge /app /var/lib/flowforge

COPY --from=builder /app/target/release/openfab /usr/local/bin/openfab
COPY --from=builder /app/policy /app/policy

ENV PORT=8787
WORKDIR /app
USER flowforge
EXPOSE 8787

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD curl --fail --silent "http://127.0.0.1:${PORT:-8787}/health" >/dev/null || exit 1

CMD ["sh", "-c", "exec openfab serve --repo /var/lib/flowforge/workspace --host 0.0.0.0 --port ${PORT:-8787} --policy /app/policy/trust.json"]
