# .github

Organization-wide default community health files for
[DragonSecurity](https://github.com/DragonSecurity).

GitHub falls back to the files here for any repository in the
organization that does not ship its own copy. A repository's own file
always wins.

| File | Applies to |
| --- | --- |
| [`CONTRIBUTING.md`](CONTRIBUTING.md) | Contribution process, and the DCO sign-off requirement |
| [`CODE_OF_CONDUCT.md`](CODE_OF_CONDUCT.md) | Contributor Covenant 2.1 |
| [`SECURITY.md`](SECURITY.md) | Vulnerability reporting and disclosure |
| [`.github/PULL_REQUEST_TEMPLATE.md`](.github/PULL_REQUEST_TEMPLATE.md) | Default PR template |

Licensing is not a community health file — GitHub cannot apply one
org-wide, so each repository carries its own copy.

| File | Purpose |
| --- | --- |
| [`templates/LICENSE.apache2`](templates/LICENSE.apache2) | Canonical Apache-2.0. Copy to `LICENSE` in new repositories |
| [`scripts/license-audit.sh`](scripts/license-audit.sh) | Checks every repo for that exact text |
| [`.github/workflows/license-audit.yml`](.github/workflows/license-audit.yml) | Runs the audit weekly, opens an issue on drift |

The audit needs an `ORG_AUDIT_TOKEN` Actions secret with read access to
all organization repositories — the default `GITHUB_TOKEN` is scoped to
this repository alone and cannot see the private ones.

This repository is public because GitHub only applies default community
health files from a public `.github` repository. It contains no code and
nothing sensitive.

## Sign-off

Contributions across the organization are certified under the
[Developer Certificate of Origin](https://developercertificate.org/)
rather than a CLA. Commit with `-s`:

```sh
git commit -s -m "docs: fix a typo"
```

A `DCO` status check enforces this on the default branch of every
repository. See [CONTRIBUTING.md](CONTRIBUTING.md) for automation and
for how to repair a branch you forgot to sign.
