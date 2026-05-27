# Memory Schema

The memory folder is the durable context contract for Claude Code. It keeps context small, explicit, and easy to audit.

## Core principles

- `MEMORY.md` is an index, not a dump.
- Durable facts go in focused files.
- Session notes do not automatically become memory.
- Outputs are drafts until promoted by the human.
- Sensitive data does not belong in memory.

## Folder

Default path:

```text
_AI/Memory/
```

## MEMORY.md

Purpose: bootstrap index read at the start of every session.

Rules:

- Keep it short.
- Link only files that are useful for default context.
- Avoid raw logs, long transcripts, secrets, or large project dumps.
- Prefer summaries and pointers.

Suggested structure:

```markdown
# Memory — Index

Read this file at the start of every session, then read all linked files.

## User
- [User profile](user_profile.md)

## Active projects
- [Project example](project_example.md)

## Current preferences
- [Feedback patterns](feedback_patterns.md)
```

## user_profile.md

Purpose: stable information about the human and collaboration preferences.

Suggested fields:

- Name or display name
- Preferred language
- Tools and stack
- Communication preferences
- Current high-level projects
- Boundaries and safety preferences

## hot.md

Purpose: short-lived working context for the next session.

Use for:

- Active focus
- Recent decisions
- Current blockers
- Next actions
- Last updated date

Rules:

- Keep it short.
- Update at the end of meaningful sessions.
- Do not use it as durable memory.
- Move stable facts into focused memory files when they become important long-term context.

## project_*.md

Purpose: durable context for one project.

Use for:

- Project goal
- Repository or workspace location, if safe to store
- Architecture notes
- Current status
- Important commands
- Links to specs, decisions, or outputs

Do not store:

- Credentials
- Client-sensitive implementation details
- Large logs
- Temporary debugging notes

## decision_*.md

Purpose: capture a decision and its rationale.

Suggested fields:

- Date
- Status
- Context
- Decision
- Alternatives considered
- Consequences
- Related files or docs

Decisions can live in `_AI/Decisions/` and be linked from memory when they are important for default context.

## feedback_*.md

Purpose: reusable feedback about how Claude should work with the human.

Examples:

- Preferred answer style
- Review standards
- Planning preferences
- Things Claude should avoid repeating

Keep feedback general. Do not use it as a transcript store.

## session files

Default path:

```text
_AI/Sessions/YYYY-MM-DD.md
```

Purpose: chronological working notes for a session.

Session files may include:

- What was investigated
- What changed
- Open questions
- Follow-up tasks

Session files are not automatically durable memory. Promote only stable, useful facts to `Memory/`.

## outputs

Default path:

```text
_AI/Outputs/
```

Purpose: drafts, summaries, analysis, and deliverables.

When in doubt, write to `Outputs/` first. Promote to memory only after review.

## Naming conventions

- `project_<short-name>.md`
- `decision_<yyyy-mm-dd>_<short-name>.md`
- `feedback_<topic>.md`
- `user_profile.md`
- `project_vault_setup.md`
- `hot.md`

Use lowercase, hyphenated or underscored names. Avoid spaces for portability.
