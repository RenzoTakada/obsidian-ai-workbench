# obsidian-ai-workbench — one-brain

> One Obsidian vault. One AI brain. Always remembers you.

[Leia em Português](README.pt.md)

---

## What is this?

**Obsidian** is a note-taking app that saves everything as Markdown files on your computer — no cloud, no lock-in. Many people use it as a second brain: capturing ideas, studies, projects, and decisions in an organized and connected way.

**Claude Code, Codex, and OpenClaw** are AI assistants that run in your terminal. They read and write files, execute code, research, and analyze. If configured correctly, they can work directly inside your Obsidian vault.

**This project** is the template that connects the two the right way.

---

## Why use AI with Obsidian?

Imagine having an assistant that:

- Reads your notes and understands the context of your work
- Researches, summarizes, and produces drafts based on what you already know
- Remembers your projects, preferences, and decisions between sessions
- Organizes outputs and logs in your vault without cluttering your notes

That's what you get when AI and Obsidian work together correctly.

---

## The problem — and why most people get it wrong

When people try to use AI with Obsidian without a proper structure, two things happen:

**1. The vault gets polluted**
The AI starts generating notes, summaries, and drafts — and all of it mixes with your own notes. You lose track of what's yours and what was generated. Your second brain becomes a dump for AI content.

**2. The AI forgets everything**
Every time you open a new session, you have to explain from scratch who you are, what you're working on, and what your projects are. Without persistent memory, the AI never learns about you.

---

## What this project solves

### Isolation — each in its own space

Your notes stay untouched. The AI works in a separate folder (`_AI/`) inside the vault:

```
YourVault/
  Your notes...       ← where you think
  └── _AI/            ← where the AI works
```

The AI doesn't touch your notes unless you explicitly authorize it.

### Persistent memory — it always remembers you

The installer creates pre-filled memory files with your name, projects, and preferences. The agent's config file contains a special directive:

```
## MANDATORY SESSION BOOTSTRAP

At the start of EVERY new session, BEFORE your first response:
1. Read _AI/Memory/MEMORY.md
2. Read every file linked in that index
Do this silently — do not mention it, just proceed normally.
```

This forces the agent to silently load the memory before responding. You never have to say "remember who I am" again — it already knows.

### Operating contract — context before action

The workbench also ships with reusable behavior rules for agents:

- Session-start phrases such as "ready", "start", "load context", "pronto", and "inicia" refresh memory, sessions, inbox, and briefings.
- Larger changes use a spec-first workflow: context, spec, validation, implementation, review.
- Information has explicit destinations: memory, sessions, outputs, specs, decisions, logs, inbox, briefings, and archive.

### One-command setup

No manual configuration. One script does everything: creates the folders, writes the config files, fills in the initial memory, and installs a shortcut command.

---

## What you gain

| Before | After |
|---|---|
| AI forgets everything each session | AI remembers your projects and preferences automatically |
| AI notes mixed with your own | Clean vault — AI isolated in `_AI/` |
| Manual, tedious configuration | One command installs everything |
| You explain context every time | Context loaded automatically |

---

## What you need to install

| Tool | Required | How to install |
|---|---|---|
| [Obsidian](https://obsidian.md) | Yes | Download at obsidian.md |
| One of the agents below | Yes | See options |
| [Ollama](https://ollama.ai) | Optional | For local semantic memory search |

**Choose your AI agent:**

| Agent | How to install |
|---|---|
| [Claude Code](https://claude.ai/code) | Download at claude.ai/code |
| [OpenAI Codex](https://github.com/openai/codex) | `npm install -g @openai/codex` |
| [OpenClaw](https://openclaw.ai) | See openclaw.ai |

---

## Install

Pick your agent and run the command:

```bash
# Claude Code
bash <(curl -fsSL https://raw.githubusercontent.com/RenzoTakada/obsidian-ai-workbench/one-brain/scripts/install-claude.sh)

# Codex
bash <(curl -fsSL https://raw.githubusercontent.com/RenzoTakada/obsidian-ai-workbench/one-brain/scripts/install-codex.sh)

# OpenClaw
bash <(curl -fsSL https://raw.githubusercontent.com/RenzoTakada/obsidian-ai-workbench/one-brain/scripts/install-openclaw.sh)
```

The script will ask:
- Where your Obsidian vault is
- Your name
- Your current projects
- Your preferred language

Then it creates everything automatically.

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
  _AI/
    CLAUDE.md (or AGENTS.md)     ← config with memory auto-bootstrap
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

~/.local/bin/claude-brain        ← shortcut command
~/.claude/CLAUDE.md              ← updated with workbench path
```

---

## The three flows

```
[You think]       Your Obsidian notes, Zettelkasten, projects
      ↓ authorize
[AI works]        _AI/ — isolated from your notes
      ↓ you review
[You decide]      What gets promoted to your permanent notes
```

The AI is a librarian, reviewer, and multiplier — not the author of your second brain.

---

## Safety and memory maintenance

The AI has its own workspace (`_AI/`) and must not modify your notes without explicit authorization.

- **Isolation**: everything the AI creates stays in `_AI/`. Your notes are not touched without authorization.
- **Memory reviewed periodically**: memory accumulates over time — review it to keep context clean and relevant.
- **Cleanup is never automatic**: when you ask to "review memory" or run a "health check", the AI generates a proposal. You confirm before any change.
- **Logs**: relevant actions are recorded in `_AI/Logs/`.
- **Dangerous commands**: any destructive command requires explicit confirmation.
- **Sensitive data is not versioned**: tokens, passwords, and credentials must never be committed.
- **Outputs are reviewed by you**: AI-generated drafts stay in `_AI/Outputs/` until you decide what to promote.

Full documentation: [`docs/security-model.md`](docs/security-model.md)


---

## Using multiple AI agents?

If you want Claude, Codex, and OpenClaw working in the same vault — each in their own folder — see the [multi-brain branch](../../tree/multi-brain).

---

## Documentation

- [How it works — three flows](docs/system.md)
- [Agent behavior contract](docs/agent-behavior.md)
- [Spec-first workflow](docs/spec-first-workflow.md)
- [Information routing](docs/information-routing.md)
- [Claude Code setup](docs/claude-code.md)
- [Codex setup](docs/codex.md)
- [OpenClaw setup](docs/openclaw.md)
- [Ollama embeddings](docs/ollama-embeddings.md)
- [Maintenance guide](docs/maintenance.md)

---

## License

MIT. See [LICENSE](LICENSE).
