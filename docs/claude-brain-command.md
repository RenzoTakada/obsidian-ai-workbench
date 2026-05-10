# Claude Brain Command

Claude Code stores internal memory per working directory/project. If you start Claude Code from random folders, it may create separate project memories in `~/.claude/projects/...`.

A small wrapper command avoids that by always starting Claude Code inside the same Obsidian workbench, such as `_Claude/`.

## Goal

Create a command like:

```bash
claude-brain
```

that always runs:

```bash
cd <vault>/_Claude
claude
```

This makes Claude Code use the `CLAUDE.md` and files from the `_Claude/` workbench.

## Create the command

From this repository:

```bash
./scripts/create-claude-brain-command.sh "/path/to/your/vault/_Claude" claude-brain
```

Example:

```bash
./scripts/create-claude-brain-command.sh "$HOME/Documents/MyVault/_Claude" claude-brain
```

Then start Claude Code with:

```bash
claude-brain
```

## What this does

It creates an executable wrapper at:

```text
~/.local/bin/claude-brain
```

The wrapper:

1. changes directory into your `_Claude/` workbench;
2. starts Claude Code;
3. forwards any arguments to Claude Code.

## Optional shell alias

Instead of the wrapper script, you can add an alias to your shell profile:

```bash
alias claude-brain='cd /path/to/your/vault/_Claude && claude'
```

The wrapper is usually better because it works from any shell as long as `~/.local/bin` is in your `PATH`.

## Important limitation

This does not change Claude Desktop.

Claude Desktop and Claude Code CLI should not be assumed to share memory. Claude Desktop needs its own project setup, attachments, or MCP/filesystem configuration if you want it to use the same files.

## Avoid global memory hacks

Do not symlink every Claude project memory folder into `_Claude/Memory` by default.

That can make unrelated coding projects leak into your Obsidian workbench. Prefer the explicit `claude-brain` command when you want Claude Code to operate from the Obsidian workbench.
