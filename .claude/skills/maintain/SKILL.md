---
name: maintain
description: Periodic health pass over this project — dependencies, security, CI, errors, runtime. Use when asked to maintain the project, do maintenance, or check its health.
---

<!-- cto:universal:start id=maintain -->

# Maintain

Assess the health of the project, fix what is broken, and report honestly — including the areas that turned out to be fine. A symptom in data or logs usually has a cause in code; find the cause before patching the symptom.

## Checks

Run every check that applies to this project. Skip one only if it does not exist here, and say so in the report.

- **Security** — audit the dependency tree here, in the repo. MUST NOT rely on Dependabot: its alerts need repo-admin scopes, so a project can look clean purely because nobody can read them. Run the ecosystem's own audit and report counts by severity:
  - Ruby: `bundle exec bundler-audit check --update` (add `bundler-audit` if missing)
  - Node: `pnpm audit` (`--prod` for the shipped surface)
  - Whatever the project actually uses, if neither applies. If no audit tool exists, say so — that is itself a finding.
- **Dependencies** — libraries, runtime version, lockfile age, via `bundle outdated` / `pnpm outdated`. Note majors held back and why.
- **CI** — is the default branch green, and does CI actually run tests and lint (not only deploy)?
- **Tests and lint** — full suite locally, clean.
- **Errors** — open and new errors in the error tracker.
- **Background jobs** — failed, stuck, or no longer scheduled.
- **Data health** — for apps with imports or scrapers: failure rates, stale or missing recent runs, suspicious values.
- **Release** — is the released version behind the default branch?
- **Docs** — do README and AGENTS.md still match reality?

## Workflow

1. MUST read AGENTS.md and the `dev-env` skill before running anything.
2. MUST work on a branch and open a pull request per issue. MUST NOT push to the default branch.
3. MUST upgrade libraries and the runtime automatically; MUST run the suite and lint after each upgrade.
4. MUST NOT change infrastructure or production configuration. Propose those instead.
5. MUST verify CI passes after pushing.
6. MUST manually test the app or CLI before calling a fix done — a green suite is not proof.
7. MUST resolve tracker errors whose fix has shipped.
8. SHOULD batch trivial dependency bumps into one PR; MUST keep majors and anything with a migration separate.
9. MUST NOT release unless the user asked for it; SHOULD say when a release is warranted.

## Report

Summarize per area with counts and severity, healthy areas included ("no issues"). MUST report the audit result as numbers by severity, and MUST name the command that produced them so the finding can be reproduced. End with: what was fixed, what is proposed, what needs the owner. State how long the pass took so the portfolio can record its cost.

<!-- cto:universal:end -->

## Project specifics

A published gem with no deployment: the error, background job and data checks do not apply.

- **Security** — `bundle exec bundler-audit check --update`.
- **Dependencies** — `bundle outdated`. The gem depends on `railties >= 7.1`; the Gemfile pins nothing, so `bundle update` moves the development lockfile to the latest Rails. Ruby in `.tool-versions` is the newest the managed Rails apps use.
- **CI** — `.github/workflows/ci.yml`. The test matrix MUST cover every Ruby the gemspec allows (`>= 3.3`); add a new Ruby release to the matrix when it ships. When the oldest one reaches end of life, raise `required_ruby_version`, `TargetRubyVersion` and the matrix together.
- **Tests and lint** — see [dev-env](../dev-env/SKILL.md).
- **Release** — compare `lib/rails_credentials_cipher/version.rb` with `gem info rails_credentials_cipher --remote`. A release is warranted when `main` has user-visible changes over the last tag.
- **Docs** — README task table and AGENTS.md architecture section.
