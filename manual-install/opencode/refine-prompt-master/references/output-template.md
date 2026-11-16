# Output template — section contracts and a worked example

Load this file while drafting the deliverable. The canonical rules live in
`SKILL.md`; this file supplies the shape and one fully-filled example.

## Section contracts

| Section | Contract | Common mistake |
|---|---|---|
| `# Title` | Verb-first, names the concrete change. "Add rate limiting to the login endpoint", not "Improvements". | Title too abstract to act on. |
| `## Objective` | Exactly one sentence: what changes and why. | Two goals fused into one sentence. |
| `## Context` | Only verified facts, each with a real path. Label inferences `Assumption:`. | Inventing a framework version or a file that was never read. |
| `## Scope` | Both `In-scope:` and `Out-of-scope:` bullets. Out-of-scope prevents scope creep. | Listing only what to do. |
| `## Deliverables` | Numbered, countable artefacts (files, endpoints, tests, docs). | Vague nouns like "improvements". |
| `## Constraints` | Compatibility, dependencies, style, "don't break X", time. | Repeating the objective. |
| `## Suggested steps` | Ordered imperatives referencing real paths and commands. | Steps that cannot be executed in this repo. |
| `## Acceptance criteria` | `- [ ]` items, each objectively testable. | "Works correctly", "follows best practices". |
| `## Verification` | Exact commands/checks, one per criterion. | "Run the tests" without naming them. |

Translate headings into the user's language. Omit any section that does not
apply; never leave an empty section or write `N/A`.

## Worked example — fully filled, zero placeholders

This is a complete deliverable produced for a hypothetical Express + TypeScript
repo. Every path and command below was verified by reading
`package.json`, `src/routes/auth.ts`, `src/middleware/index.ts`,
`vitest.config.ts` and `README.md`. It contains no unfilled slots.

````markdown
# Add rate limiting to the login endpoint

## Objective
Limit `POST /api/auth/login` to 5 attempts per IP per 15 minutes so that
credential-stuffing attempts cannot be automated at full speed.

## Context
- Stack: Express 4 + TypeScript, ESM, Node 22 (`package.json`).
- Login handler: `src/routes/auth.ts`, mounted at `/api/auth` by `src/routes/index.ts`.
- Middleware is registered centrally in `src/middleware/index.ts`; there is no
  per-route middleware chain yet.
- Tests use Vitest (`vitest.config.ts`), run with `npm test`.
- No rate-limiting dependency is currently installed (`package.json`).
- Assumption: the app runs behind a single reverse proxy that sets
  `X-Forwarded-For`; if it does not, use `req.ip` instead.

## Scope
- In-scope: a reusable IP-based limiter middleware, applied only to the login
  route, plus unit and integration tests.
- Out-of-scope: account lockout, CAPTCHA, per-user limits, Redis-backed shared
  state, changes to any other route, UI changes.

## Deliverables
1. `src/middleware/rate-limit.ts` exporting `loginLimiter`.
2. A one-line registration in `src/routes/auth.ts` for the login route only.
3. `src/middleware/rate-limit.test.ts` covering allow, block and window reset.
4. A short note in `README.md` documenting the limit and the proxy header.

## Constraints
- Do not change the response shape of a successful login.
- Do not add a Redis or database dependency; the limiter must be in-process.
- Keep the existing TypeScript strict mode and ESLint rules.
- A blocked request must return HTTP 429 with a `Retry-After` header.

## Suggested steps
1. Add `loginLimiter` in `src/middleware/rate-limit.ts` using a fixed 15-minute
   window keyed on `X-Forwarded-For` when present, else `req.ip`.
2. Apply it to `POST /api/auth/login` in `src/routes/auth.ts` only.
3. Add `src/middleware/rate-limit.test.ts` with three Vitest cases.
4. Document the behaviour and the proxy assumption in `README.md`.
5. Run `npm test` and `npm run lint`.

## Acceptance criteria
- [ ] Five rapid login requests from one IP succeed; the sixth returns 429.
- [ ] A 429 response includes a `Retry-After` header in seconds.
- [ ] Requests after the 15-minute window are allowed again.
- [ ] No route other than `POST /api/auth/login` is limited.
- [ ] `npm test` and `npm run lint` both exit 0.

## Verification
- `npm test -- src/middleware/rate-limit.test.ts` covers all three limiter cases.
- `npm test` confirms no regression in the existing auth tests.
- `npm run lint` confirms style compliance.
- Manual: `for i in $(seq 1 6); do curl -s -o /dev/null -w "%{http_code}\n" -X POST localhost:3000/api/auth/login; done`
  prints five `401`/`200` responses followed by one `429`.

Before finishing, verify your result against the five acceptance criteria above
and report which checks passed.
````

## Why the example is shaped this way

- Long, concrete context comes **before** the instructions; the executable asks
  are near the end. Quoted material and commands sit in fenced blocks so they
  cannot be misread as instructions to the reader.
- Each acceptance criterion maps to a named verification step (gate G4).
- Positive instructions ("return 429 with `Retry-After`") dominate over
  prohibitions.
- The one genuine unknown is labelled `Assumption:` rather than presented as fact.
- A closing self-check line is included because this is a change to an auth path —
  as a plain trailing line, not a tenth section (§4 fixes the list at nine).
- Nothing is generic: swapping this task for another yields a different prompt.
