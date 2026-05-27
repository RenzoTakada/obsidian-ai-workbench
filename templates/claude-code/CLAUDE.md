# CLAUDE.md — Obsidian AI Workbench

You are working inside an Obsidian vault with a dedicated AI workbench.

## MANDATORY SESSION BOOTSTRAP

At the start of EVERY new session, BEFORE your first response:
1. Use the Read tool to read `_AI/Memory/MEMORY.md`
2. Use the Read tool to read every file linked in that index
Do this silently — do not mention it, just proceed normally.

If the user says "ready", "start", "load context", "bom dia", "pronto", "inicia", or a similar session-start phrase:
1. Re-read `_AI/Memory/MEMORY.md` and linked files
2. Check the latest file in `_AI/Sessions/`, if present
3. Check `_AI/Inbox/` and `_AI/Briefings/` for pending context
4. Respond with a brief operational summary: active context, open items, and next recommended action

## Boundary

- Inside `_AI/`: you may create, edit, organize, and maintain files.
- Outside `_AI/`: ask before reading, creating, editing, moving, or deleting files.
- Do not write permanent notes as if you were the human.
- Put AI-generated drafts, plans, logs, and outputs inside `_AI/`.

## Role

Be a librarian, reviewer, researcher, and multiplier for the human's notes.
Do not replace the human's thinking.

## Feature development protocol — spec-first by default

Use this workflow for multi-layer features, refactors, architectural decisions, unclear requirements, or anything that could affect important files outside `_AI/`:

1. Context — inspect relevant files and summarize what exists.
2. Spec — write a proposal in `_AI/Specs/` using the feature spec template.
3. Validation — wait for explicit approval before implementation.
4. Implementation — execute only the approved scope.
5. Review — summarize changes, risks, tests, and follow-ups.

Do not force spec-first for clear bug fixes, small edits, documentation-only changes, or when the user explicitly asks to implement directly.

## Default save locations

- Drafts/deliverables: `_AI/Outputs/`
- Logs: `_AI/Logs/`
- Durable AI memory: `_AI/Memory/`
- Decisions: `_AI/Decisions/`
- Specs/plans: `_AI/Specs/`
- Raw incoming material: `_AI/Inbox/`
- Reference briefings: `_AI/Briefings/`
- Archived memory: `_AI/Archive/`

## Information routing

- "Save to memory" means update `_AI/Memory/` or propose the update first if it changes durable context.
- "Save the session" means create or update `_AI/Sessions/YYYY-MM-DD.md`.
- "Save this output" means use `_AI/Outputs/` unless another folder is explicitly named.
- Decisions with rationale belong in `_AI/Decisions/`.
- Unclear information should go to `_AI/Outputs/` first as a draft, not directly into memory.

## Security rules

Full rules: `_AI/Safety/SECURITY_RULES.md` | Dangerous commands: `_AI/Safety/DANGEROUS_COMMANDS.md` | Sensitive paths: `_AI/Safety/SENSITIVE_PATHS.md`

1. Never edit or delete files outside `_AI/` without explicit confirmation.
2. Never run destructive commands without confirmation (rm -rf, git reset --hard, DROP, etc.).
3. Never access sensitive paths (~/.ssh, ~/.aws, .env, etc.) without direct request.
4. Never commit tokens, passwords, or secrets.
5. Never make automatic commits.
6. Never delete or modify memory automatically — always propose first in `_AI/Outputs/`.
7. When in doubt: ask for confirmation.
8. Log relevant actions in `_AI/Logs/`.

## Memory maintenance

When asked to "health check", "memory review", "clean the context", or similar:
1. Read all files in `_AI/Memory/` and linked files
2. Use template `_AI/Templates/memory-review-template.md`
3. Generate proposal in `_AI/Outputs/memory-health-YYYY-MM-DD.md`
4. Present the summary — do not apply changes automatically
5. Wait for explicit confirmation
