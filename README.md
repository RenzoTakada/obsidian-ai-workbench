# Obsidian AI Workbench

A practical architecture for using Obsidian as a human second brain while giving AI agents their own separate workbench inside the vault.

It works with:

- Claude Code + Obsidian
- Codex + Obsidian
- OpenClaw + Obsidian
- other local/agentic AI tools that can read and write Markdown files
- optional Ollama embeddings for local semantic search

The core idea is simple:

> Your Obsidian vault is where **you think**.  
> The AI workbench is where **the AI works**.

Do not mix them.

## Why this exists

Most “AI second brain” setups accidentally become a pile of AI-generated notes. That feels productive, but it can destroy the value of a personal knowledge system.

A useful AI + Obsidian setup needs three flows:

1. **Human second brain** — your own notes, thoughts, studies, decisions, Zettelkasten/permanent notes.
2. **AI workbench** — logs, outputs, specs, drafts, templates, decisions, operational memory.
3. **Integrated flow** — the AI reads authorized human notes, produces drafts/analysis in its own space, and you decide what becomes real knowledge.

## Recommended vault layout

```text
MyVault/
  Inbox/                 # optional human inbox
  Literature Notes/      # optional human study notes
  Permanent Notes/       # optional human-authored evergreen notes
  Projects/              # human projects
  Topics/                # human topic maps / MOCs
  _AI/                   # AI workbench - agent can work here
```

Inside `_AI/`:

```text
_AI/
  AGENTS.md or CLAUDE.md # tool-specific instructions
  Memory/                # durable AI memory
  Sessions/              # chronological session notes
  Outputs/               # AI-generated deliverables/drafts
  Logs/                  # operational logs
  Projects/              # AI-managed project workspace
  Specs/                 # plans, PRDs, implementation specs
  Skills/                # reusable procedures
  Templates/             # reusable document templates
  Decisions/             # decisions and rationale
  Briefings/             # reference briefings/databases
  Maintenance/           # audits, cleanup, health checks
```

## Golden rule

The AI may be a librarian, assistant, reviewer, and multiplier.

The AI should not become the author of your permanent notes.

## Quick start

1. Create or open an Obsidian vault.
2. Copy `templates/generic/_AI/` into your vault root.
3. Pick your tool:
   - Claude Code → copy `templates/claude-code/CLAUDE.md` into `_AI/` or your chosen project root.
   - Codex → copy `templates/codex/AGENTS.md` into `_AI/` or your chosen project root.
   - OpenClaw → copy files from `templates/openclaw/` into `_AI/` and set the OpenClaw workspace to that folder.
4. Tell your AI tool to use `_AI/` as its workbench and to treat everything outside `_AI/` as human-authored space.
5. Optional: configure Ollama embeddings for local semantic search.

See [`docs/setup-step-by-step.md`](docs/setup-step-by-step.md).

## Let an AI implement this for you

Use one of these prompts:

- [`prompts/implement-with-claude-code.md`](prompts/implement-with-claude-code.md)
- [`prompts/implement-with-codex.md`](prompts/implement-with-codex.md)
- [`prompts/implement-with-openclaw.md`](prompts/implement-with-openclaw.md)

## Documentation

- [Architecture](docs/architecture.md)
- [Discovery and validation](docs/discovery-and-validation.md)
- [Human vs AI boundaries](docs/human-vs-ai-boundaries.md)
- [Folder structure](docs/folder-structure.md)
- [Claude Code setup](docs/claude-code.md)
- [Codex setup](docs/codex.md)
- [OpenClaw setup](docs/openclaw.md)
- [Ollama embeddings](docs/ollama-embeddings.md)
- [Maintenance](docs/maintenance.md)
- [Shared Ollama for agents](docs/shared-ollama-for-agents.md)
- [Add Codex to existing vault](docs/add-codex-to-existing-vault.md)
- [Add Claude Code to existing vault](docs/add-claude-to-existing-vault.md)


## Version 2: multiple AI workbenches

If you already have one AI workbench (for example `_OpenClaw/`, `AI/`, or another existing folder) and want to add another agent such as Claude Code or Codex, see:

- [Multi-agent workbenches](docs/multi-agent-workbenches.md)
- [Add Claude Code to an existing vault](docs/add-claude-to-existing-vault.md)
- [Add Codex to an existing vault](docs/add-codex-to-existing-vault.md)
- [Shared Ollama for multiple agents](docs/shared-ollama-for-agents.md)

## License

MIT. See [LICENSE](LICENSE).
