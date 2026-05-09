# Prompt: Add Codex to Existing Vault

Read this repository, especially `docs/discovery-and-validation.md`, `docs/multi-agent-workbenches.md` and `docs/add-codex-to-existing-vault.md`.

Task: add a `_Codex/` workbench to my existing Obsidian vault that already has an AI workbench such as `_OpenClaw/`.

Requirements:

0. Do not assume the vault is named anything or has the same structure as the examples. First discover and validate the existing layout.
1. Ask for the vault path if needed.
2. Create `_Codex/` at the vault root.
3. Copy/adapt `templates/codex/_Codex/`.
4. Add `AGENTS.md` with strict boundaries.
5. Do not read or modify `_OpenClaw/`, `_Claude/`, or human notes unless I explicitly authorize it.
6. Do not delete anything.
7. Explain how Codex should be launched and used with `_Codex/`.

Before changing files, report:

```text
Detected vault: <path>
Existing top-level folders: ...
Existing AI workbenches: ...
Proposed new folder: ...
Actions I will take: ...
Actions I will not take: delete/move/modify existing notes
```

If anything is ambiguous, ask for confirmation.
