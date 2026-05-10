# Memory Archive Policy

## When to keep active

- The project is ongoing
- The information was used in the last 4 weeks
- It is a current behavioral rule
- It is a frequently used path or command reference
- It is bootstrap context needed in every session

## When to archive

- The project has been closed or paused for more than 1 month
- The decision was replaced by a more recent one
- The context is no longer relevant but may have historical value
- The prompt or instruction is no longer used but could be reused

## When to summarize

- The file has more than 100 lines and contains repetition
- There is newer information that makes parts of the file obsolete

## When to turn into a documented decision

- It is an important technical choice with rationale
- It is an established preference that should not be reversed
- It is a defined standard for the project

## When to delete

- It is an exact duplicate of another file
- It contains sensitive data that should not be saved
- It has no practical utility anymore
- The user has explicitly confirmed it can be removed

## When confirmation is required

**Always.** No removal, archiving, or significant memory change is made automatically.

---

## Naming archived files

```
Archive/YYYY-MM-DD_original-name.md
```

Example:
```
Archive/2026-03-15_project-old-context.md
```

## Where to store archived files

```
_AI/Archive/
```

Never move files automatically. Generate a proposal in `_AI/Outputs/` and wait for confirmation.
