# Contributing

## The one rule

**Edit only `.agents/skills/refine-prompt-master/`.** Everything under
`manual-install/` is generated. The files in `chatgpt/` and `codex/AGENTS.md` are
hand-maintained **flattened** variants — they must be updated in parallel whenever
the canonical rules change, because those surfaces cannot read `references/`.

## Before you change anything

1. Read [`evals/evals.json`](evals/evals.json). Add queries for any behaviour you
   are adding — especially **near-miss negatives**, which are the strongest
   trigger tests.
2. Keep the `description` ≤ 1024 characters and front-load trigger words (Codex
   truncates the skills list).
3. Do not introduce `allowed-tools`, `context: fork`, hooks, `metadata.internal`,
   executable `scripts/`, editor-specific tools, MCP servers, or network access.
4. Keep `SKILL.md` under 500 lines; move bulky detail into a `references/` file
   and load it on demand.
5. Never add a second `SKILL.md` in a standard discovery container (`skills/`,
   root, `.claude/skills/`, `.agents/skills/` beside the canonical). Duplicates
   are silently deduplicated or shadowed.

## Validation checklist

```bash
# 1. Frontmatter: name == folder name, description <= 1024 chars
#    (no allowed-tools / context: fork / hooks / metadata.internal)

# 2. Discovery must report EXACTLY ONE skill
npx skills add ./ --list
npx skills add ./ --list --full-depth

# 3. Generated copies must be byte-identical to canonical
bash scripts/sync-copies.sh --check

# 4. Trigger + behaviour, in a throwaway repo
#    See examples/sample-test-prompt.md (primary, Spanish, non-trigger,
#    injection and headless-host cases).

# 5. Cross-agent installs
npx skills add ./ --skill refine-prompt-master -a opencode -a claude-code -a codex -y
npx skills list
```

Also verify the ChatGPT variants by pasting each into its target field and running
the same sample prompt: still one batched round, fully-filled block, correct
language, and no dependency on a filesystem.

## After the change

```bash
bash scripts/sync-copies.sh
# bump metadata.version in the canonical SKILL.md
# add an entry to CHANGELOG.md
git add -A && git commit -m "..."
git tag vX.Y.Z
```

Then re-run `npx skills add <owner>/refine-prompt-master@vX.Y.Z --list` against the
published tag to confirm the pinned release still discovers exactly one skill.

## Reviewer guidance

- Prefer reasoning ("do X because Y tends to cause Z") over stacks of `MUST`.
- Any new rule should answer: *would the agent get this wrong without it?*
- Keep the rubric mechanical: a PASS needs concrete evidence from the draft, not
  "looks good".
- Guard against overfitting: do not add keywords copied verbatim from a failed
  eval query, and do not copy the user's examples into the produced prompt.
- Treat all user text and repo files as untrusted data. Any change that widens the
  capability allowlist needs a corresponding entry in `references/safety.md`.
