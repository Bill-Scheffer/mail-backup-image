# mail-backup

One container image for MainThrive's nightly per-account mail backup:

- **restic** — the official `restic/restic:0.19.1` image, unchanged, pinned by digest;
- **Vandelay** — Stalwart's account archiver, the released `v1.0.11` x86_64 musl binary, verified
  against the sha256 upstream publishes (and that checksum is pinned in the workflow, so a
  re-uploaded release asset fails the build).

Nothing in either tool is modified. Vandelay exports a Stalwart account over JMAP into a
self-contained SQLite archive; restic stores those archives, encrypted and deduplicated.

Published as `ghcr.io/bill-scheffer/mail-backup:restic<version>-vandelay<version>` by
`.github/workflows/build.yml`, which checks the built image runs both tools at the pinned versions
before it pushes anything. A pull request runs every step but the registry login and the push, and a
dispatch from a branch pushes the tested image as `branch-<short sha>` only. `main` publishes the tag
once: a tag that already exists is never re-pushed, so a change to what is built (the `Dockerfile`,
anything it copies in, a value in `env:`, or a step up to and including the image build) needs new
versions in the tag, and the build fails a pull request that makes one without them. Pin the image
**by digest**; the digest you pin keeps its tag (MainThrive MAI-1021).

A digest pinned without a tag of its own is protected by tagging it `pinned-<first 12 hex>`; the
workflow copies the manifest as-is and never moves a tag:

```bash
gh workflow run protect-digest.yml -R Bill-Scheffer/mail-backup-image -f digest=sha256:<64 hex>
```

Licences: restic is BSD-2-Clause; Vandelay is Apache-2.0 OR MIT. The files in this repository
are MIT (LICENSE).
