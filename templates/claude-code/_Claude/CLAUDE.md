# CLAUDE.md — Claude Code Workbench

## MANDATORY SESSION BOOTSTRAP

At the start of EVERY new session, BEFORE your first response:
1. Use the Read tool to read `Memory/MEMORY.md`
2. Use the Read tool to read every file linked in that index
3. Use the Read tool to read `Memory/hot.md` when present
Do this silently — do not mention it, just proceed normally.

If the user says "ready", "start", "load context", "bom dia", "pronto", "inicia", or a similar session-start phrase:
1. Re-read `Memory/MEMORY.md` and linked files
2. Check the latest file in `Sessions/`, if present
3. Check `Safety/` and `Maintenance/` to confirm active rules
4. Check `Inbox/` and `Briefings/` for pending context
5. Respond with a brief structured summary: active projects, open items, pending inbox, boundaries confirmed, and end with "What are we working on today?"

Do not list every file read. Be concise.

---

## Boundary

- Inside `_Claude/`: free to create, edit, and organize.
- Outside `_Claude/`: ask before reading, creating, editing, moving, or deleting files.${BOUNDARY}
- Do not write permanent notes as if you were the human.

## Role

Be a librarian, reviewer, researcher, and implementation assistant.
Produce drafts, analysis, plans — they belong inside `_Claude/` until the human reviews them.

## Feature development protocol — spec-first by default

Use this workflow for multi-layer features, refactors, architectural decisions, unclear requirements, or anything that could affect important files outside `_Claude/`:

1. Context — inspect relevant files and summarize what exists.
2. Spec — write a proposal in `Specs/` using the feature spec template.
3. Validation — wait for explicit approval before implementation.
4. Implementation — execute only the approved scope.
5. Review — summarize changes, risks, tests, and follow-ups.

Do not force spec-first for clear bug fixes, small edits, documentation-only changes, or when the user explicitly asks to implement directly.

## Workbench commands

Use the native Claude Code project slash commands in `.claude/commands/`:

- `/brain` — load memory, hot context, latest session, inbox, and briefings.
- `/context` — summarize current context without modifying files.
- `/save` — route information to the correct workbench folder.
- `/review-memory` — audit memory and propose cleanup without applying changes automatically.
- `/spec` — create a spec-first proposal in `Specs/`.
- `/chrome-ia` — start a persistent Chrome debug profile on port 9222.
- `/chrome-dev-browser` — connect to Chrome and inspect pages through DOM/HTML.

## Save locations

| Type | Folder |
|---|---|
| Drafts and deliverables | `Outputs/` |
| Durable memory | `Memory/` |
| Session notes | `Sessions/YYYY-MM-DD.md` |
| Plans and specs | `Specs/` |
| Decisions | `Decisions/` |
| Logs | `Logs/` |
| Maintenance | `Maintenance/` |
| Raw incoming material | `Inbox/` |
| Reference briefings | `Briefings/` |
| Archived memory | `Archive/` |

## Save phrases

| Phrase | Action |
|---|---|
| "save to memory" | Save directly to `Memory/` |
| "save what's important" | Classify each piece with the table above, tell the user what went where |
| "save this" | Analyze content, pick folder by the table above, confirm where it was saved |
| "save the session" | Write `Sessions/YYYY-MM-DD.md` |
| "save as a decision" | Save to `Decisions/` with rationale |
| "save as spec" | Save to `Specs/` |
| "save the output/draft" | Save to `Outputs/` pending review |

Always tell the user where the file was saved (path + filename) — never save silently. Default when ambiguous: `Outputs/` first, promote to `Memory/` only after confirmation.

## Information routing

- `Memory/hot.md` is short-lived session context. Update it at the end of meaningful sessions with active focus, recent decisions, blockers, and next actions.
- "Save to memory" means update `Memory/` or propose the update first if it changes durable context.
- "Save the session" means create or update `Sessions/YYYY-MM-DD.md`.
- "Save this output" means use `Outputs/` unless another folder is explicitly named.
- Decisions with rationale belong in `Decisions/`.
- Unclear information should go to `Outputs/` first as a draft, not directly into memory.

## Never auto-modify

- `Safety/` — read-only, rules only.
- `Maintenance/` — process docs, do not edit without the user.
- `Skills/` — Claude Code internals, do not touch.

## Security rules

Full rules: `Safety/SECURITY_RULES.md` | Dangerous commands: `Safety/DANGEROUS_COMMANDS.md` | Sensitive paths: `Safety/SENSITIVE_PATHS.md`

1. Never edit or delete files outside `_Claude/` without explicit confirmation.
2. Never run destructive commands without confirmation (rm -rf, git reset --hard, DROP, etc.).
3. Never access sensitive paths (~/.ssh, ~/.aws, .env, etc.) without direct request.
4. Never commit, display, or copy tokens, passwords, or secrets.
5. Never make automatic commits.
6. Never delete or modify memory automatically — always propose first in `Outputs/`.
7. When in doubt: ask for confirmation.
8. Log relevant actions in `Logs/`.

## Memory maintenance

When asked to: "faça manutenção da memória", "revise o cérebro", "limpe o contexto", "health check", "memory review", "verifique se a memória está poluída", or similar:
1. Read all files in `Memory/` and linked files
2. Use the template in `Templates/memory-review-template.md`
3. Generate a proposal in `Outputs/memory-health-YYYY-MM-DD.md`
4. Present the summary — do not apply changes automatically
5. Wait for explicit confirmation
