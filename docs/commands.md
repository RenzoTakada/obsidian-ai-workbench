# Workbench Commands

The workbench defines a small command vocabulary for agents. Claude Code can use these as project slash commands from `.claude/commands/`; other agents can treat the same names as natural-language intents.

## Commands

| Command | Purpose | Writes files? |
|---|---|---|
| `/brain` | Load memory, hot context, latest session, inbox, and briefings | No |
| `/context` | Summarize active context and assumptions | No |
| `/save` | Route information to the correct workbench folder | Yes, with routing rules |
| `/review-memory` | Audit memory and generate a cleanup proposal | Yes, proposal only |
| `/spec` | Create a spec-first proposal before implementation | Yes, spec only |

## `/brain`

Loads operational context:

- `_AI/Memory/MEMORY.md`
- linked memory files
- `_AI/Memory/hot.md`
- latest `_AI/Sessions/` file
- `_AI/Inbox/`
- `_AI/Briefings/`

The output should be a concise summary with active context, open items, and next recommended action.

## `/context`

Summarizes what the agent currently knows. It should not modify files.

## `/save`

Applies the routing rules from [`docs/information-routing.md`](information-routing.md). If the destination is unclear, write to `_AI/Outputs/` first and ask whether it should be promoted.

## `/review-memory`

Generates a memory health proposal in `_AI/Outputs/`. It must not mutate memory automatically.

## `/spec`

Creates a proposal in `_AI/Specs/` using the feature spec template. It stops before implementation unless explicitly approved.
