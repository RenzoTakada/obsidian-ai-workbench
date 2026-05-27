# Workbench Commands

The workbench defines native Claude Code project slash commands in `_AI/.claude/commands/`.

## Commands

| Command | Purpose | Writes files? |
|---|---|---|
| `/brain` | Load memory, hot context, latest session, inbox, and briefings | No |
| `/context` | Summarize active context and assumptions | No |
| `/save` | Route information to the correct workbench folder | Yes, with routing rules |
| `/review-memory` | Audit memory and generate a cleanup proposal | Yes, proposal only |
| `/spec` | Create a spec-first proposal before implementation | Yes, spec only |
| `/chrome-ia` | Start a persistent Chrome debug profile on port 9222 | May start/stop Chrome |
| `/chrome-dev-browser` | Connect to Chrome and inspect authenticated pages through DOM/HTML | No by default |

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

Summarizes what Claude currently knows. It should not modify files.

## `/save`

Applies the routing rules from [`docs/information-routing.md`](information-routing.md). If the destination is unclear, write to `_AI/Outputs/` first and ask whether it should be promoted.

## `/review-memory`

Generates a memory health proposal in `_AI/Outputs/`. It must not mutate memory automatically.

## `/spec`

Creates a proposal in `_AI/Specs/` using the feature spec template. It stops before implementation unless explicitly approved.

## `/chrome-ia`

Starts Google Chrome with remote debugging enabled on port 9222 using a dedicated persistent profile at `~/.chrome-debug-profile`.

Use this before browser investigations that need an authenticated Chrome session.

Requires Google Chrome on macOS.

## `/chrome-dev-browser`

Connects to the Chrome session opened by `/chrome-ia` through `dev-browser`.

Use this to inspect private pages, extract data, navigate authenticated flows, and read DOM/HTML content without relying on screenshots.

Requires the `dev-browser` CLI available in `PATH`.
