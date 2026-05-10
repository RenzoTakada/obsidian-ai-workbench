# Codex Brain Command

If you use Codex CLI with an Obsidian workbench, start it from the same `_Codex/` directory whenever you want Codex to operate from that workbench.

A small wrapper command avoids accidentally starting Codex from unrelated folders.

## Goal

Create a command like:

```bash
codex-brain
```

that always runs:

```bash
cd <vault>/_Codex
codex
```

This makes Codex use the `AGENTS.md` and files from the `_Codex/` workbench.

## Create the command

From this repository:

```bash
./scripts/create-codex-brain-command.sh "/path/to/your/vault/_Codex" codex-brain
```

Example:

```bash
./scripts/create-codex-brain-command.sh "$HOME/Documents/MyVault/_Codex" codex-brain
```

Then start Codex with:

```bash
codex-brain
```

## What this does

It creates an executable wrapper at:

```text
~/.local/bin/codex-brain
```

The wrapper:

1. changes directory into your `_Codex/` workbench;
2. checks that the `codex` CLI is available;
3. starts Codex;
4. forwards any arguments to Codex.

## Optional shell alias

Instead of the wrapper script, you can add an alias to your shell profile:

```bash
alias codex-brain='cd /path/to/your/vault/_Codex && codex'
```

The wrapper is usually better because it can produce a clear error when the Codex CLI is not installed or not in `PATH`.
