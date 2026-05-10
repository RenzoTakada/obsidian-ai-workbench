# Security

This project is about local AI workflows over personal notes. Security is a first-class concern.

---

## Overview

AI agents run with the same filesystem permissions as the user. This project establishes a strict permission boundary: the agent works freely only inside its workbench folder (`_AI/`) and must ask for explicit confirmation before doing anything outside it.

Full model: [`docs/security-model.md`](docs/security-model.md)

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

Before modifying any important file outside `_AI/`, the agent should:
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

The agent never deletes or rewrites memory files without explicit user confirmation. It generates a proposal first and waits for approval.

---

## Reporting issues

If you find a security issue in the documentation, templates, or installer scripts:
- Open an issue at [github.com/RenzoTakada/obsidian-ai-workbench](https://github.com/RenzoTakada/obsidian-ai-workbench/issues)
- Include a minimal description — no sensitive data, no real tokens
