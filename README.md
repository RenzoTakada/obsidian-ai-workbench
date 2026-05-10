# obsidian-ai-workbench — multi-brain

> One Obsidian vault. Multiple AI brains. Each in its own lane.

[Leia em Português](README.pt.md)

---

## The problem this solves

When you start using an AI assistant with Obsidian, two things happen:

1. **The vault gets polluted** — AI-generated notes mix with your own thinking, and you lose track of what's yours.
2. **The AI forgets everything** — every new session starts from zero, even if you've worked together for months.

This project solves both.

---

## The idea

Your Obsidian vault has three layers:

```
Your notes          ← where you think
  └── _Claude/      ← where Claude works
  └── _Codex/       ← where Codex works
  └── _OpenClaw/    ← where OpenClaw works
```

Each AI agent gets its own isolated workbench inside the vault. They don't touch your notes unless you authorize it. And because the workbench lives inside the vault, it's always there the next time you open it.

The key innovation is **auto-bootstrap**: a directive inside each agent's config file (`CLAUDE.md`, `AGENTS.md`) that forces the agent to silently read its memory files before the first response in every session. You never have to say "remember who I am" again.

---

## What you need

| Tool | Required | Purpose |
|---|---|---|
| [Obsidian](https://obsidian.md) | Yes | Your personal knowledge vault |
| [Claude Code CLI](https://claude.ai/code) | For Claude workbench | AI coding + reasoning assistant |
| [OpenAI Codex CLI](https://github.com/openai/codex) | For Codex workbench | AI coding assistant |
| [OpenClaw](https://openclaw.ai) | For OpenClaw workbench | Multi-model TUI agent |
| [Ollama](https://ollama.ai) | Optional | Local semantic memory search |

Install at least one AI agent CLI before running the setup script.

---

## Install

Pick the agent(s) you want:

```bash
# Claude Code workbench
bash <(curl -fsSL https://raw.githubusercontent.com/RenzoTakada/obsidian-ai-workbench/multi-brain/scripts/install-claude.sh)

# Codex workbench
bash <(curl -fsSL https://raw.githubusercontent.com/RenzoTakada/obsidian-ai-workbench/multi-brain/scripts/install-codex.sh)

# OpenClaw workbench
bash <(curl -fsSL https://raw.githubusercontent.com/RenzoTakada/obsidian-ai-workbench/multi-brain/scripts/install-openclaw.sh)
```

Each script runs a short wizard (vault path, your name, current projects, preferred language) and then:

- Creates the agent's workbench folder inside your vault
- Writes a config file with the auto-bootstrap memory directive
- Creates pre-filled memory files (`MEMORY.md`, `user_profile.md`, `project_vault_setup.md`)
- Installs a shortcut command (`claude-brain`, `codex-brain`, `openclaw-brain`)
- Configures Ollama semantic search if Ollama is running

After install, just run:

```bash
claude-brain      # opens Claude Code inside your workbench
codex-brain       # opens Codex inside your workbench
openclaw-brain    # opens OpenClaw TUI inside your workbench
```

---

## How auto-bootstrap works

Each agent's config file contains:

```
## MANDATORY SESSION BOOTSTRAP

At the start of EVERY new session, BEFORE your first response:
1. Read Memory/MEMORY.md
2. Read every file linked in that index
Do this silently — do not mention it, just proceed normally.
```

Claude Code reads `CLAUDE.md` as a system prompt. Codex reads `AGENTS.md`. So when you send your first message, the agent already has your context — no manual reminder needed.

---

## What the installer creates

```
YourVault/
  _Claude/
    CLAUDE.md                    ← auto-bootstrap config
    Memory/
      MEMORY.md                  ← memory index (pre-filled)
      user_profile.md            ← your name, projects, preferences
      project_vault_setup.md     ← vault paths and structure
    Sessions/
    Outputs/
    Specs/
    Decisions/
    Templates/
    Logs/
    Maintenance/
    Briefings/
    Skills/
    Projects/
    Inbox/
  _Codex/                        ← same structure if Codex installed
  _OpenClaw/                     ← same structure if OpenClaw installed

~/.local/bin/claude-brain        ← shortcut command
~/.local/bin/codex-brain
~/.local/bin/openclaw-brain
~/.claude/CLAUDE.md              ← updated with workbench path (Claude only)
```

---

## The three flows

```
[You think]       Your Obsidian notes, Zettelkasten, projects
      ↓ authorize
[AI works]        _Claude/, _Codex/, _OpenClaw/ — each in its lane
      ↓ you review
[You decide]      What gets promoted to your permanent notes
```

The AI is a librarian, reviewer, and multiplier — not the author of your second brain.

---

## One AI only?

If you only use one AI tool, see the [one-brain branch](../../tree/one-brain) — simpler setup with a single `_AI/` folder.

---

## Documentation

- [How it works — three flows](docs/system.md)
- [Claude Code setup](docs/claude-code.md)
- [Codex setup](docs/codex.md)
- [OpenClaw setup](docs/openclaw.md)
- [Ollama embeddings](docs/ollama-embeddings.md)
- [Maintenance guide](docs/maintenance.md)

---

## License

MIT. See [LICENSE](LICENSE).
