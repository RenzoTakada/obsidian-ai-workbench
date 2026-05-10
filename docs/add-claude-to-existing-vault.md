# Add Claude Code to an Existing an existing Obsidian vault

This guide assumes you already have an Obsidian vault with an AI workbench. The vault can have any name or structure. First follow [Discovery and Validation](discovery-and-validation.md).

Example existing layout:

```text
an existing Obsidian vault/
  _OpenClaw/
```

You want to add Claude Code without mixing it into OpenClaw's memory.

## Target structure

```text
an existing Obsidian vault/
  _OpenClaw/
  _Claude/
```

## Create `_Claude/`

```bash
mkdir -p an existing Obsidian vault/_Claude/{Inbox,Outputs,Logs,Memory,Sessions,Projects,Specs,Skills,Templates,Decisions,Briefings,Maintenance}
```

Copy the template:

```bash
cp templates/claude-code/_Claude/CLAUDE.md an existing Obsidian vault/_Claude/CLAUDE.md
```

## Run Claude Code

Use `_Claude/` as Claude Code's working directory when you want Claude to operate from its own workbench.

Recommended command:

```bash
/path/to/obsidian-ai-workbench/scripts/create-claude-brain-command.sh "<vault-path>/_Claude" claude-brain
claude-brain
```

See [Claude Brain Command](claude-brain-command.md).

If you run Claude Code from the vault root, make sure `CLAUDE.md` clearly tells it that only `_Claude/` is its workbench and everything else requires authorization.

## Boundary

Claude may work freely in `_Claude/`.

Claude should ask before accessing:

- `_OpenClaw/`
- `_Codex/`
- human notes
- human projects

## Ollama

Claude Code does not automatically become a memory-search system just because Ollama is installed.

Ollama can still be useful if Claude has access to scripts, MCP tools, or a separate search integration that calls the local Ollama server.

Default shared endpoint:

```text
http://127.0.0.1:11434
model: nomic-embed-text
```
