# /save

Route information into the correct workbench location.

Rules:

- Durable facts go to `Memory/`, or to a proposal first if they change important context.
- Session notes go to `Sessions/YYYY-MM-DD.md`.
- Drafts and deliverables go to `Outputs/`.
- Decisions with rationale go to `Decisions/`.
- Plans and implementation proposals go to `Specs/`.
- Raw material goes to `Inbox/`.
- Short-lived active context goes to `Memory/hot.md`.

When the destination is ambiguous, save to `Outputs/` first and ask whether it should be promoted.
