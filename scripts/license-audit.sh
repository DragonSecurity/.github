#!/usr/bin/env bash
#
# Audit every repository in the organization for a canonical Apache-2.0
# LICENSE file. Writes a markdown report to stdout and exits non-zero if
# any repository is missing a license or carries modified license text.
#
# Requires: gh (authenticated), python3.
# Usage: ORG=DragonSecurity ./scripts/license-audit.sh
set -uo pipefail

ORG="${ORG:-DragonSecurity}"
REFERENCE="${REFERENCE:-templates/LICENSE.apache2}"

if [ ! -f "$REFERENCE" ]; then
  echo "reference license not found: $REFERENCE" >&2
  exit 2
fi

missing=(); modified=(); ok=()

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

# Compare ignoring only trailing-whitespace/newline differences. Command
# substitution would eat the trailing newline, so bodies go straight to
# a file and both sides are normalised identically.
normalise() {
  python3 -c 'import sys; sys.stdout.write(open(sys.argv[1],"rb").read().decode("utf-8","replace").rstrip()+"\n")' "$1"
}

# --archived is excluded: archived repos are read-only and can't be fixed.
repos=$(gh repo list "$ORG" --limit 1000 --no-archived --json name --jq '.[].name' | sort)
if [ -z "$repos" ]; then
  echo "no repositories returned for org '$ORG' — check token scope" >&2
  exit 2
fi

for r in $repos; do
  found=""
  for f in LICENSE LICENSE.md LICENSE.txt; do
    gh api "repos/$ORG/$r/contents/$f" --jq '.content' 2>/dev/null \
      | base64 -d > "$tmp/body" 2>/dev/null || continue
    [ -s "$tmp/body" ] || continue
    found="$f"; break
  done

  if [ -z "$found" ]; then
    missing+=("$r"); continue
  fi

  if diff <(normalise "$tmp/body") <(normalise "$REFERENCE") >/dev/null 2>&1; then
    ok+=("$r/$found")
  else
    modified+=("$r/$found")
  fi
done

total=$(( ${#ok[@]} + ${#missing[@]} + ${#modified[@]} ))

echo "# License audit — \`$ORG\`"
echo
echo "| Result | Count |"
echo "| --- | --- |"
echo "| Canonical Apache-2.0 | ${#ok[@]} |"
echo "| Missing a license | ${#missing[@]} |"
echo "| Modified license text | ${#modified[@]} |"
echo "| **Total audited** | **$total** |"
echo

if [ ${#missing[@]} -gt 0 ]; then
  echo "## Missing a license"
  echo
  for r in "${missing[@]}"; do echo "- [\`$r\`](https://github.com/$ORG/$r)"; done
  echo
  echo "Add one by copying \`templates/LICENSE.apache2\` from this repository to \`LICENSE\`."
  echo
fi

if [ ${#modified[@]} -gt 0 ]; then
  echo "## Modified license text"
  echo
  echo "These differ from the canonical Apache-2.0. The license text must not be"
  echo "edited — only the appendix copyright line is meant to be filled in, and"
  echo "the reference file already has it."
  echo
  for r in "${modified[@]}"; do
    repo="${r%%/*}"; file="${r##*/}"
    echo "- [\`$repo/$file\`](https://github.com/$ORG/$repo/blob/HEAD/$file)"
  done
  echo
fi

if [ ${#missing[@]} -eq 0 ] && [ ${#modified[@]} -eq 0 ]; then
  echo "All $total repositories carry the canonical Apache-2.0 license. ✅"
  exit 0
fi

exit 1
