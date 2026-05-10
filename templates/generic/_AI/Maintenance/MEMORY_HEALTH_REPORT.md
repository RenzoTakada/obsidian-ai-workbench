# Memory Health Report — Instructions

Run a health check when the user asks with phrases like:
- "run memory maintenance"
- "review the brain"
- "clean the context"
- "generate memory health check"
- "check if memory is polluted"
- "organize AI memory"
- "memory review"
- "health check"

---

## How to run

1. Read `_AI/Memory/MEMORY.md` and all linked files
2. Answer the questions below
3. Generate the report as a proposal in `_AI/Outputs/memory-health-YYYY-MM-DD.md`
4. Present the summary to the user
5. Wait for confirmation before making any changes

---

## Health check questions

**Clarity**
- Is the memory clear and objective?
- Is there too much information?
- Is the bootstrap becoming too heavy?

**Duplication and contradiction**
- Are there duplicate entries between files?
- Are there contradictory entries?
- Are there conflicting decisions?

**Currency**
- Is there outdated information that is no longer useful?
- Are closed projects still in active context?
- Have old decisions been replaced?

**Organization**
- Are there files that should be archived?
- Are there large files that should be summarized?
- Are there memories that should become documented decisions?

**Security**
- Is there risk of data leakage?
- Is there sensitive content that should not be saved?
- Is there content that should not be versioned in Git?

**Bootstrap**
- Which files are critical for loading at the start of each session?
- Which files can be loaded on demand only?

---

## Expected output

The output is always a **proposal**, never an automatic change.

Output file: `_AI/Outputs/memory-health-YYYY-MM-DD.md`

```markdown
# Memory Health Report — YYYY-MM-DD

## Overall status
[green / yellow / red]

## Issues found
- ...

## Critical bootstrap files
- ...

## Recommended for archiving
- ...

## Recommended for summarizing
- ...

## Sensitive data found
- ...

## Proposed actions (pending confirmation)
- [ ] ...
```
