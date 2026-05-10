# Memory Review — Guide

## Why review is necessary

Memory accumulates over time. Without periodic review it may contain:
- Contexts from closed projects
- Old decisions replaced by newer ones
- Duplicate information across files
- Sensitive data that should not be stored
- Large files that slow down the bootstrap

Clean, focused memory is more useful than complete but cluttered memory.

---

## When to review

- Weekly: light check (5–10 min)
- Monthly: full review
- After major projects: mandatory
- After significant context changes: mandatory

---

## Context types

| Type | What it is | Where it lives |
|---|---|---|
| Active context | Information used in recent sessions | `Memory/` |
| Archived context | Useful but not recurring | `Archive/` |
| Temporary output | Draft or deliverable pending review | `Outputs/` |
| Documented decision | Decision with recorded rationale | `Decisions/` |

---

## What to delete

- Information with no practical utility anymore
- Exact duplicates
- Sensitive data (with user confirmation)

## What to archive

- Closed project contexts
- Old decisions that were replaced
- Prompts that worked but are no longer used

## What to summarize

- Large files (>100 lines) with internal repetition
- Files mixing active context with history

## What to turn into a decision

- Important technical choices with rationale
- Established preferences that should not change

---

## Process — never automatic

1. Use template in `_AI/Templates/memory-review-template.md`
2. Fill in the review
3. Generate proposal in `_AI/Outputs/memory-cleanup-YYYY-MM-DD.md`
4. Wait for user confirmation
5. Apply only what was approved
6. Log in `_AI/Logs/`
