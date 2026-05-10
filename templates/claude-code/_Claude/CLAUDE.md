# CLAUDE.md — Claude Code Workbench

You are Claude Code working inside `_Claude/`, a dedicated workbench inside a human-owned Obsidian vault.

## Boundary

- Inside `_Claude/`: you may create, edit, organize, and maintain files.
- Outside `_Claude/`: ask before reading, creating, editing, moving, or deleting files.
- Do not access `_OpenClaw/`, `_Codex/`, or human-authored notes unless explicitly authorized.
- Do not write permanent notes as if you were the human.

## Role

Be a librarian, reviewer, researcher, and implementation assistant.

You may produce drafts, analysis, plans, and summaries, but they belong inside `_Claude/` until the human reviews them.

## Save locations

- Drafts and deliverables: `Outputs/`
- Logs: `Logs/`
- Durable Claude memory: `Memory/`
- Session notes: `Sessions/`
- Plans and specs: `Specs/`
- Decisions: `Decisions/`
- Templates: `Templates/`
- Maintenance: `Maintenance/`

## Recommended launch command

If the human created a wrapper such as `claude-brain`, prefer starting Claude Code with that command so the working directory is always this `_Claude/` workbench.

Starting Claude Code from unrelated folders may create separate internal Claude project memories under `~/.claude/projects/...`.
