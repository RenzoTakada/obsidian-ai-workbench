# Architecture

Obsidian AI Workbench separates a human knowledge system from an AI operating environment.

## Layers

```text
Human
  uses Obsidian to read/write Markdown

Obsidian vault
  stores local Markdown files

AI tool
  Claude Code, Codex, OpenClaw, Cursor, etc.

Optional embedding/search layer
  Ollama or another embedding provider
```

## Three flows

### 1. Human second brain

This is where the human thinks.

Examples:

- permanent notes
- literature notes
- personal reflections
- project thinking
- decisions
- Zettelkasten notes
- topic maps

The AI should not write these as if it were the human.

### 2. AI workbench

This is where the AI works.

Examples:

- outputs
- drafts
- plans
- specs
- logs
- operational memory
- templates
- maintenance reports

The AI can be autonomous here.

### 3. Integrated flow

The AI can read authorized human notes and produce useful work in its own area.

Examples:

- find related notes
- suggest missing links
- compare new material with prior notes
- summarize a source into a draft
- generate a study plan
- create a project brief

The human reviews and decides what becomes permanent knowledge.

## Key principle

Do not confuse AI-generated output with human-authored knowledge.
