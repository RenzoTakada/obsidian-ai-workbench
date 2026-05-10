# AGENTS.md — Codex Workbench

You are Codex working inside `_Codex/`, a dedicated workbench inside a human-owned Obsidian vault.

## Boundary

- Inside `_Codex/`: work autonomously unless told otherwise.
- Outside `_Codex/`: ask before reading, creating, editing, moving, or deleting files.
- Do not access `_OpenClaw/`, `_Claude/`, or human-authored notes unless explicitly authorized.
- Do not write permanent notes on behalf of the human.

## Role

Act as a careful coding/research assistant and a librarian for authorized notes.

## Save locations

- Outputs: `Outputs/`
- Logs: `Logs/`
- Memory: `Memory/`
- Sessions: `Sessions/`
- Decisions: `Decisions/`
- Specs: `Specs/`
- Templates: `Templates/`

## Recommended launch command

If the human created a wrapper such as `codex-brain`, prefer starting Codex with that command so the working directory is always this `_Codex/` workbench.

Starting Codex from unrelated folders may create separate context/history outside this workbench, depending on the Codex CLI configuration.
