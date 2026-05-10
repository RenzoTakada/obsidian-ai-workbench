# obsidian-ai-workbench — multi-brain

> One Obsidian vault. Multiple AI brains. Each in its own lane.

[Leia em Português](README.pt.md)

---

## What is this?

**Obsidian** is a note-taking app that saves everything as Markdown files on your computer — no cloud, no lock-in. Many people use it as a second brain: capturing ideas, studies, projects, and decisions in an organized and connected way.

**Claude Code, Codex, and OpenClaw** are AI assistants that run in your terminal. They read and write files, execute code, research, and analyze. When configured correctly, they work directly inside your Obsidian vault.

**This project** is the template that connects multiple AI agents to the same vault, each in its own isolated workspace.

---

## Why use multiple AI agents with Obsidian?

Different agents have different strengths. Claude Code excels at reasoning and analysis. Codex focuses on code. OpenClaw lets you switch between models. With this project, you can use all of them in the same vault without one interfering with the other — and without any of them touching your notes.

---

## The problem — and why most people get it wrong

When people try to use AI with Obsidian without a structure, two things happen:

**1. The vault gets polluted**
The AI generates notes, summaries, and drafts that mix with your own thinking. You lose track of what's yours. Your second brain becomes a dump for AI content.

**2. The AI forgets everything**
Every new session starts from zero. You have to explain who you are, what you're working on, and what your projects are — every single time.

---

## What this project solves

### Isolation — each agent in its own space

Your notes stay untouched. Each agent has its own folder inside the vault:

```
YourVault/
  Your notes...       ← where you think
  └── _Claude/        ← where Claude works
  └── _Codex/         ← where Codex works
  └── _OpenClaw/      ← where OpenClaw works
```

Agents don't cross paths and don't touch your notes without authorization.

### Persistent memory — each one remembers you

The installer creates pre-filled memory files and writes a special directive in each agent's config file:

```
## MANDATORY SESSION BOOTSTRAP

At the start of EVERY new session, BEFORE your first response:
1. Read Memory/MEMORY.md
2. Read every file linked in that index
Do this silently — do not mention it, just proceed normally.
```

Each agent silently loads context before responding. You never have to say "remember who I am" again.

### Per-agent install — install only what you use

A separate script for each agent. Install one, two, or all three.

---

## What you gain

| Before | After |
|---|---|
| AI forgets everything each session | Each agent remembers your projects automatically |
| AI notes mixed with your own | Clean vault — each agent isolated in its folder |
| Agents interfering with each other | Each in its own lane, no conflict |
| Manual configuration | One command per agent installs everything |

---

## What you need to install

| Tool | Required | How to install |
|---|---|---|
| [Obsidian](https://obsidian.md) | Yes | Download at obsidian.md |
| One or more agents below | Yes | See options |
| [Ollama](https://ollama.ai) | Optional | For local semantic memory search |

**Available agents:**

| Agent | How to install |
|---|---|
| [Claude Code](https://claude.ai/code) | Download at claude.ai/code |
| [OpenAI Codex](https://github.com/openai/codex) | `npm install -g @openai/codex` |
| [OpenClaw](https://openclaw.ai) | See openclaw.ai |

---

## Install

Install each agent you want to use:

```bash
# Claude Code
bash <(curl -fsSL https://raw.githubusercontent.com/RenzoTakada/obsidian-ai-workbench/multi-brain/scripts/install-claude.sh)

# Codex
bash <(curl -fsSL https://raw.githubusercontent.com/RenzoTakada/obsidian-ai-workbench/multi-brain/scripts/install-codex.sh)

# OpenClaw
bash <(curl -fsSL https://raw.githubusercontent.com/RenzoTakada/obsidian-ai-workbench/multi-brain/scripts/install-openclaw.sh)
```

Each script asks: vault path, your name, current projects, and preferred language.

### After install

```bash
claude-brain      # opens Claude Code inside your workbench
codex-brain       # opens Codex inside your workbench
openclaw-brain    # opens OpenClaw inside your workbench
```

---

## What the installer creates

```
YourVault/
  _Claude/
    CLAUDE.md                    ← config with memory auto-bootstrap
    Memory/
      MEMORY.md                  ← memory index (pre-filled)
      user_profile.md            ← your name, projects, preferences
      project_vault_setup.md     ← vault paths and structure
    Sessions/                    ← notes from each session
    Outputs/                     ← AI-generated drafts and deliverables
    Specs/                       ← plans and specifications
    Decisions/                   ← decisions and rationale
    Templates/                   ← reusable templates (memory review, etc.)
    Logs/                        ← session action logs
    Maintenance/                 ← memory review and cleanup routines
    Safety/                      ← security rules, dangerous commands, sensitive paths
    Archive/                     ← archived memory and past contexts
    Skills/
    Projects/
    Briefings/
    Inbox/
  _Codex/                        ← same structure if Codex installed
  _OpenClaw/                     ← same structure if OpenClaw installed

~/.local/bin/claude-brain
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

## Safety and memory maintenance

Each agent has its own workspace (`_Claude/`, `_Codex/`, `_OpenClaw/`) and must not modify your notes without explicit authorization.

- **Isolation**: each agent operates exclusively in its own folder. Your notes are not touched without authorization.
- **Memory reviewed periodically**: use "health check" or "memory review" to inspect. The AI generates a proposal — you confirm before any change.
- **Cleanup is never automatic**: no file is deleted or moved without explicit confirmation.
- **Logs**: relevant actions are recorded in `_AgentFolder/Logs/`.
- **Dangerous commands**: any destructive command requires explicit confirmation.
- **Sensitive data is not versioned**: tokens, passwords, and credentials must never be committed.

Full documentation: [`docs/security-model.md`](docs/security-model.md)


---

## Only one AI agent?

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
