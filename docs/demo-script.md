# Demo Script

This script can be used to record a GIF or asciinema demo.

## Goal

Show that the workbench can install, store memory, and recover context in a new Claude Code session.

## Setup

- Use a temporary Obsidian vault or a clean demo vault.
- Do not use real personal, client, or corporate data.
- Use a fake project name such as "Demo Notes".

## Recording flow

1. Install the Claude workbench.

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/RenzoTakada/obsidian-ai-workbench/one-brain/scripts/install-claude.sh)
```

2. Open the workbench.

```bash
claude-brain
```

3. Ask Claude to save a small memory entry.

```text
Save this to memory: I prefer concise answers and I am testing the Demo Notes project.
```

4. End the session.

5. Start a new session.

```bash
claude-brain
```

6. Ask for context recovery.

```text
/brain
```

Expected result: Claude summarizes the stored preference and the active demo project without asking for the context again.

## Suggested asciinema command

```bash
asciinema rec demo.cast
```

After recording, convert to GIF or link the asciinema in the README.
