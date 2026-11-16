# Codex CLI notes

## Preferred path — real Agent Skill

```bash
npx skills add moisesfaponte/refine-prompt-master --skill refine-prompt-master -a codex -y
```

- Project destination: `.agents/skills/`
- Global destination: `~/.agents/skills/`
- Verify: `npx skills list` and `npx skills check`
- Explicit invocation: `$refine-prompt-master` or `/skills`
- Implicit invocation: the `description` front-loads trigger words because Codex
  truncates the skills list.

The skill is triggerable, supports progressive disclosure via `references/`, and
is only loaded when relevant. This is the recommended setup.

## Fallback path — `AGENTS.md`

```bash
# global
cp codex/AGENTS.md ~/.codex/AGENTS.md
# or project-scoped
cp codex/AGENTS.md ./AGENTS.md
```

Verify with:

```bash
codex --ask-for-approval never "List active instruction sources."
```

Caveats, all of which favour the skill path:

- `AGENTS.md` is **always-on** instructions, not a triggerable skill — it is in
  context on every request.
- It cannot do progressive disclosure; the whole file must be self-contained.
- Codex caps combined instruction content at **32 KiB**.
- `AGENTS.override.md` takes precedence over `AGENTS.md`.
- Codex loads `~/.codex/AGENTS.md` plus `AGENTS.md` files from the git root down
  to the current directory.

## ChatGPT desktop app

The ChatGPT desktop app and the IDE extension load standalone skills directly
(Skills sidebar). Point them at the canonical
`.agents/skills/refine-prompt-master/` folder. ChatGPT **web/mobile** cannot load
standalone skills — use the flattened files in `../chatgpt/` instead.
