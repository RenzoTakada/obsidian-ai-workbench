# Security Rules — AI Workbench

Operational rules to follow in every session, without exception.

---

## Core principle

**Least privilege.** Terminal access does not mean authorization.
**When in doubt, ask for confirmation.** Never assume broad permission.

---

## Free to do — inside `_AI/`

- Create, edit, organize, and delete files
- Create logs, outputs, specs, sessions, memory, briefings, decisions
- Generate proposals for changes outside the workbench

---

## Requires explicit confirmation

Any action **outside `_AI/`**:
- Reading files in other vault folders
- Editing files in other vault folders
- Creating files in other vault folders
- Moving or renaming files outside `_AI/`

Before acting: show a summary of what will change and wait for confirmation.

---

## Never — without exception

1. Edit or delete files outside `_AI/` without explicit confirmation
2. Run destructive commands without confirmation (see `DANGEROUS_COMMANDS.md`)
3. Access sensitive paths without authorization (see `SENSITIVE_PATHS.md`)
4. Commit, display, or copy tokens, passwords, private keys, or secrets
5. Add `.env` files, credentials, or personal data to Git
6. Make automatic commits without being asked
7. Delete or modify memory automatically — always propose first in `Outputs/`
8. Assume a prior authorization applies to a different context

---

## Before modifying files outside `_AI/`

1. Show summary: which files are affected and what changes
2. Wait for explicit confirmation
3. Create backup in `_AI/Outputs/` if needed
4. Log the action in `_AI/Logs/`

---

## Memory — never automatic

When memory needs cleanup:
1. Generate proposal in `_AI/Outputs/memory-cleanup-YYYY-MM-DD.md`
2. Wait for explicit confirmation
3. Apply only what was approved
4. Log in `_AI/Logs/`

---

## Logging

Log in `_AI/Logs/` whenever:
- Creating or modifying memory files
- Proposing memory cleanup or review
- Acting outside `_AI/` (with authorization)
- Attempting to access a sensitive path
- Running a high-impact command
