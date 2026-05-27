# _AI Workbench

This folder is the AI's workbench inside the Obsidian vault.

## Boundary

- Inside `_AI/`: AI may create, edit, organize, and maintain files.
- Outside `_AI/`: AI must ask before reading or modifying files.
- AI-generated drafts must not masquerade as human-authored permanent notes.

## Folders

- `Inbox/` — raw material for the AI.
- `Outputs/` — drafts and deliverables.
- `Logs/` — operational logs.
- `Memory/` — durable AI memory.
- `Memory/hot.md` — short-lived context for the next session.
- `Commands/` — reusable command intent documentation.
- `Sessions/` — chronological session notes.
- `Projects/` — AI-managed project workspaces.
- `Specs/` — plans, PRDs, specs.
- `Skills/` — reusable procedures.
- `Templates/` — reusable templates.
- `Decisions/` — decisions and rationale.
- `Briefings/` — reference briefings.
- `Maintenance/` — audits and cleanup.

## Default operating workflow

- Load memory before acting.
- Load `Memory/hot.md` when present.
- Keep generated work inside `_AI/` unless the human explicitly authorizes otherwise.
- Use spec-first for larger changes: context, spec, validation, implementation, review.
- Route unclear information to `Outputs/` first, then promote it to memory only after review.
