# Security

This project is about local AI workflows over personal notes. Security is a first-class concern.

---

## Overview

Claude Code runs with the same filesystem permissions as the user. This project establishes a strict permission boundary: Claude works freely only inside its workbench folder (`_AI/`) and must ask for explicit confirmation before doing anything outside it.

Full model: [`docs/security-model.md`](docs/security-model.md)

---

## What the installers change

The installer scripts are local shell scripts. They do not require sudo. They may create or update:

- A workbench folder inside your Obsidian vault: `_AI/`
- Memory, session, output, spec, decision, maintenance, safety, archive, inbox, and briefing folders inside that workbench
- Claude Code configuration files inside the workbench, such as `CLAUDE.md` and `.claude/commands/*.md`
- The shortcut command `~/.local/bin/claude-brain`
- Claude Code user configuration, such as `~/.claude/CLAUDE.md`
- Your shell startup file only to add `~/.local/bin` to `PATH`, when needed

The installers should not:

- Ask for sudo
- Modify files outside the selected vault except the documented shortcut and Claude Code config files
- Read secrets, private keys, browser cookies, or unrelated project files
- Commit anything to Git automatically

---

## How to audit before installing

Avoid running remote shell scripts blindly. Download, inspect, then execute:

```bash
curl -fsSL -o install-claude.sh https://raw.githubusercontent.com/RenzoTakada/obsidian-ai-workbench/one-brain/scripts/install-claude.sh
less install-claude.sh
bash install-claude.sh
```

Before running an installer, check:

- Which files it writes under your vault
- Whether it writes to `~/.local/bin/`
- Whether it updates Claude Code config such as `~/.claude/CLAUDE.md`
- Whether it changes your shell startup file to include `~/.local/bin`
- Whether it attempts network access beyond downloading optional dependencies

---

## How to uninstall manually

There is no destructive automatic uninstall by design. To remove a workbench manually:

1. Back up anything you want to keep from the workbench folder.
2. Remove the `_AI/` workbench folder from your vault.
3. Remove `~/.local/bin/claude-brain`.
4. Review Claude Code config files such as `~/.claude/CLAUDE.md` and remove the AI Workbench section if present.
5. Optionally remove the `~/.local/bin` PATH line from your shell startup file if you no longer use it.

Do not delete your entire Obsidian vault. Only remove the workbench folder created by this project.

---

## Data that must never be committed

- API keys, tokens, OAuth secrets
- Passwords, private keys, certificates
- `.env` files or any credentials file
- Personal identifying information (PII)
- Corporate or client data
- Full vault backups
- Browser cookies or session tokens

---

## Sensitive paths — not to be accessed without authorization

```
~/.ssh/          ~/.gnupg/        ~/.aws/
~/.kube/         ~/.docker/       ~/.npmrc
~/.config/       **/.env          **/secrets.*
~/Downloads/     ~/Desktop/       /etc/
```

See full list: [`_AI/Safety/SENSITIVE_PATHS.md`](templates/generic/_AI/Safety/SENSITIVE_PATHS.md)

---

## Dangerous commands — require explicit confirmation

```
rm -rf           git reset --hard    DROP TABLE
git push --force git clean -f        docker system prune
chmod -R         chown -R            TRUNCATE TABLE
```

See full list: [`_AI/Safety/DANGEROUS_COMMANDS.md`](templates/generic/_AI/Safety/DANGEROUS_COMMANDS.md)

---

## Confirmation rule

When in doubt between acting automatically or asking for confirmation: **ask for confirmation.**

---

## Backup policy

Before modifying any important file outside `_AI/`, Claude should:
1. Propose the change in `_AI/Outputs/`
2. Wait for user confirmation
3. Create a backup if needed

---

## Log policy

Relevant actions are logged in `_AI/Logs/`:
- Memory changes
- Actions outside `_AI/` (with authorization)
- High-impact commands
- Access attempts to sensitive paths

---

## Memory is never modified automatically

Claude never deletes or rewrites memory files without explicit user confirmation. It generates a proposal first and waits for approval.

---

## Reporting issues

If you find a security issue in the documentation, templates, or installer scripts:
- Open an issue at [github.com/RenzoTakada/obsidian-ai-workbench](https://github.com/RenzoTakada/obsidian-ai-workbench/issues)
- Include a minimal description — no sensitive data, no real tokens
