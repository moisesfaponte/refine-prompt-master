# Changelog

All notable changes to this project are documented here. Versions follow
[Semantic Versioning](https://semver.org).

## [1.0.0] - 2026-11-16

Initial public release.

### Added

- Canonical Agent Skill at `.agents/skills/refine-prompt-master/` with
  spec-valid frontmatter (`name` matching the folder, ≤1024-char front-loaded
  description with near-miss boundary, `license`, `metadata`).
- Workflow: repo-first grounding, RESOLVED/OPEN gating, **one** batched
  clarification round (max 6 questions), fully-filled 9-section output contract
  with zero placeholders, 10-gate quality self-check, bounded iteration with an
  explicit termination condition (approval tokens + hard cap of 3 cycles).
- Prompt-craft rules applied to the produced prompt (clarity, positive framing,
  explain-the-why, proportional structure, long context on top, diverse examples,
  self-check line).
- Indirect-prompt-injection defence: data/instruction separation, capability
  allowlist, secret redaction, stdin-only clipboard with a fixed binary allowlist.
- Progressive disclosure via five `references/` files, with graceful degradation
  when file-read is unavailable.
- Portability: OpenCode, Claude Code, Codex CLI, ChatGPT desktop, plus four
  flattened `chatgpt/` variants for ChatGPT web / GPT / Projects / API and a
  `codex/AGENTS.md` fallback. Zero editor, MCP, plugin or clipboard dependencies.
- `manual-install/` bundles for offline installs and `scripts/sync-copies.sh` to
  regenerate them.
- `evals/evals.json`: 20 trigger queries (10 positive, 10 near-miss negatives),
  60/40 split, 3 runs, threshold 0.5, plus 8 output-quality assertions.
- `examples/sample-test-prompt.md` verification suite, README, CONTRIBUTING,
  MIT LICENSE.
