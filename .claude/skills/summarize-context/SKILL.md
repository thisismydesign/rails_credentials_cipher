---
name: summarize-context
description: Generate a compressed context summary for handoff to a new agent session. Use when the user asks to summarize the conversation, prepare for handoff, create a context summary, or wants to continue work in a new session.
---

<!-- cto:universal:start id=summarize-context -->

# Context Summary for Agent Handoff

Generate a compressed context summary so the user can start a new agent session with full context.

## Output Format

Output the summary inside a fenced code block (triple backticks with `markdown` language tag) so the user can copy the raw markdown:

````
```markdown
## Context Summary

### Goal
[One sentence: what we're trying to accomplish]

### Current State
- [What's been done]
- [What's working/not working]

### Key Files
- `path/to/file.rb` - [why it matters]

### Decisions Made
- [Important choices and their rationale]

### Next Steps
1. [Immediate next action]
2. [Following actions]

### Gotchas
- [Non-obvious things the next agent should know]
```
````

## Guidelines

- Compress aggressively - every line should earn its place
- Include file paths, not full code (agent can read files)
- Focus on decisions and context that aren't obvious from code
- Omit routine details (setup, basic commands)
- Include any error messages or blockers if relevant
- Combine related points into single bullets when possible

<!-- cto:universal:end -->
