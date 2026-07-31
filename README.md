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

<!-- dco smoke test -->
