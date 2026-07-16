# Security Rules — AI Workbench

## Core principle
Least privilege. When in doubt, ask for confirmation.

## Free to do — inside `_AI/`
Create, edit, organize, delete files, logs, outputs, specs, sessions, memory.

## Requires explicit confirmation
Any action outside `_AI/`: reading, editing, creating, or moving files.
Before acting: show a summary and wait for confirmation.

## Never — without exception
1. Edit or delete files outside `_AI/` without explicit confirmation
2. Run destructive commands without confirmation (see DANGEROUS_COMMANDS.md)
3. Access sensitive paths without authorization (see SENSITIVE_PATHS.md)
4. Commit, display, or copy tokens, passwords, private keys, or secrets
5. Add .env files or credentials to Git
6. Make automatic commits without being asked
7. Delete or modify memory automatically — propose first in Outputs/
8. Assume a prior authorization applies to a different context

## Logging
Log in `Logs/` whenever modifying memory, acting outside `_AI/`, or running high-impact commands.
