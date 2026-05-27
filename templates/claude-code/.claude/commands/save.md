# /save

Route information into the correct workbench location.

Rules:

- Durable facts go to `_AI/Memory/`, or to a proposal first if they change important context.
- Session notes go to `_AI/Sessions/YYYY-MM-DD.md`.
- Drafts and deliverables go to `_AI/Outputs/`.
- Decisions with rationale go to `_AI/Decisions/`.
- Plans and implementation proposals go to `_AI/Specs/`.
- Raw material goes to `_AI/Inbox/`.
- Short-lived active context goes to `_AI/Memory/hot.md`.

When the destination is ambiguous, save to `_AI/Outputs/` first and ask whether it should be promoted.
