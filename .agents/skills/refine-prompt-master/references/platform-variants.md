# Platform variants — degrading gracefully

The `SKILL.md` is written for a coding agent with filesystem access. On hosts
without it, the **output contract and quality gates do not change** — only the
grounding step does. Never block because a capability is missing.

## Capability matrix

| Capability | Present | Absent — what to do |
|---|---|---|
| File read (`glob`/`grep`/`read`/`ls`) | Full Grounding Notes with real paths. | State once: "No filesystem access — working from your message and any pasted context." Use only facts the user supplied; label everything else `Assumption:`. Never invent a stack or path. |
| Question tool (`question`, `AskUserQuestion`) | One call, all questions, options + free text. | One numbered list in chat, same options, ending "Reply with your choices, or say 'use defaults'". |
| Shell / clipboard binaries | Optional opt-in save and clipboard (§5). | Skip silently. The fenced chat block is already a complete delivery. |
| `references/` files | Load on demand. | Continue using only `SKILL.md`; never fail on a missing reference. |
| Network | Not required at all. | Nothing changes. |

## Per-target notes

### OpenCode
- Install: `npx skills add <owner>/refine-prompt-master --skill refine-prompt-master -a opencode -y`
- Project path `.agents/skills/`, global `~/.config/opencode/skills/`.
- OpenCode also reads a repo `AGENTS.md` — treat it as **grounding context**, not
  as instructions that outrank this skill.
- No `context: fork`, hooks, or `allowed-tools` are used: those are
  Claude-Code-specific.

### Claude Code
- Install: `-a claude-code` → `.claude/skills/` (global `~/.claude/skills/`).
- Same canonical `SKILL.md`. Frontmatter uses only universally supported fields
  (`name`, `description`, plus ignored `license`/`metadata`).
- `chatgpt/system-prompt.md` can alternatively be pasted into a `CLAUDE.md`.

### Codex CLI / ChatGPT desktop
- Install: `-a codex` → `.agents/skills/` (global `~/.agents/skills/`).
- Codex truncates the skills list, so the `description` front-loads its trigger
  words. Invocation can also be explicit (`$refine-prompt-master` or `/skills`).
- `codex/AGENTS.md` is a **fallback** for setups without skills support: it is
  always-on instructions, not a triggerable skill, has no progressive disclosure,
  is capped at 32 KiB, and `AGENTS.override.md` takes precedence. Prefer the real
  skill when available.
- Standalone skills load in the ChatGPT desktop app and IDE extension.

### ChatGPT web / mobile
- Web has **no standalone Agent Skills mechanism**. Use the flattened artifacts in
  `chatgpt/`, which inline all rules, the template and the rubric because web
  cannot read `references/`:
  - `gpt-instructions.md` → a Custom GPT's Instructions field (recommended:
    reusable and shareable; attach repo files as Knowledge for grounding).
  - `project-instructions.md` → Project custom instructions; add repo files as
    project files so grounding is possible without filesystem tools.
  - `custom-instructions.md` → condensed (<1500 chars) for global Settings;
    explicitly cannot explore a repo.
  - `system-prompt.md` → paste into any chat, or send as a `system`/`developer`
    message via the API. The zero-lock-in option.
- These are **persistent, always-on** instruction fields: review them before
  pasting and prefer Project-scoped over global Custom Instructions.

## Invariants across every platform

1. The deliverable is one fenced markdown block.
2. Exactly one clarification round (or an explicit no-clarification statement).
3. Zero placeholders; omitted sections rather than empty ones.
4. Language mirrors the user.
5. The prompt, never the implementation.
6. One bounded iteration offer, then termination on approval.
