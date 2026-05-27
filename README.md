# obsidian-ai-workbench

> One Obsidian vault. One Claude Code workbench. Native slash commands. Persistent memory.

[Leia em Portugues](README.pt.md)

---

## What Is This?

**Obsidian** stores your notes as local Markdown files.

**Claude Code** is a terminal coding assistant that can read and write files, run commands, inspect projects, and help with research or implementation.

**obsidian-ai-workbench** connects them with a safe structure: Claude works inside an isolated `_AI/` folder, loads durable memory at session start, and exposes native Claude Code slash commands such as `/brain` and `/save`.

---

## Why This Exists

Without structure, two things usually happen:

- AI-generated notes get mixed with your personal notes.
- Every new AI session starts without memory of your projects, preferences, and decisions.

This project fixes that by giving Claude Code a dedicated workbench inside your vault.

```
YourVault/
  Your notes...       <- where you think
  _AI/                <- where Claude works
```

Claude does not touch your notes outside `_AI/` unless you explicitly authorize it.

---

## What You Get

| Before | After |
|---|---|
| Claude forgets context every session | Memory loads automatically |
| AI drafts mixed with your notes | Generated work stays in `_AI/` |
| Ad hoc prompts | Native slash commands |
| Manual setup | One installer |

---

## Native Slash Commands

The installer creates Claude Code project commands in `_AI/.claude/commands/`:

| Command | Purpose |
|---|---|
| `/brain` | Load memory, hot context, latest session, inbox, and briefings |
| `/context` | Summarize current context without changing files |
| `/save` | Route information to memory, outputs, sessions, decisions, specs, inbox, or hot context |
| `/review-memory` | Audit memory and create a cleanup proposal |
| `/spec` | Create a spec-first proposal before implementation |
| `/chrome-ia` | Start a persistent Chrome debug profile on port 9222 |
| `/chrome-dev-browser` | Connect to that Chrome session and inspect pages via DOM/HTML |

Chrome commands require Google Chrome on macOS and the `dev-browser` CLI available in `PATH`.

See [docs/commands.md](docs/commands.md).

---

## Requirements

| Tool | Required | How to install |
|---|---|---|
| [Obsidian](https://obsidian.md) | Yes | Download at obsidian.md |
| [Claude Code](https://claude.ai/code) | Yes | Download at claude.ai/code |
| [Ollama](https://ollama.ai) | Optional | For local semantic memory search |

---

## Install

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/RenzoTakada/obsidian-ai-workbench/one-brain/scripts/install-claude.sh)
```

Prefer to audit the installer first?

```bash
curl -fsSL -o install-claude.sh https://raw.githubusercontent.com/RenzoTakada/obsidian-ai-workbench/one-brain/scripts/install-claude.sh
less install-claude.sh
bash install-claude.sh
```

The script asks for:

- your Obsidian vault path;
- your name;
- your current projects;
- your preferred language.

Then start Claude Code inside the workbench:

```bash
claude-brain
```

Or manually:

```bash
cd /path/to/YourVault/_AI
claude
```

---

## What The Installer Creates

```
YourVault/
  _AI/
    CLAUDE.md                  <- Claude Code instructions and memory bootstrap
    .claude/commands/          <- native Claude Code slash commands
    Commands/                  <- command documentation
    Memory/
      MEMORY.md                <- memory index
      hot.md                   <- short-lived context for the next session
      user_profile.md          <- your profile and preferences
      project_vault_setup.md   <- vault/workbench setup
    Sessions/                  <- session notes
    Outputs/                   <- AI-generated drafts and deliverables
    Specs/                     <- specs and implementation plans
    Decisions/                 <- decisions and rationale
    Templates/                 <- reusable templates
    Logs/                      <- operational logs
    Maintenance/               <- memory review routines
    Safety/                    <- security rules
    Archive/                   <- old but useful context
    Projects/
    Briefings/
    Inbox/

~/.local/bin/claude-brain      <- shortcut command
~/.claude/CLAUDE.md            <- global pointer to the workbench
```

---

## Safety Model

Claude is a librarian, reviewer, and multiplier, not the author of your second brain.

- Everything Claude creates stays in `_AI/` by default.
- Files outside `_AI/` require explicit authorization before reading or editing.
- Memory cleanup is proposed first and applied only after confirmation.
- Dangerous commands require explicit confirmation.
- Secrets, tokens, private keys, and client data should not be stored in memory.

Full documentation: [docs/security-model.md](docs/security-model.md).

---

## Demo

See [docs/demo-script.md](docs/demo-script.md). The intended flow:

1. Run the installer.
2. Open the workbench with `claude-brain`.
3. Save a small memory entry with `/save`.
4. Start a new session and run `/brain`.

---

## Documentation

- [How it works](docs/system.md)
- [Claude Code setup](docs/claude-code.md)
- [Workbench commands](docs/commands.md)
- [Claude Code behavior contract](docs/claude-code-behavior.md)
- [Spec-first workflow](docs/spec-first-workflow.md)
- [Information routing](docs/information-routing.md)
- [Memory schema](docs/memory-schema.md)
- [Optional Obsidian MCP](docs/mcp-obsidian.md)
- [Workbench lint](docs/lint-workbench.md)
- [Demo script](docs/demo-script.md)
- [Ollama embeddings](docs/ollama-embeddings.md)
- [Maintenance guide](docs/maintenance.md)

---

## License

MIT. See [LICENSE](LICENSE).
