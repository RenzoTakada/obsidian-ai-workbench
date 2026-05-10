# Security Model

This document defines the operational security model for AI agents working inside an Obsidian vault using this workbench architecture.

---

## Objective

AI agents are powerful but operate with the same filesystem permissions as the user. Without clear rules, an agent can accidentally read sensitive files, modify notes it shouldn't touch, or commit data that should never leave the machine.

This model establishes a permission boundary: the agent works freely inside its workbench folder and asks for explicit confirmation before doing anything outside it.

---

## What the AI can do freely

Inside `_AI/` (or the agent-specific folder):
- Create, edit, organize, and delete files
- Create logs, outputs, specs, sessions, memory files, briefings, decisions
- Generate proposals for changes outside its folder

---

## What the AI cannot do without explicit confirmation

- Read files outside `_AI/`
- Edit files outside `_AI/`
- Create files outside `_AI/`
- Move or rename files outside `_AI/`
- Run destructive commands (see list below)
- Access sensitive paths (see list below)
- Make git commits
- Push to remote repositories

---

## Allowed folders

| Folder | Access |
|---|---|
| `_AI/` | Full — create, edit, organize, delete |
| Rest of the vault | Read/write only with explicit authorization |
| Agent-specific folders (`_Claude/`, `_Codex/`, `_OpenClaw/`) | Only the agent's own folder |

---

## Blocked paths — never access without direct request

```
~/.ssh/
~/.gnupg/
~/.aws/
~/.config/
~/.kube/
~/.docker/
~/.npmrc
~/.netrc
**/.env
**/secrets.*
**/credentials.*
~/Downloads/
~/Desktop/
/etc/
/private/
.git/ (except safe read operations)
```

---

## Dangerous commands — require explicit confirmation

Before running any of the following, show the full command and wait for approval:

```
rm -rf          git reset --hard     DROP TABLE
rm -r           git push --force     TRUNCATE TABLE
delete          git clean -f         DELETE FROM (no WHERE)
truncate        git branch -D        docker rm
wipe            git checkout -- .    docker volume rm
chmod -R        git restore .        docker system prune
chown -R
```

Also: any command that modifies files outside `_AI/`, touches `.git/`, reads credentials, or removes data irreversibly.

---

## Before modifying files outside `_AI/`

1. Show a summary of what will be changed (which files, what changes)
2. Wait for explicit confirmation
3. Create a backup in `_AI/Outputs/` if the file is important
4. Log the action in `_AI/Logs/`

---

## Sensitive data — never commit or expose

Never commit, display, copy, or transmit:
- API keys, tokens, passwords, private keys
- Cookies, session tokens, OAuth secrets
- `.env` files or any credentials file
- Personal identifying information
- Corporate data or client data
- Full vault backups

If sensitive data is found in memory files, notify the user and propose removal — do not act automatically.

---

## Memory — never modify automatically

The AI never deletes or modifies memory files automatically.

Process for any memory change:
1. Identify what should change
2. Generate a proposal in `_AI/Outputs/memory-cleanup-YYYY-MM-DD.md`
3. Present the proposal to the user
4. Wait for explicit confirmation
5. Apply only what was approved
6. Log the change in `_AI/Logs/`

---

## Logging

Log relevant actions in `_AI/Logs/YYYY-MM-DD.md`:
- Memory file creation or modification
- Memory review or cleanup proposals
- Any action outside `_AI/` (with authorization)
- Attempted access to sensitive paths
- Execution of high-impact commands
- Important decisions

---

## When in doubt

If there is any uncertainty about whether an action is safe or authorized:
**Ask for confirmation. Do not act.**

The cost of asking is low. The cost of an unwanted action can be high.

---

## Using this project with corporate data

If your vault contains corporate or client data:
- Keep sensitive notes outside `_AI/` (the agent cannot access them without authorization)
- Never authorize the agent to read files containing credentials or PII
- Review `_AI/Outputs/` before committing anything to a shared repository
- Do not use cloud-synced vaults if the data is confidential
