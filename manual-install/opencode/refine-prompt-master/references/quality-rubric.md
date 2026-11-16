# Quality rubric — extended gates with PASS/FAIL evidence

Load this file at Step 3 / §6. Score internally. A PASS requires **concrete
evidence quoted from the draft**, never a feeling ("looks good" is not a PASS).
Show the user only a one-line summary **in the user's language**, e.g.
`Self-check: 10/10 — ready.` (English) or `Self-check: 10/10 — listo.` (Spanish).

Each gate is PASS or FAIL. Deliver only at **10/10** — the same scale shown in
the one-line summary and in `SKILL.md` §6.
Run the loop at most **3** times: draft → rubric → fix → re-run. If a gate still
fails after 3 cycles, deliver the best version, name the failing gate openly,
and stop.

| Gate | PASS evidence to quote | Typical FAIL |
|---|---|---|
| **G1 Grounding** | Each Context bullet cites a real path you read, e.g. "tests use Vitest (`vitest.config.ts`)"; inferences labelled `Assumption:`. | "The project uses Jest" when `package.json` lists Vitest. |
| **G2 No placeholders** | A mechanical scan of the block finds zero `[...]`, `{...}`, `<describe here>`, `___`, `{{...}}`, `TODO`, `TBD`, `FIXME`, `N/A`, and no empty section; the required `- [ ]` checkboxes are exempt. | `## Constraints\n- TBD`. |
| **G3 Completeness** | Objective, Scope (with `Out-of-scope:`), Deliverables, Acceptance criteria and Verification all present and filled. | Missing out-of-scope; criteria written as prose, not `- [ ]`. |
| **G4 Verifiable** | Each `- [ ]` criterion maps to a named command/check in Verification. | Criterion "works correctly" with only "run the tests". |
| **G5 One round** | Exactly one `question` call or one numbered list, or an explicit "No clarification needed". | Two separate question calls; asking for the test command that is in `package.json`. |
| **G6 Language** | All prose, headings, questions and the iteration offer are in the user's language; code/paths unchanged. | Spanish user, English headings and offer. |
| **G7 Scope discipline** | No writes to project files occurred; no code generated. | "I went ahead and created `src/middleware/rate-limit.ts`". |
| **G8 Actionable** | A fresh agent could execute it without this conversation; real paths inline; imperative verbs. | "Update the relevant files as appropriate." |
| **G9 Portable** | Deliverable is a chat fenced block; clipboard/save absent or clearly optional. | Response depends on `joyride_request_human_input` or a VS Code API. |
| **G10 Loop ready** | Exactly one scoped iteration offer follows the block; termination rule known. | Three closing questions; or no offer at all. |

## Hard gates — any one forces a revision, silently waiving them is not allowed

1. Any placeholder or empty section (G2).
2. Any unverified concrete fact stated as fact (G1).
3. Any implementation action taken (G7).
4. More than one clarification round (G5).
5. No exit condition / bounded loop (G10, §7).

## Worked PASS/FAIL excerpt

Draft line: `## Context\n- Tests run with npm test (package.json).`

- **G1 PASS** — evidence: `package.json` was read and contains
  `"test": "vitest"`. Concrete path cited, claim traceable.
- **G1 FAIL** example: `Tests run with Jest.` No path, no read, contradicts the
  manifest. Fix: read `package.json` and restate with the citation.

Draft line: `## Constraints\n- Keep the existing TypeScript strict mode.`

- **G1 PASS** — traceable to `tsconfig.json`.
- **G2 FAIL** example: `- Don't break <existing behaviour>` — an angle-bracket
  slot. Fix: replace with the concrete behaviour, or delete the bullet.

## Why a rubric at all

Generate → score → revise consistently outperforms accepting the first rewrite
(cf. APE candidate scoring, OPRO value-carrying iteration, and meta-prompting's
conductor/verification split). Keep the rubric short and mechanical: a 40-slot
scored report full of empty brackets reproduces the exact anti-pattern this skill
exists to eliminate. Guard against overfitting — do not copy the user's examples
verbatim into the prompt; extract the general principle instead.
