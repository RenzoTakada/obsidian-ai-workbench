# Information Routing

The workbench separates raw material, drafts, durable memory, decisions, and logs. This prevents memory pollution and keeps human notes clean.

## Routing rules

| Information | Default location |
|---|---|
| Durable facts about the user, preferences, or active projects | `_AI/Memory/` |
| Raw material to process later | `_AI/Inbox/` |
| Drafts, summaries, analysis, and deliverables | `_AI/Outputs/` |
| Session timeline and working notes | `_AI/Sessions/YYYY-MM-DD.md` |
| Plans, specs, and implementation proposals | `_AI/Specs/` |
| Decisions and rationale | `_AI/Decisions/` |
| Operational logs | `_AI/Logs/` |
| Reference packs and context briefings | `_AI/Briefings/` |
| Old but useful context | `_AI/Archive/` |

## Command interpretation

- "Save to memory" means update `_AI/Memory/` or propose the change first if it affects durable context.
- "Save the session" means create or update `_AI/Sessions/YYYY-MM-DD.md`.
- "Save this" without a clear destination should go to `_AI/Outputs/` first.
- "Document this decision" means create an entry in `_AI/Decisions/`.
- "Review memory" means generate a proposal in `_AI/Outputs/`, not mutate memory automatically.

## Default when uncertain

If the information is useful but its long-term value is unclear, save it as a draft in `_AI/Outputs/`. Promote it to memory only after review.
