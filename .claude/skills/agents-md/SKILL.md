---
name: agents-md
description: Write or update AGENTS.md, the technical instructions agents read before working in a repo. Use when creating or editing AGENTS.md, or after learning something an agent would need next time.
---

# AGENTS.md

`AGENTS.md` is the technical brief an agent reads before touching the repo. It carries what cannot be inferred from the code in one pass: intent, conventions, and the commands that prove work is done.

## Rules

- MUST start with the project name and what the project is, in one or two lines.
- MUST reference the README instead of repeating it: `@README.md` on the second line.
- MUST use RFC 2119 keywords (MUST, MUST NOT, SHOULD, SHOULD NOT, MAY) for every prescriptive statement.
- MUST state the validation commands — test, lint, build — and that the final result MUST pass all of them.
- MUST record conventions that an agent would otherwise get wrong: naming, method ordering, translation rules, what not to disable.
- MUST link to skills rather than inlining their content (`See: [dev-env](.claude/skills/dev-env/SKILL.md)`).
- MUST NOT teach language or framework basics, or narrate what the code does.
- MUST NOT duplicate user-facing docs; keep install and usage in the README.
- SHOULD keep it under roughly 100 lines. Push detail into skills.
- SHOULD be updated as part of the change that invalidates it.

## Structure

1. Title and what the project is
2. `@README.md`
3. Instructions — how to work here, including documenting new learnings
4. Development — link to the `dev-env` skill; do not inline commands that live there
5. Architecture — stack and the few structural facts that shape a change
6. Code style — only the rules that are project-specific

## Nested files

Place an `AGENTS.md` in a subdirectory when its rules differ from the root and apply to everything under it. Keep it to the delta.

## Self-test

- Would an agent produce wrong output without each line? Delete the rest.
- Is any rule already enforced by a linter or test? Then delete it and rely on the check.
- Can a section be replaced by a link to a skill?
