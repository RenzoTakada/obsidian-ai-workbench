# Claude Code + Obsidian

Claude Code can work well with Obsidian because Obsidian notes are local Markdown files.

## Recommended setup

Use `_AI/` as Claude's main working directory.

```text
MyVault/
  Permanent Notes/   # human area
  Projects/          # human area
  _AI/               # Claude workbench
    CLAUDE.md
```

## Boundary instruction

Put the boundary in `CLAUDE.md`:

```text
Inside _AI/: work freely.
Outside _AI/: ask before reading or modifying files.
Never write permanent notes as if you were the human.
```

## When to allow vault access

Allow Claude to read human notes when you want it to:

- find related notes;
- suggest missing links;
- compare new material to what you already know;
- produce a draft for review.

Keep generated drafts inside `_AI/Outputs/`.
