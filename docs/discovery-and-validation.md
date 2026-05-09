# Discovery and Validation

Never assume the user's vault name or structure. It might be called `IABrain`, `SecondBrain`, `Obsidian Vault`, or anything else.

Before creating `_Claude/`, `_Codex/`, `_OpenClaw/`, or any other agent workbench, validate the existing environment.

## What to discover

Ask or detect:

1. What is the Obsidian vault path?
2. Does the folder contain `.obsidian/`?
3. What AI workbench folders already exist?
4. Are there existing folders with similar names?
5. Is the user asking to create a new workbench or adapt an existing one?
6. Which agent/tool is being added?
7. Should the new agent be allowed to read any existing workbench?
8. Should the new agent be allowed to read any human-authored folder?

## Common existing layouts

The user may already have something like:

```text
MyVault/
  _OpenClaw/
  Projects/
```

Or:

```text
SecondBrain/
  AI/
  Claude/
  Notes/
```

Or:

```text
Obsidian Vault/
  00 Inbox/
  01 Projects/
  02 Areas/
  03 Resources/
  04 Archive/
```

Do not force a rename unless the user explicitly wants one.

## Validation checklist

Before making changes:

- [ ] Confirm the vault path.
- [ ] Confirm whether `.obsidian/` exists.
- [ ] List top-level folders.
- [ ] Identify existing AI folders.
- [ ] Identify possible naming conflicts.
- [ ] Propose the new folder name.
- [ ] Ask for confirmation if there is ambiguity.
- [ ] Do not delete anything.
- [ ] Do not move existing folders unless explicitly authorized.

## Safe default

If the user wants to add Claude Code, propose:

```text
<vault>/_Claude/
```

If the user wants to add Codex, propose:

```text
<vault>/_Codex/
```

If those folders already exist, do not overwrite them. Inspect only with permission and propose one of:

```text
_Claude2/
_Claude-Code/
_AI-Claude/
```

## Folder ownership rule

A new agent owns only its new folder.

Example:

```text
MyVault/
  _OpenClaw/   # OpenClaw owns this
  _Claude/     # Claude owns this
  _Codex/      # Codex owns this
  Projects/    # human-owned
```

Claude should not assume it can read `_OpenClaw/`. Codex should not assume it can read `_Claude/`. Any cross-agent access should be explicitly authorized.

## When using an AI to implement this

The AI should first produce a short plan:

```text
Detected vault: <path>
Existing top-level folders: ...
Existing AI workbenches: ...
Proposed new folder: ...
Actions I will take: ...
Actions I will not take: delete/move/modify existing notes
```

Then wait for confirmation if anything is unclear.
