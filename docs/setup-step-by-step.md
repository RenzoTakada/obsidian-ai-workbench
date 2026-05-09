# Setup Step by Step

## 1. Create an Obsidian vault

Create a local Obsidian vault, for example:

```text
~/Documents/MyVault
```

## 2. Create the AI workbench

Copy the generic template:

```bash
cp -R templates/generic/_AI ~/Documents/MyVault/_AI
```

Or create it manually:

```bash
mkdir -p ~/Documents/MyVault/_AI/{Inbox,Outputs,Logs,Memory,Sessions,Projects,Specs,Skills,Templates,Decisions,Briefings,Maintenance}
```

## 3. Choose your AI tool

### Claude Code

Copy:

```bash
cp templates/claude-code/CLAUDE.md ~/Documents/MyVault/_AI/CLAUDE.md
```

Then run Claude Code with the vault or `_AI/` as the working directory, depending on the level of access you want.

### Codex

Copy:

```bash
cp templates/codex/AGENTS.md ~/Documents/MyVault/_AI/AGENTS.md
```

Then run Codex with `_AI/` as the working directory, or with the vault root only if your instruction file clearly protects human notes.

### OpenClaw

Copy:

```bash
cp -R templates/openclaw/* ~/Documents/MyVault/_AI/
```

Set OpenClaw workspace to:

```text
~/Documents/MyVault/_AI
```

## 4. Add the boundary rule

Tell your AI:

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
