# Contributing to DragonSecurity projects

This is the organization-wide default. Individual repositories may add
their own `CONTRIBUTING.md` covering toolchain setup and test commands —
when they do, that file wins and this one describes only the parts that
apply everywhere.

## Developer Certificate of Origin

Every commit merged into a DragonSecurity repository must carry a
`Signed-off-by` trailer. There is no CLA to sign and no account to
create; the trailer *is* the agreement.

Signing off certifies that you wrote the patch, or otherwise have the
right to submit it under the repository's license. The full text is the
[Developer Certificate of Origin 1.1](https://developercertificate.org/),
reproduced at the bottom of this file.

Add the trailer with `-s`:

```sh
git commit -s -m "fix(scan): handle empty CVE feed"
```

which appends:

```
Signed-off-by: Your Name <your.email@example.com>
```

The name and email must match your `user.name` / `user.email`, and the
email must be one attached to your GitHub account. Anonymous or
`noreply` addresses will fail the check.

A **DCO** status check runs on every pull request and blocks the merge
until all commits in the branch are signed off.

### Signing off automatically

Git has no `commit.signoff` config, so use a hook. To apply it to every
repository you clone:

```sh
mkdir -p ~/.git-hooks
cat > ~/.git-hooks/prepare-commit-msg <<'EOF'
#!/bin/sh
# Append a Signed-off-by trailer unless one is already present.
NAME=$(git config user.name)
EMAIL=$(git config user.email)
TRAILER="Signed-off-by: $NAME <$EMAIL>"
grep -qF -- "$TRAILER" "$1" || printf '\n%s\n' "$TRAILER" >> "$1"
EOF
chmod +x ~/.git-hooks/prepare-commit-msg
git config --global core.hooksPath ~/.git-hooks
```

Note that `core.hooksPath` is global — if a repository ships its own
hooks (`flightdm` uses `.githooks/`), set `core.hooksPath` locally in
that clone instead and copy this hook alongside the repo's own.

### Fixing a branch you forgot to sign

For the most recent commit:

```sh
git commit --amend -s --no-edit && git push --force-with-lease
```

For every commit on the branch:

```sh
git rebase --signoff main && git push --force-with-lease
```

Always `--force-with-lease` rather than `--force`; it refuses to
overwrite work you haven't seen.

## Pull requests

- Branch from `main`. Naming: `<type>/<short-slug>`, e.g. `feat/cve-refresh-tuning`.
- Rebase onto `main` before opening the PR — squash merges keep the log linear.
- Commit messages follow [Conventional Commits](https://www.conventionalcommits.org/):
  `feat`, `fix`, `chore`, `test`, `ci`, `docs`, `refactor`. Subject under 72 chars.
- Explain the *why* in the body. The diff already shows the *what*.
- CI must be green and the DCO check must pass.

## Dependency updates

Renovate manages dependency bumps org-wide from the shared preset in
[`DragonSecurity/renovate-presets`](https://github.com/DragonSecurity/renovate-presets).
Its commits are signed off automatically. Please don't open manual
version-bump PRs — adjust the preset instead so the change applies
everywhere.

## Security issues

Do not open a public issue for a vulnerability. See [SECURITY.md](SECURITY.md).

---

## Developer Certificate of Origin 1.1

```
By making a contribution to this project, I certify that:

(a) The contribution was created in whole or in part by me and I
    have the right to submit it under the open source license
    indicated in the file; or

(b) The contribution is based upon previous work that, to the best
    of my knowledge, is covered under an appropriate open source
    license and I have the right under that license to submit that
    work with modifications, whether created in whole or in part
    by me, under the same open source license (unless I am
    permitted to submit under a different license), as indicated
    in the file; or

(c) The contribution was provided directly to me by some other
    person who certified (a), (b) or (c) and I have not modified
    it.

(d) I understand and agree that this project and the contribution
    are public and that a record of the contribution (including all
    personal information I submit with it, including my sign-off) is
    maintained indefinitely and may be redistributed consistent with
    this project or the open source license(s) involved.
```
