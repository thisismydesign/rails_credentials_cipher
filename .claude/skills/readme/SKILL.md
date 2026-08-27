---
name: readme
description: Write or update the project README. Use when creating, reviewing, or restructuring README.md, or when a change alters what users can do with the project.
---

# README

The README is for **users**, not contributors and not agents. Technical instructions for agents belong in `AGENTS.md`.

## Rules

- MUST open with the project name and a one-sentence description of what it does for the reader.
- MUST state what the project is for before how to install it.
- MUST show the shortest path to first working result: install, then the smallest useful example.
- MUST document every user-facing option (CLI flags, config keys, public API) or link to a reference that does.
- MUST link the live app, package page, and demo when they exist.
- MUST NOT document internals, architecture, code style, or test/lint commands. Those belong in `AGENTS.md`.
- MUST NOT include a roadmap, changelog, or TODOs.
- SHOULD use a table when listing more than three options or commands.
- SHOULD keep examples copy-pasteable and real — no placeholder values that cannot run.
- SHOULD assume no context: the reader arrived from a search result.

## Structure

Sections in this order, omitting any that do not apply:

1. Title and one-liner
2. Why / what it solves — only if not obvious from the one-liner
3. Install
4. Usage — smallest example first, then options
5. Configuration
6. Links (live app, package, docs)
7. License

## Self-test

- Can a stranger get a working result from the first screen alone?
- Does anything here only matter to someone editing the code? Move it to `AGENTS.md`.
- Is any command untested or any link dead?
