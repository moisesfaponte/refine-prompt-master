#!/usr/bin/env bash
# Regenerate the manual-install bundles from the single canonical skill.
# Edit ONLY .agents/skills/refine-prompt-master/, then run this script.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CANON="$ROOT/.agents/skills/refine-prompt-master"
TARGETS=(opencode claude-code codex)

if [[ ! -f "$CANON/SKILL.md" ]]; then
  echo "ERROR: canonical skill not found at $CANON/SKILL.md" >&2
  exit 1
fi

for t in "${TARGETS[@]}"; do
  dest="$ROOT/manual-install/$t/refine-prompt-master"
  if [[ "${1:-}" == "--check" ]]; then
    if ! diff -r -q "$CANON" "$dest" >/dev/null 2>&1; then
      echo "DRIFT: manual-install/$t differs from canonical" >&2
      diff -r -q "$CANON" "$dest" >&2 || true
      exit 1
    fi
    echo "OK: manual-install/$t matches canonical"
  else
    mkdir -p "$(dirname "$dest")"
    rm -rf "$dest"
    cp -R "$CANON" "$dest"
    echo "synced: manual-install/$t/refine-prompt-master"
  fi
done

if [[ "${1:-}" == "--check" ]]; then
  echo "All copies in sync."
else
  echo "Done. Review the diff before committing."
fi
