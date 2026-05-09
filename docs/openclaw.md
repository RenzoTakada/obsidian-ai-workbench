# OpenClaw + Obsidian

OpenClaw has a workspace concept, so the cleanest setup is to make `_AI/` the OpenClaw workspace.

```text
MyVault/
  Projects/       # human area
  Permanent Notes/# human area
  _AI/            # OpenClaw workspace
    AGENTS.md
    USER.md
    SOUL.md
    MEMORY.md
    Memory/
    Sessions/
```

## Configure workspace

Set the OpenClaw workspace to:

```text
/path/to/MyVault/_AI
```

## Memory layout

OpenClaw commonly indexes:

```text
MEMORY.md
memory/*.md
```

You can keep a human-friendly `Memory/` folder and a compatibility symlink named `memory` if needed.

## Boundary

Because the OpenClaw workspace is `_AI/`, everything outside it is naturally outside the assistant's home. The assistant should only access the parent vault when explicitly authorized.
