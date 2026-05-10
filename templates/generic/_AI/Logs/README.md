# Logs — How to use

This folder records relevant actions performed during sessions.

---

## What to log

- Memory file creation or modification
- Memory review or cleanup proposals
- Actions outside `_AI/` (with authorization)
- Attempted access to sensitive paths
- High-impact command execution
- Important decisions made during the session
- Installation or configuration errors

## What not to log

- Routine read operations
- Normal output and draft creation
- Q&A with no impact on files

---

## Log file format

Name: `YYYY-MM-DD.md` (one file per day, appended as needed)

```markdown
# Log — YYYY-MM-DD

## HH:MM — [action type]

**Action:** short description
**Files affected:** path/file.md
**Reason:** why it was done
**Status:** completed / proposed / pending confirmation
```

---

## Examples

```markdown
## 14:32 — memory update

**Action:** Updated Memory/MEMORY.md with new project entry
**Files affected:** Memory/MEMORY.md
**Reason:** New project started
**Status:** completed

## 15:10 — cleanup proposal

**Action:** Generated Outputs/memory-cleanup-2026-05-10.md with archiving proposal
**Files affected:** (none yet — pending confirmation)
**Reason:** Project closed, context can be archived
**Status:** pending user confirmation
```
