# mail-backup

One container image for MainThrive's nightly per-account mail backup:

- **restic** — the official `restic/restic:0.19.1` image, unchanged, pinned by digest;
- **Vandelay** — Stalwart's account archiver, the released `v1.0.11` x86_64 musl binary, verified
  against the sha256 upstream publishes (and that checksum is pinned in the workflow, so a
  re-uploaded release asset fails the build).

Nothing in either tool is modified. Vandelay exports a Stalwart account over JMAP into a
self-contained SQLite archive; restic stores those archives, encrypted and deduplicated.

Published as `ghcr.io/bill-scheffer/mail-backup:restic<version>-vandelay<version>` by
`.github/workflows/build.yml`, which also checks the pushed image runs both tools at the pinned
versions.

Licences: restic is BSD-2-Clause; Vandelay is Apache-2.0 OR MIT. The files in this repository
are MIT (LICENSE).
