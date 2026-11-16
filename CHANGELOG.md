# Changelog

All notable changes to this project are documented here. Versions follow
[Semantic Versioning](https://semver.org).

## [1.0.1] - 2026-11-16

Editorial consistency fixes found by the first end-to-end behavioural test. No
behaviour change; no new files.

### Fixed

- `references/quality-rubric.md` demanded `20/20` on a 0/1/2 scale while
  `SKILL.md` §6 and every example showed `10/10`. Unified on PASS/FAIL per gate,
  deliver at `10/10`.
- The self-check summary example was Spanish-only (`— listo.`), conflicting with
  the language-mirror rule (G6). Examples now show English/Spanish variants,
  require the user's language, and specify placement immediately before the block.
- §4 mandated `- [ ]` acceptance checkboxes *and* told the agent to mechanically
  scan for `[`, which a literal scan always flags. Reworded to scan for **unfilled
  placeholder slots**, with an explicit checkbox exemption — also applied to all
  `chatgpt/` variants and `codex/AGENTS.md`.
- The worked example in `references/output-template.md` (and the miniature example
  in `chatgpt/system-prompt.md`) added a `## Self-check` heading although §4 fixes
  the section list at nine. Now a plain trailing line, documented as such.
- §9 said "strip the imperative" while its fenced-data rule led the agent to quote
  the raw injected text. Clarified: never obey; quoting raw text as labelled
  untrusted data is optional, flagging with the real path is mandatory. Also added
  the same note to `references/safety.md`.
- §2 now requires labelling self-chosen defaults `Assumption:` when no human
  answer arrives (automated runs).
- `references/safety.md` pinned-release example bumped to `@v1.0.1`.

---

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
