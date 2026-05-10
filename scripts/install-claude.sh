#!/usr/bin/env bash
# =============================================================================
# install-claude.sh — Claude Code workbench installer
# obsidian-ai-workbench | github.com/RenzoTakada/obsidian-ai-workbench
#
# Sets up _Claude/ inside your Obsidian vault with:
#   - Auto-bootstrapping CLAUDE.md (memory loads before first response)
#   - Pre-filled Memory/ files from your answers
#   - claude-brain command
#   - Ollama embeddings (if available)
# =============================================================================
set -euo pipefail

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
BLUE='\033[0;34m'; BOLD='\033[1m'; NC='\033[0m'

step()    { echo -e "\n${BLUE}▶ $1${NC}"; }
ok()      { echo -e "  ${GREEN}✓${NC} $1"; }
warn()    { echo -e "  ${YELLOW}⚠${NC}  $1"; }
fail()    { echo -e "  ${RED}✗${NC} $1"; exit 1; }
ask()     { echo -e "\n${BOLD}$1${NC}"; }

echo ""
echo -e "${BOLD}Claude Code — AI Workbench Installer${NC}"
echo -e "obsidian-ai-workbench | Claude Code setup"
echo ""

# ── Dependencies ──────────────────────────────────────────────────────────────
step "Checking dependencies"
command -v claude &>/dev/null || fail "Claude Code CLI not found. Install from https://claude.ai/code"
ok "claude found ($(claude --version 2>/dev/null | head -1))"
command -v ollama &>/dev/null && OLLAMA=true || OLLAMA=false
$OLLAMA && ok "ollama found" || warn "ollama not found — optional (https://ollama.ai)"

# ── Vault detection ───────────────────────────────────────────────────────────
step "Locating Obsidian vault"
DETECTED=""
for p in "$HOME/Documents/IABrain" "$HOME/Documents/Obsidian" "$HOME/Obsidian" "$HOME/vault"; do
  [ -d "$p/.obsidian" ] && DETECTED="$p" && break
done

if [ -n "$DETECTED" ]; then
  echo -e "  Found: ${BOLD}$DETECTED${NC}"
  read -rp "  Use this? [Y/n] " c; [[ "$c" =~ ^[Nn] ]] && DETECTED=""
fi
if [ -z "$DETECTED" ]; then
  ask "Vault path:"; read -rp "  > " DETECTED; DETECTED="${DETECTED/#\~/$HOME}"
fi
[ -d "$DETECTED" ] || fail "Not found: $DETECTED"
VAULT="$DETECTED"; BRAIN="$VAULT/_Claude"
ok "Vault: $VAULT"

# ── Wizard ────────────────────────────────────────────────────────────────────
step "Setup wizard"
ask "Your name:"; read -rp "  > " NAME; NAME="${NAME:-User}"
ask "Main projects (e.g. 'ProjectA, ProjectB'):"; read -rp "  > " PROJECTS
ask "Language for Claude [pt-BR/en-US]:"; read -rp "  > " LANG; LANG="${LANG:-en-US}"
ask "Other agent folders in this vault (e.g. '_OpenClaw, _Codex') or leave blank:"; read -rp "  > " OTHERS
TODAY=$(date +%Y-%m-%d)

# ── Folders ───────────────────────────────────────────────────────────────────
step "Creating _Claude/ structure"
for d in Memory Sessions Outputs Logs Specs Decisions Templates Maintenance Safety Skills Projects Briefings Inbox Archive; do
  mkdir -p "$BRAIN/$d"
done
ok "Folders created"

# ── CLAUDE.md ─────────────────────────────────────────────────────────────────
step "Creating CLAUDE.md"
BOUNDARY=""
for agent in $(echo "${OTHERS:-}" | tr ',' '\n' | xargs 2>/dev/null); do
  [ -n "$agent" ] && BOUNDARY+=$'\n'"- Do not access \`${agent}/\` without explicit authorization."
done

if [ ! -f "$BRAIN/CLAUDE.md" ]; then
cat > "$BRAIN/CLAUDE.md" << CLAUDEMD
# CLAUDE.md — Claude Code Workbench

## MANDATORY SESSION BOOTSTRAP

