# restic, plus Stalwart's Vandelay: the image MainThrive's nightly per-account mail backup runs in.
# restic's own image (Alpine, with jq and BusyBox wget) is the base. Two additions: the Vandelay binary, verified
# against the checksum upstream publishes for the release, and Alpine's sqlite3 CLI, which the backup uses to VACUUM
# each archive after its import so a deleted message's bytes do not stay in the file's free pages (MainThrive MAI-1348).
ARG RESTIC_IMAGE
FROM ${RESTIC_IMAGE}
ARG VANDELAY_VERSION
ARG VANDELAY_SHA256
RUN set -eu; \
    wget -qO /tmp/v.tgz "https://github.com/stalwartlabs/vandelay/releases/download/v${VANDELAY_VERSION}/vandelay-x86_64-unknown-linux-musl.tar.gz"; \
    echo "${VANDELAY_SHA256}  /tmp/v.tgz" | sha256sum -c -; \
    tar -xzf /tmp/v.tgz -C /tmp; \
    install -m 0755 /tmp/vandelay-x86_64-unknown-linux-musl/vandelay /usr/local/bin/vandelay; \
    rm -rf /tmp/v.tgz /tmp/vandelay-x86_64-unknown-linux-musl
RUN apk add --no-cache sqlite
ENTRYPOINT []
