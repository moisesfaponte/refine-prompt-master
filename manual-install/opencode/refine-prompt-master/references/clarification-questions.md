# Clarification questions — RESOLVED/OPEN and option sets

Load this file at Step 2. The goal is **one batched round, only for items the repo
cannot answer**. Finding facts is the assistant's job, never the user's.

## The fixed fact list

Mark each RESOLVED (verified in a file, or already stated by the user) or OPEN.

| # | Item | Typical source | If OPEN, ask about |
|---|---|---|---|
| 1 | Objective and why | User's message | The desired outcome in one sentence |
| 2 | Expected outcome | User's message / README | What "done" looks like |
| 3 | In-scope | User's message / affected modules | Which files or behaviours |
| 4 | Out-of-scope (explicit) | Rarely stated | What to deliberately leave alone |
| 5 | Concrete deliverables | Repo conventions | Files, tests, docs, endpoint |
| 6 | Constraints | `package.json`, CI, `AGENTS.md`, README | Compat, deps, style, "don't break X", time |
| 7 | Acceptance criteria | Existing tests, CI config | How success is judged |
| 8 | How to verify | `package.json` scripts, Makefile | Which exact commands |
| 9 | Audience and detail level | User's message | Who will execute it, how verbose |

A repo `README.md` that documents the test command makes items 6–8 RESOLVED.
Asking "how do I run the tests?" when `package.json` says `"test": "vitest"` is
the failure mode this table exists to prevent.

## Building the single round

- Only OPEN items become questions. Cap at **6**.
- Every option must be concrete and grounded in real paths/commands from
  Grounding Notes. Generic options like "Option A / Option B" are placeholders
  in disguise.
- Where possible, put the recommended default first and word the question so
  accepting it is the easy answer.
- Always include a free-text / "other" option.

### Example — question tool (one call, all questions)

```json
{
  "questions": [
    {
      "question": "Which routes should the limiter cover?",
      "header": "Scope",
      "options": [
        {"label": "Only POST /api/auth/login (Recommended)", "description": "Matches src/routes/auth.ts and keeps the change minimal."},
        {"label": "All /api/auth/* routes", "description": "Also covers register and refresh in src/routes/auth.ts."},
        {"label": "Every /api route", "description": "Applied centrally in src/middleware/index.ts."}
      ]
    },
    {
      "question": "How should blocked requests be counted?",
      "header": "Limiter",
      "options": [
        {"label": "Per IP, in-process (Recommended)", "description": "No new dependency; matches the current package.json."},
        {"label": "Per IP, Redis-backed", "description": "Adds a dependency and shared state across instances."},
        {"label": "Per account", "description": "Requires identifying the user before authentication."}
      ]
    }
  ]
}
```

### Example — plain chat (no question tool available)

> 1. **Scope** — a) only `POST /api/auth/login` (recommended, matches
>    `src/routes/auth.ts`), b) all `/api/auth/*`, c) every `/api` route, d) other.
> 2. **Rate-limit key** — a) per IP in-process (recommended, no new dependency),
>    b) per IP via Redis, c) per account, d) other.
>
> Reply with your choices, or say "use defaults".

## When nothing is OPEN

State it explicitly and proceed:

> No clarification needed — proceeding with the assumptions below.
> - Assumption: the change should not add new dependencies (inferred from
>   `package.json` being intentionally minimal).
> - Assumption: verification is `npm test && npm run lint` (from `package.json`).

Label those assumptions in the deliverable's Context. Do not invent a question
just to appear thorough.

## Hard prohibitions

- Never open a second clarification round. Iteration only revises the delivered
  prompt; if new information appears later, fold it in as a labelled assumption
  or a revision, not a re-interview.
- Never ask one question at a time.
- Never ask the user to restate their own message or to look up a fact you can
  read yourself.
- Never ask about an item already marked RESOLVED.
