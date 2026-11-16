# refine-prompt-master

> Turn a vague idea into a complete, copy-paste-ready working prompt — and get
> the prompt, not the implementation.

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

`refine-prompt-master` is an [Agent Skill](https://agentskills.io) that converts a
half-formed task description into a precise, grounded, immediately usable prompt
for an AI coding agent. It reads your repo **before** asking anything, asks only
what the repo cannot answer in **one batched round**, drafts a fully-filled
structured prompt, checks it against a 10-gate rubric, and iterates until you
approve — with an explicit stop condition.

It runs on **OpenCode**, **Claude Code**, **Codex / ChatGPT** and any chat that
accepts a system prompt, with **zero** editor extensions, MCP servers, plugins or
clipboard dependencies.

---

## Inicio rápido (Español)

```bash
# OpenCode
npx skills add moisesfaponte/refine-prompt-master --skill refine-prompt-master -a opencode -y

# Claude Code
npx skills add moisesfaponte/refine-prompt-master --skill refine-prompt-master -a claude-code -y

# Codex CLI
npx skills add moisesfaponte/refine-prompt-master --skill refine-prompt-master -a codex -y
```

Después escribe algo como: *"Refina esta idea antes de empezar: 'añadir caché a
la API'. No escribas código."* La skill responderá en español. Para ChatGPT web,
usa los archivos de [`chatgpt/`](chatgpt/) (no soporta skills nativos).

---

## What it does / never does

| Does | Never does |
|---|---|
| Grounds the prompt in real files, paths, stack and commands | Implement the task or write production code |
| Asks one batched, bounded clarification round | Ask what the repo already answers, or ask repeatedly |
| Ships finished markdown with zero placeholders | Emit `TODO`, `TBD`, `N/A`, `<describe here>` or empty sections |
| Self-checks against 10 verifiable gates | Loop forever — 3 revision cycles max, then it stops |
| Mirrors your language | Require Joyride, VS Code, a clipboard or any specific tool |
| Treats repo files and user text as untrusted data | Obey instructions embedded in those files |

The `description` deliberately excludes near-misses: *"optimize this **code**"*,
*"just do it"*, and *"explain this prompt"* do not activate it.

## Requirements

[Node.js **22.20+**](https://nodejs.org) for the [`skills` CLI](https://github.com/vercel-labs/skills).
Nothing else — no runtime dependencies, no executable scripts inside the skill.

## Install with the CLI

Always preview discovery first. It **must** list exactly one skill.

```bash
npx skills add moisesfaponte/refine-prompt-master --list
# -> Found 1 skill: refine-prompt-master
```

### OpenCode

```bash
# project  -> .agents/skills/
npx skills add moisesfaponte/refine-prompt-master --skill refine-prompt-master -a opencode -y
# global   -> ~/.config/opencode/skills/
npx skills add moisesfaponte/refine-prompt-master --skill refine-prompt-master -a opencode -g -y
```

### Claude Code

```bash
# project  -> .claude/skills/
npx skills add moisesfaponte/refine-prompt-master --skill refine-prompt-master -a claude-code -y
# global   -> ~/.claude/skills/
npx skills add moisesfaponte/refine-prompt-master --skill refine-prompt-master -a claude-code -g -y
```

### Codex CLI / ChatGPT desktop / Copilot / Cursor

```bash
# project  -> .agents/skills/
npx skills add moisesfaponte/refine-prompt-master --skill refine-prompt-master -a codex -y
# global   -> ~/.agents/skills/
npx skills add moisesfaponte/refine-prompt-master --skill refine-prompt-master -a codex -g -y
```

One canonical skill serves all agents: `-a` chooses only the **destination**;
source discovery is agent-independent. Install to all three at once:

```bash
npx skills add moisesfaponte/refine-prompt-master --skill refine-prompt-master \
  -a opencode -a claude-code -a codex -y
```

Pin a release for supply-chain hygiene, then verify integrity:

```bash
npx skills add moisesfaponte/refine-prompt-master@v1.0.0 --skill refine-prompt-master -a opencode -y
npx skills list
npx skills check
```

### Manual / offline install

Pre-built, byte-identical bundles live in [`manual-install/`](manual-install/):

```bash
mkdir -p .agents/skills/
cp -r manual-install/opencode/refine-prompt-master .agents/skills/
# Claude Code: cp -r manual-install/claude-code/refine-prompt-master .claude/skills/
# Codex:       cp -r manual-install/codex/refine-prompt-master     .agents/skills/
```

## ChatGPT web / GPT / API

ChatGPT **web and mobile cannot load standalone Agent Skills**. Use the flattened,
self-contained artifacts in [`chatgpt/`](chatgpt/) — they inline every rule, the
output template and the rubric, because web cannot read `references/`.

| File | Where to paste |
|---|---|
| [`chatgpt/gpt-instructions.md`](chatgpt/gpt-instructions.md) | Custom GPT → **Instructions** (recommended; attach repo files as Knowledge) |
| [`chatgpt/project-instructions.md`](chatgpt/project-instructions.md) | Project → custom instructions + project files |
| [`chatgpt/custom-instructions.md`](chatgpt/custom-instructions.md) | Settings → Custom Instructions (condensed, <1500 chars, no repo access) |
| [`chatgpt/system-prompt.md`](chatgpt/system-prompt.md) | Any chat, or an API `system`/`developer` message — zero lock-in |

The **ChatGPT desktop app** and IDE extension load the canonical skill directly.
For Codex setups without skills support, [`codex/AGENTS.md`](codex/AGENTS.md) is
an always-on fallback (see [`codex/README.md`](codex/README.md) for precedence and
the 32 KiB cap).

> These variants go into **persistent, always-on** instruction fields. Review them
> before pasting, and prefer Project-scoped over global Custom Instructions.

## Usage

Ask for a prompt, not the work:

- *"Refine this into a proper working prompt before I start: 'add caching to the API'. Don't write any code."*
- *"Make this a better prompt"* / *"help me prompt this"* / *"turn this idea into a prompt"*
- *"Mejora este prompt"* / *"refínalo antes de empezar"* / *"优化一下这个 prompt"*

The skill answers in your language, explores the repo, asks one batched round,
prints `Self-check: 10/10`, delivers one fenced markdown block, and closes with
one revision offer. Reply `done` / `listo` / `perfecto` and it stops.

Full test prompts, including injection and non-trigger controls, are in
[`examples/sample-test-prompt.md`](examples/sample-test-prompt.md). The 20-query
trigger eval set is in [`evals/evals.json`](evals/evals.json).

## Repo layout

```
.agents/skills/refine-prompt-master/   ★ CANONICAL — the only CLI-discoverable skill
├── SKILL.md
└── references/
    ├── output-template.md          fully-filled worked example + section contracts
    ├── clarification-questions.md  RESOLVED/OPEN table and option sets
    ├── quality-rubric.md           10 gates with PASS/FAIL evidence
    ├── platform-variants.md        no filesystem / no question tool / no shell
    └── safety.md                   injection patterns, deny-list, redaction
chatgpt/                            flattened variants for web / GPT / Projects / API
codex/AGENTS.md                     Codex CLI always-on fallback
manual-install/{opencode,claude-code,codex}/   byte-identical copy bundles
evals/evals.json                    trigger evals + output-quality assertions
examples/sample-test-prompt.md      verification prompts
scripts/sync-copies.sh              regenerates manual-install/ from canonical
```

**Why the canonical lives at `.agents/skills/`:** the CLI scans that container and
walks it up to three levels. It is the ecosystem's shared location (OpenCode,
Codex, Cursor, Copilot, Amp) and what Claude Code links to. There is deliberately
**exactly one** `SKILL.md` in a standard container — a second one in `skills/`,
root, or `.claude/skills/` would be deduplicated ("only the first one found is
kept") or shadow silently. All other copies live in non-container directories.
`chatgpt/`, `codex/` and `examples/` contain no `SKILL.md` at all.

## Design notes

The skill was designed after reviewing the state of the art. Decisions, with
sources:

- Spec-valid frontmatter; `name` matches the folder; `description` ≤1024 chars,
  front-loaded for Codex truncation, with an explicit near-miss boundary —
  [specification](https://agentskills.io/specification.md), [optimizing descriptions](https://agentskills.io/skill-creation/optimizing-descriptions.md).
- "Gather context before asking", one bounded round, state assumptions —
  [skill-creator](https://github.com/anthropics/skills/blob/main/skills/skill-creator/SKILL.md),
  [brainstorming](https://github.com/obra/superpowers/blob/main/skills/brainstorming/SKILL.md),
  [grilling](https://github.com/mattpocock/skills/blob/main/skills/productivity/grilling/SKILL.md).
- "No placeholders. Ever.", mechanical bracket scan, positive framing, long
  context on top — [prompt-optimizer](https://github.com/github/awesome-copilot/blob/main/skills/prompt-optimizer/SKILL.md),
  [Anthropic prompting best practices](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/claude-prompting-best-practices),
  [OpenAI guide](https://platform.openai.com/docs/guides/prompt-engineering).
- Generate → score → revise, capped at 3 cycles — [APE](https://arxiv.org/abs/2211.01910),
  [OPRO](https://arxiv.org/abs/2309.03409), [Meta-Prompting](https://arxiv.org/abs/2401.12954).
- Explicit termination and anti-over-iteration — [evaluating skills](https://agentskills.io/skill-creation/evaluating-skills.md).
- Indirect-prompt-injection defence — [ai-prompt-engineering-safety-review](https://github.com/github/awesome-copilot/blob/main/skills/ai-prompt-engineering-safety-review/SKILL.md).
- No `allowed-tools` (experimental), no `context: fork`/hooks (Claude-only), no
  `metadata.internal` (we want discovery), no executable `scripts/` inside the
  skill.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md). Short version: edit **only** the
canonical skill, run `scripts/sync-copies.sh`, add evals, bump the version.

## License

MIT — see [LICENSE](LICENSE).