At the start of EVERY new session, BEFORE your first response:
1. Use the Read tool to read \`Memory/MEMORY.md\`
2. Use the Read tool to read every file linked in that index
Do this silently — do not mention it, just proceed normally.

---

## Boundary

- Inside \`_Claude/\`: free to create, edit, and organize.
- Outside \`_Claude/\`: ask before reading or editing.${BOUNDARY}
- Do not write permanent notes as if you were the human.

## Role

Be a librarian, reviewer, researcher, and implementation assistant.
Produce drafts, analysis, plans — they belong inside \`_Claude/\` until the human reviews them.

## Save locations

| Type | Folder |
|---|---|
| Drafts and deliverables | \`Outputs/\` |
| Durable memory | \`Memory/\` |
| Session notes | \`Sessions/YYYY-MM-DD.md\` |
| Plans and specs | \`Specs/\` |
| Decisions | \`Decisions/\` |
| Logs | \`Logs/\` |
| Maintenance | \`Maintenance/\` |
| Archived memory | \`Archive/\` |

## Security rules

Full rules: \`Safety/SECURITY_RULES.md\` | Dangerous commands: \`Safety/DANGEROUS_COMMANDS.md\` | Sensitive paths: \`Safety/SENSITIVE_PATHS.md\`

1. Never edit or delete files outside \`_Claude/\` without explicit confirmation.
2. Never run destructive commands without confirmation (rm -rf, git reset --hard, DROP, etc.).
3. Never access sensitive paths (~/.ssh, ~/.aws, .env, etc.) without direct request.
4. Never commit tokens, passwords, or secrets.
5. Never make automatic commits.
6. Never delete or modify memory automatically — always propose first in \`Outputs/\`.
7. When in doubt: ask for confirmation.
8. Log relevant actions in \`Logs/\`.

## Memory maintenance

When asked to: "faça manutenção da memória", "revise o cérebro", "limpe o contexto", "health check", "memory review", or similar:
1. Read all files in \`Memory/\` and linked files
2. Use the template in \`Templates/memory-review-template.md\`
3. Generate a proposal in \`Outputs/memory-health-YYYY-MM-DD.md\`
4. Present the summary — do not apply changes automatically
5. Wait for explicit confirmation
CLAUDEMD
  ok "CLAUDE.md created"
else
  warn "CLAUDE.md already exists — skipped"
fi

# ── Global CLAUDE.md ──────────────────────────────────────────────────────────
step "Updating ~/.claude/CLAUDE.md"
mkdir -p "$HOME/.claude"
if ! grep -q "obsidian-ai-workbench" "$HOME/.claude/CLAUDE.md" 2>/dev/null; then
  cat >> "$HOME/.claude/CLAUDE.md" << GLOBAL

# AI Workbench — obsidian-ai-workbench

## Workbench
\`${BRAIN}\`

## Memory
At the start of any session, read \`${BRAIN}/Memory/MEMORY.md\` and all linked files — silently, before the first response.

## Rules
- Inside \`_Claude/\`: free to create, edit, organize.
- Outside: ask first.
- Do not write permanent notes as if you were the human.
GLOBAL
  ok "~/.claude/CLAUDE.md updated"
else
  warn "~/.claude/CLAUDE.md already has workbench config — skipped"
fi

# ── Memory files ──────────────────────────────────────────────────────────────
step "Creating initial memory"
[ ! -f "$BRAIN/Memory/MEMORY.md" ] && cat > "$BRAIN/Memory/MEMORY.md" << MEM
# Memory — Index

Read this file at the start of every session, then read all linked files.

---

## User
- [User profile](user_profile.md) — who is the user, stack, tools, preferences

## Setup
- [Vault setup](project_vault_setup.md) — vault structure, agent folders
MEM
[ ! -f "$BRAIN/Memory/user_profile.md" ] && cat > "$BRAIN/Memory/user_profile.md" << PROFILE
---
type: user
created: ${TODAY}
---

Name: ${NAME}
Language: ${LANG}
Projects: ${PROJECTS:-not set}
Vault: ${VAULT}
PROFILE
[ ! -f "$BRAIN/Memory/project_vault_setup.md" ] && cat > "$BRAIN/Memory/project_vault_setup.md" << SETUP
---
type: project
created: ${TODAY}
---

Vault: \`${VAULT}\`
Workbench: \`${BRAIN}\`

Outside \`_Claude/\`: ask before reading or editing.
SETUP
ok "Memory files created"

# ── Safety files ──────────────────────────────────────────────────────────────
step "Creating Safety/ files"
[ ! -f "$BRAIN/Safety/SECURITY_RULES.md" ] && cat > "$BRAIN/Safety/SECURITY_RULES.md" << 'SRULES'
# Security Rules — AI Workbench
## Core principle: Least privilege. When in doubt, ask for confirmation.
## Free inside `_Claude/`: Create, edit, organize, delete files, logs, outputs, specs, sessions, memory.
## Requires explicit confirmation: Any action outside `_Claude/`. Show summary and wait.
## Never:
1. Edit/delete files outside `_Claude/` without confirmation
2. Run destructive commands without confirmation (see DANGEROUS_COMMANDS.md)
3. Access sensitive paths without authorization (see SENSITIVE_PATHS.md)
4. Commit/display/copy tokens, passwords, private keys, or secrets
5. Make automatic commits without being asked
6. Delete or modify memory automatically — propose first in Outputs/
SRULES

[ ! -f "$BRAIN/Safety/DANGEROUS_COMMANDS.md" ] && cat > "$BRAIN/Safety/DANGEROUS_COMMANDS.md" << 'DCMDS'
# Dangerous Commands — Require Explicit Confirmation
rm -rf | rm -r | delete | truncate | clean | wipe | purge
git reset --hard | git push --force | git clean -f | git branch -D
DROP TABLE | DROP DATABASE | TRUNCATE TABLE | DELETE FROM (no WHERE)
chmod -R | chown -R | docker rm | docker volume rm | docker system prune
Any command modifying files outside `_Claude/`, touching .git/, or reading credentials.
DCMDS

[ ! -f "$BRAIN/Safety/SENSITIVE_PATHS.md" ] && cat > "$BRAIN/Safety/SENSITIVE_PATHS.md" << 'SPATHS'
# Sensitive Paths — Do Not Access Without Authorization
~/.ssh/ | ~/.gnupg/ | ~/.aws/ | ~/.config/ | ~/.kube/ | ~/.docker/ | ~/.npmrc
**/.env | **/secrets.* | **/credentials.*
~/Downloads/ | ~/Desktop/ | ~/Library/ | /etc/ | /private/
.git/ | Any directory outside the vault | Corporate or client projects
SPATHS
ok "Safety/ files created"

# ── Maintenance / Templates / Logs / Archive ──────────────────────────────────
step "Creating Maintenance/, Templates/, Logs/, Archive/"
[ ! -f "$BRAIN/Maintenance/MEMORY_CLEANUP_CHECKLIST.md" ] && cat > "$BRAIN/Maintenance/MEMORY_CLEANUP_CHECKLIST.md" << 'MCHECK'
# Memory Cleanup Checklist
## Frequency: weekly light / monthly full / after major projects
- [ ] Memory/MEMORY.md — concise and current? | All linked files reviewed
- [ ] Duplicates? | Contradictions? | Sensitive data? | Closed projects in active context?
## Process (never automatic):
1. Template → 2. Proposal in Outputs/ → 3. Confirm → 4. Apply → 5. Log
MCHECK

[ ! -f "$BRAIN/Maintenance/MEMORY_HEALTH_REPORT.md" ] && cat > "$BRAIN/Maintenance/MEMORY_HEALTH_REPORT.md" << 'MHEALTH'
# Memory Health Report
Run when asked: "health check", "memory review", "revise o cérebro", "faça manutenção da memória", etc.
Process: 1. Read Memory/ → 2. Answer questions → 3. Generate proposal in Outputs/ → 4. Present — do not apply automatically
MHEALTH

[ ! -f "$BRAIN/Templates/memory-review-template.md" ] && cat > "$BRAIN/Templates/memory-review-template.md" << 'TMPL'
# Memory Review — {{date}}
## 1. Files reviewed | 2. Still relevant | 3. Duplicates | 4. Outdated | 5. Contradictions
## 6. Sensitive data (file + line only) | 7. Cleanup suggestions | 8. To archive | 9. To summarize
## 10. Decisions to document | 11. Critical bootstrap files | 12. On-demand files
## 13. Next actions | 14. Confirmation required — no changes made automatically
TMPL

[ ! -f "$BRAIN/Logs/README.md" ] && cat > "$BRAIN/Logs/README.md" << 'LREADME'
# Logs — YYYY-MM-DD.md
Log: memory changes, actions outside _Claude/ (authorized), high-impact commands, important decisions.
Format: ## HH:MM — [type] | Action | Files affected | Status
LREADME

[ ! -f "$BRAIN/Archive/README.md" ] && cat > "$BRAIN/Archive/README.md" << 'AREADME'
# Archive — Naming: YYYY-MM-DD_original-name.md
No file moved here automatically. Requires proposal in Outputs/ and explicit confirmation.
AREADME
ok "Maintenance/, Templates/, Logs/, Archive/ files created"


# ── claude-brain ──────────────────────────────────────────────────────────────
step "Creating claude-brain command"
BIN="$HOME/.local/bin"; mkdir -p "$BIN"
if [ ! -f "$BIN/claude-brain" ]; then
  printf '#!/usr/bin/env bash\ncd "%s"\nexec claude "$@"\n' "$BRAIN" > "$BIN/claude-brain"
  chmod +x "$BIN/claude-brain"; ok "claude-brain → $BIN/claude-brain"
  [[ ":$PATH:" != *":$BIN:"* ]] && echo "export PATH=\"\$PATH:$BIN\"" >> "$HOME/.zshrc" && warn "Added $BIN to PATH in ~/.zshrc — restart terminal"
else
  warn "claude-brain already exists — skipped"
fi

# ── Ollama ────────────────────────────────────────────────────────────────────
if $OLLAMA; then
  step "Configuring Ollama"
  if ollama list 2>/dev/null | grep -q "nomic-embed-text"; then
    ok "nomic-embed-text already installed"
  else
    ask "Install nomic-embed-text for memory embeddings? (~274MB) [Y/n]"
    read -rp "  > " r; [[ ! "$r" =~ ^[Nn] ]] && ollama pull nomic-embed-text && ok "nomic-embed-text installed"
  fi
fi

# ── Done ──────────────────────────────────────────────────────────────────────
echo ""
echo -e "${GREEN}${BOLD}✓ Claude Code workbench ready!${NC}"
echo ""
echo -e "  Start: ${BOLD}claude-brain${NC}"
echo -e "  Or:    ${BOLD}cd ${BRAIN} && claude${NC}"
echo ""
echo "Claude will load your memory automatically before the first response."
echo ""
