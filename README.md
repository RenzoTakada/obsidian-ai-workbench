# obsidian-ai-workbench — one-brain

> One Obsidian vault. One AI brain. Always remembers you.

[Leia em Português](README.pt.md)

---

## The problem this solves

When you start using an AI assistant with Obsidian, two things happen:

1. **The vault gets polluted** — AI-generated notes mix with your own thinking, and you lose track of what's yours.
2. **The AI forgets everything** — every new session starts from zero, even if you've worked together for months.

This project solves both.

---

## The idea

Your Obsidian vault has two clear zones:

```
Your notes          ← where you think
  └── _AI/          ← where the AI works
```

The AI gets its own isolated workbench inside the vault. It doesn't touch your notes unless you authorize it. And because the workbench lives inside the vault, everything persists across sessions.

The key innovation is **auto-bootstrap**: a directive inside the agent's config file (`CLAUDE.md` or `AGENTS.md`) that forces the agent to silently read its memory files before the first response in every session. You never have to say "remember who I am" again.

---

## What you need

| Tool | Required | Purpose |
|---|---|---|
| [Obsidian](https://obsidian.md) | Yes | Your personal knowledge vault |
| One of the options below | Yes | Your AI assistant |
| [Ollama](https://ollama.ai) | Optional | Local semantic memory search |

Pick your AI agent:

| Agent | Install |
|---|---|
| [Claude Code CLI](https://claude.ai/code) | `brew install claude` or download |
| [OpenAI Codex CLI](https://github.com/openai/codex) | `npm install -g @openai/codex` |
| [OpenClaw](https://openclaw.ai) | See openclaw.ai |

---

## Install

Pick your agent and run one command:

```bash
# Claude Code
bash <(curl -fsSL https://raw.githubusercontent.com/RenzoTakada/obsidian-ai-workbench/one-brain/scripts/install-claude.sh)

# Codex
bash <(curl -fsSL https://raw.githubusercontent.com/RenzoTakada/obsidian-ai-workbench/one-brain/scripts/install-codex.sh)

# OpenClaw
bash <(curl -fsSL https://raw.githubusercontent.com/RenzoTakada/obsidian-ai-workbench/one-brain/scripts/install-openclaw.sh)
```

The script runs a short wizard (vault path, your name, current projects, preferred language) and then:

- Creates `_AI/` inside your vault
- Writes the agent config file with the auto-bootstrap memory directive
- Creates pre-filled memory files (`MEMORY.md`, `user_profile.md`, `project_vault_setup.md`)
- Installs a shortcut command (`claude-brain`, `codex-brain`, or `openclaw-brain`)
- Configures Ollama semantic search if Ollama is running

After install, just run:

```bash
claude-brain     # opens Claude Code inside your workbench
# or
codex-brain      # opens Codex inside your workbench
# or
openclaw-brain   # opens OpenClaw TUI inside your workbench
```

---

## How auto-bootstrap works

The agent's config file contains:

```
## MANDATORY SESSION BOOTSTRAP

At the start of EVERY new session, BEFORE your first response:
1. Read _AI/Memory/MEMORY.md
2. Read every file linked in that index
Do this silently — do not mention it, just proceed normally.
```

Claude Code reads `CLAUDE.md` as a system prompt. Codex reads `AGENTS.md`. So when you send your first message, the agent already has your context — no manual reminder needed.

---

## What the installer creates

```
YourVault/
  _AI/
    CLAUDE.md (or AGENTS.md)     ← auto-bootstrap config
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

~/.local/bin/claude-brain        ← shortcut command
~/.claude/CLAUDE.md              ← updated with workbench path (Claude only)
```

---

## The three flows

```
[You think]       Your Obsidian notes, Zettelkasten, projects
      ↓ authorize
[AI works]        _AI/ — the agent's workbench, isolated from your notes
      ↓ you review
[You decide]      What gets promoted to your permanent notes
```

The AI is a librarian, reviewer, and multiplier — not the author of your second brain.

---

## Using multiple AI agents?

If you want Claude, Codex, and OpenClaw working in the same vault — each in their own folder — see the [multi-brain branch](../../tree/multi-brain).

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
