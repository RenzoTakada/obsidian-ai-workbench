# Multi-Agent Workbenches

Version 2 is for people who already have an Obsidian vault with one AI workbench and want to add more agents without mixing their memories. The vault might be called `IABrain`, `SecondBrain`, `Obsidian Vault`, or anything else.

The pattern is:

> One human brain, multiple AI workbenches.

## First: discover the existing layout

Do not assume folder names. Before creating anything, follow [Discovery and Validation](discovery-and-validation.md).

## Recommended layout

```text
<VaultName>/
  .obsidian/
  Renzo/          # human-authored notes and thinking
  Projects/       # human-owned projects
  _OpenClaw/      # OpenClaw workbench
  _Claude/        # Claude Code workbench
  _Codex/         # Codex workbench
```

You can use any names, but the underscore prefix makes agent folders visually distinct from human-authored areas.

## Why separate agents?

Each agent has different behavior, instruction files, memory formats, and tool integrations.

If multiple agents share one workbench, they can pollute each other's context:

- Claude-specific instructions confuse Codex.
- Codex logs become noise for OpenClaw.
- OpenClaw memory files may not map cleanly to Claude Code.
- Agent-generated outputs can look like human knowledge.

Separate workbenches keep each agent predictable.

## Agent boundaries

Each agent owns only its own folder:

```text
_OpenClaw/  # OpenClaw can work here
_Claude/    # Claude Code can work here
_Codex/     # Codex can work here
```

Outside its own folder, an agent should ask before reading, creating, editing, moving, or deleting files.

## Shared human area

The human area stays outside agent folders:

```text
Renzo/
Projects/
Permanent Notes/
Literature Notes/
Topics/
```

Agents can assist with this area only when explicitly authorized.

## Shared Ollama

All agents can reuse the same local Ollama server:

```text
http://127.0.0.1:11434
model: nomic-embed-text
```

But each tool normally maintains its own index/configuration.

Ollama provides embeddings. It does not decide folder boundaries.

## Cross-agent collaboration

If one agent needs to consume another agent's output, prefer one of these:

1. Human explicitly authorizes access to the other agent folder.
2. Use a shared handoff folder, for example:

```text
<VaultName>/_SharedAI/Handoffs/
```

3. Copy reviewed outputs into the human project area.

Avoid silent cross-agent memory sharing unless you intentionally designed it.

## Version 2 setup flow

Example starting point:

```text
<VaultName>/
  _OpenClaw/
```

Add Claude Code:

```text
<VaultName>/
  _OpenClaw/
  _Claude/
```

Add Codex:

```text
<VaultName>/
  _OpenClaw/
  _Claude/
  _Codex/
```

Each new agent gets:

```text
Memory/
Sessions/
Outputs/
Logs/
Projects/
Specs/
Templates/
Decisions/
Maintenance/
```

And a tool-specific instruction file:

- Claude Code: `CLAUDE.md`
- Codex: `AGENTS.md`
- OpenClaw: `AGENTS.md`, `USER.md`, `SOUL.md`, `MEMORY.md`
