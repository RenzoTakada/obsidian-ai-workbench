# Add Codex to an Existing an existing Obsidian vault

This guide assumes you already have an Obsidian vault with one AI workbench. The vault can have any name or structure. First follow [Discovery and Validation](discovery-and-validation.md).

Example existing layout:

```text
an existing Obsidian vault/
  _OpenClaw/
```

You want to add Codex as another isolated agent.

## Target structure

```text
an existing Obsidian vault/
  _OpenClaw/
  _Codex/
```

## Create `_Codex/`

```bash
mkdir -p an existing Obsidian vault/_Codex/{Inbox,Outputs,Logs,Memory,Sessions,Projects,Specs,Skills,Templates,Decisions,Briefings,Maintenance}
```

Copy the template:

```bash
cp templates/codex/_Codex/AGENTS.md an existing Obsidian vault/_Codex/AGENTS.md
```

## Run Codex

Use `_Codex/` as the working directory when you want Codex to operate from its own workbench.

## Boundary

Codex may work freely in `_Codex/`.

Codex should ask before accessing:

- `_OpenClaw/`
- `_Claude/`
- human notes
- human projects

## Shared Ollama

Codex may reuse the same local Ollama server if your Codex setup has a memory/search integration.

```text
http://127.0.0.1:11434
model: nomic-embed-text
```
