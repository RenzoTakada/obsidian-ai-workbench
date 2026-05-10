# Memory Cleanup Checklist

## Recommended frequency

- [ ] Light review — weekly
- [ ] Full review — monthly
- [ ] Mandatory review after major projects
- [ ] Mandatory review after significant context changes
- [ ] Mandatory review before publishing or committing repository changes

---

## Checklist

### Main memory
- [ ] Review `_AI/Memory/MEMORY.md` — is it concise and current?
- [ ] Review all files linked in the index
- [ ] Look for duplicate information between files
- [ ] Look for contradictory information
- [ ] Look for sensitive data (tokens, passwords, private paths)

### Relevance
- [ ] Are closed projects still in active context?
- [ ] Have old decisions been replaced by newer ones?
- [ ] Do old prompts and instructions still work?
- [ ] Are there oversized files that should be summarized?

### Organization
- [ ] Separate active context from archivable context
- [ ] Notes that should become separate files?
- [ ] Files that should load on demand (not in bootstrap)?
- [ ] Memories that should become documented decisions in `Decisions/`?

### Security
- [ ] Is there sensitive data that should not be saved?
- [ ] Is there content that should not be versioned in Git?

---

## Cleanup process (never automatic)

1. Run the review using the template in `_AI/Templates/memory-review-template.md`
2. Generate a cleanup proposal in `_AI/Outputs/memory-cleanup-YYYY-MM-DD.md`
3. Wait for explicit user confirmation
4. Apply approved changes
5. Log the review in `_AI/Logs/`
6. Update relevant decisions in `_AI/Decisions/`
