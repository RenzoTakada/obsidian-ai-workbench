# Setup Step by Step

## 1. Create an Obsidian vault

Create a local Obsidian vault, for example:

```text
~/Documents/MyVault
```

## 2. Run the Claude Code installer

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/RenzoTakada/obsidian-ai-workbench/one-brain/scripts/install-claude.sh)
```

The installer creates `_AI/`, writes `CLAUDE.md`, creates native slash commands in `_AI/.claude/commands/`, and installs `claude-brain`.

## 3. Start Claude Code

```bash
claude-brain
```

Or manually:

```bash
cd ~/Documents/MyVault/_AI
claude
```

## 4. Add the boundary rule

This is already written into `_AI/CLAUDE.md`:

```text
Inside _AI/: you may work autonomously.
Outside _AI/: ask before reading, editing, moving, or deleting files.
Do not write my permanent notes for me.
```

## 5. Optional: configure Ollama embeddings

See [Ollama embeddings](ollama-embeddings.md).

## 6. Start using the loop

1. Human captures and thinks in the human area.
2. AI produces drafts/analysis in `_AI/Outputs/`.
3. Human reviews.
4. Durable AI memory goes to `_AI/Memory/`.
5. Session logs go to `_AI/Sessions/`.
