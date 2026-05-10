#!/usr/bin/env bash
# =============================================================================
# install-codex.sh — Codex workbench installer
# obsidian-ai-workbench | github.com/RenzoTakada/obsidian-ai-workbench
# =============================================================================
set -euo pipefail

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
BLUE='\033[0;34m'; BOLD='\033[1m'; NC='\033[0m'

step() { echo -e "\n${BLUE}▶ $1${NC}"; }
ok()   { echo -e "  ${GREEN}✓${NC} $1"; }
warn() { echo -e "  ${YELLOW}⚠${NC}  $1"; }
fail() { echo -e "  ${RED}✗${NC} $1"; exit 1; }
ask()  { echo -e "\n${BOLD}$1${NC}"; }

echo ""
echo -e "${BOLD}Codex — AI Workbench Installer${NC}"
echo -e "obsidian-ai-workbench | Codex setup"
echo ""

# ── Dependencies ──────────────────────────────────────────────────────────────
step "Checking dependencies"
command -v codex &>/dev/null || fail "Codex CLI not found. Install from https://github.com/openai/codex"
ok "codex found"
command -v ollama &>/dev/null && OLLAMA=true || OLLAMA=false
$OLLAMA && ok "ollama found" || warn "ollama not found — optional"

# ── Vault ─────────────────────────────────────────────────────────────────────
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
VAULT="$DETECTED"; BRAIN="$VAULT/_Codex"
ok "Vault: $VAULT"

# ── Wizard ────────────────────────────────────────────────────────────────────
step "Setup wizard"
ask "Your name:"; read -rp "  > " NAME; NAME="${NAME:-User}"
ask "Main projects:"; read -rp "  > " PROJECTS
ask "Language [pt-BR/en-US]:"; read -rp "  > " LANG; LANG="${LANG:-en-US}"
ask "Other agent folders (e.g. '_Claude, _OpenClaw') or leave blank:"; read -rp "  > " OTHERS
TODAY=$(date +%Y-%m-%d)

# ── Folders ───────────────────────────────────────────────────────────────────
step "Creating _Codex/ structure"
for d in Memory Sessions Outputs Logs Specs Decisions Templates Maintenance Safety Skills Projects Briefings Inbox Archive; do
  mkdir -p "$BRAIN/$d"
done
ok "Folders created"

# ── AGENTS.md ─────────────────────────────────────────────────────────────────
step "Creating AGENTS.md"
BOUNDARY=""
for agent in $(echo "${OTHERS:-}" | tr ',' '\n' | xargs 2>/dev/null); do
  [ -n "$agent" ] && BOUNDARY+=$'\n'"- Do not access \`${agent}/\` without explicit authorization."
done

if [ ! -f "$BRAIN/AGENTS.md" ]; then
cat > "$BRAIN/AGENTS.md" << AGENTSMD
# AGENTS.md — Codex Workbench

## MANDATORY SESSION BOOTSTRAP

At the start of EVERY new session, BEFORE your first response:
1. Read \`Memory/MEMORY.md\`
2. Read every file linked in that index
Do this silently — do not mention it, just proceed normally.

---

## Boundary

- Inside \`_Codex/\`: work autonomously.
- Outside \`_Codex/\`: ask before reading or editing.${BOUNDARY}
- Do not write permanent notes on behalf of the human.

## Role

Act as a librarian, coding assistant, and researcher.
Produce drafts and outputs inside \`_Codex/\` — the human reviews them.

## Save locations

| Type | Folder |
|---|---|
| Outputs | \`Outputs/\` |
| Memory | \`Memory/\` |
| Sessions | \`Sessions/YYYY-MM-DD.md\` |
| Specs | \`Specs/\` |
| Decisions | \`Decisions/\` |
| Logs | \`Logs/\` |
AGENTSMD
  ok "AGENTS.md created"
else
  warn "AGENTS.md already exists — skipped"
fi

# ── Memory files ──────────────────────────────────────────────────────────────
step "Creating initial memory"
[ ! -f "$BRAIN/Memory/MEMORY.md" ] && cat > "$BRAIN/Memory/MEMORY.md" << MEM
# Memory — Index

Read this file at the start of every session, then read all linked files.

---

## User
- [User profile](user_profile.md)

## Setup
- [Vault setup](project_vault_setup.md)
MEM
[ ! -f "$BRAIN/Memory/user_profile.md" ] && printf -- "---\ntype: user\ncreated: %s\n---\n\nName: %s\nLanguage: %s\nProjects: %s\nVault: %s\n" "$TODAY" "$NAME" "$LANG" "${PROJECTS:-not set}" "$VAULT" > "$BRAIN/Memory/user_profile.md"
[ ! -f "$BRAIN/Memory/project_vault_setup.md" ] && printf -- "---\ntype: project\ncreated: %s\n---\n\nVault: \`%s\`\nWorkbench: \`%s\`\n\nOutside \`_Codex/\`: ask before reading or editing.\n" "$TODAY" "$VAULT" "$BRAIN" > "$BRAIN/Memory/project_vault_setup.md"
ok "Memory files created"

# ── Safety / Maintenance / Templates ──────────────────────────────────────────
step "Creating Safety/, Maintenance/, Templates/"
[ ! -f "$BRAIN/Safety/SECURITY_RULES.md" ] && cat > "$BRAIN/Safety/SECURITY_RULES.md" << 'SRULES'
# Security Rules — AI Workbench
## Core principle
Least privilege. When in doubt, ask for confirmation.
## Free inside `_Codex/`
Create, edit, organize, delete files, logs, outputs, specs, sessions, memory.
## Requires explicit confirmation
Any action outside `_Codex/`. Show summary and wait for confirmation.
## Never
1. Edit/delete files outside `_Codex/` without confirmation
2. Run destructive commands without confirmation (see DANGEROUS_COMMANDS.md)
3. Access sensitive paths without authorization (see SENSITIVE_PATHS.md)
4. Commit/display/copy tokens, passwords, private keys, or secrets
5. Make automatic commits
6. Delete or modify memory automatically — propose first in Outputs/
SRULES

[ ! -f "$BRAIN/Safety/DANGEROUS_COMMANDS.md" ] && cat > "$BRAIN/Safety/DANGEROUS_COMMANDS.md" << 'DCMDS'
# Dangerous Commands — Require Explicit Confirmation
rm -rf | rm -r | delete | truncate | clean | wipe | purge
git reset --hard | git push --force | git clean -f | git branch -D
DROP TABLE | DROP DATABASE | TRUNCATE TABLE | DELETE FROM (no WHERE)
chmod -R | chown -R
docker rm | docker volume rm | docker system prune
Any command modifying files outside `_Codex/`, touching .git/, or reading credentials.
DCMDS

[ ! -f "$BRAIN/Safety/SENSITIVE_PATHS.md" ] && cat > "$BRAIN/Safety/SENSITIVE_PATHS.md" << 'SPATHS'
# Sensitive Paths — Do Not Access Without Authorization
~/.ssh/ | ~/.gnupg/ | ~/.aws/ | ~/.config/ | ~/.kube/ | ~/.docker/ | ~/.npmrc
**/.env | **/secrets.* | **/credentials.*
~/Downloads/ | ~/Desktop/ | ~/Library/ | /etc/ | /private/
.git/ | Any directory outside the vault | Corporate or client projects
SPATHS

[ ! -f "$BRAIN/Maintenance/MEMORY_CLEANUP_CHECKLIST.md" ] && cat > "$BRAIN/Maintenance/MEMORY_CLEANUP_CHECKLIST.md" << 'MCHECK'
# Memory Cleanup Checklist
## Frequency: weekly light / monthly full / after major projects
## Checklist
- [ ] Memory/MEMORY.md — concise and current?
- [ ] All linked files reviewed
- [ ] Duplicates found?
- [ ] Contradictions found?
- [ ] Sensitive data found?
- [ ] Closed projects in active context?
- [ ] Old decisions replaced?
## Process (never automatic)
1. Template: Templates/memory-review-template.md → 2. Proposal: Outputs/memory-cleanup-YYYY-MM-DD.md → 3. Confirm → 4. Apply → 5. Log
MCHECK

[ ! -f "$BRAIN/Maintenance/MEMORY_HEALTH_REPORT.md" ] && cat > "$BRAIN/Maintenance/MEMORY_HEALTH_REPORT.md" << 'MHEALTH'
# Memory Health Report
Run when asked: "health check", "memory review", "clean the context", etc.
## Process
1. Read Memory/MEMORY.md and all linked files
2. Answer: clear? duplicates? outdated? contradictions? sensitive data? bootstrap too heavy?
3. Generate proposal in Outputs/memory-health-YYYY-MM-DD.md
4. Present summary — do not apply changes automatically
MHEALTH

[ ! -f "$BRAIN/Templates/memory-review-template.md" ] && cat > "$BRAIN/Templates/memory-review-template.md" << 'TMPL'
# Memory Review — {{date}}
## 1. Review context (type / files reviewed)
## 2. Still relevant | 3. Duplicates | 4. Outdated | 5. Contradictions
## 6. Sensitive data found (file + line only — do not reproduce content)
## 7. Cleanup suggestions | 8. Files to archive | 9. Files to summarize
## 10. Decisions to document | 11. Critical bootstrap files | 12. On-demand files
## 13. Next actions
## 14. Confirmation required — no changes made automatically
TMPL

[ ! -f "$BRAIN/Logs/README.md" ] && cat > "$BRAIN/Logs/README.md" << 'LREADME'
# Logs — YYYY-MM-DD.md
Log: memory changes, actions outside _Codex/ (authorized), high-impact commands, sensitive path attempts, important decisions.
Format: ## HH:MM — [type] | Action | Files affected | Status
LREADME

[ ! -f "$BRAIN/Archive/README.md" ] && cat > "$BRAIN/Archive/README.md" << 'AREADME'
# Archive
Naming: YYYY-MM-DD_original-name.md
No file moved here automatically. Requires proposal in Outputs/ and explicit confirmation.
AREADME
ok "Safety/, Maintenance/, Templates/ files created"

# ── codex-brain ───────────────────────────────────────────────────────────────
step "Creating codex-brain command"
BIN="$HOME/.local/bin"; mkdir -p "$BIN"
if [ ! -f "$BIN/codex-brain" ]; then
  printf '#!/usr/bin/env bash\ncd "%s"\nexec codex "$@"\n' "$BRAIN" > "$BIN/codex-brain"
  chmod +x "$BIN/codex-brain"; ok "codex-brain → $BIN/codex-brain"
  [[ ":$PATH:" != *":$BIN:"* ]] && echo "export PATH=\"\$PATH:$BIN\"" >> "$HOME/.zshrc" && warn "Added $BIN to PATH in ~/.zshrc"
else
  warn "codex-brain already exists — skipped"
fi

# ── Ollama ────────────────────────────────────────────────────────────────────
if $OLLAMA; then
  step "Configuring Ollama"
  ollama list 2>/dev/null | grep -q "nomic-embed-text" && ok "nomic-embed-text already installed" || {
    ask "Install nomic-embed-text? (~274MB) [Y/n]"
    read -rp "  > " r; [[ ! "$r" =~ ^[Nn] ]] && ollama pull nomic-embed-text && ok "Installed"
  }
fi

echo ""
echo -e "${GREEN}${BOLD}✓ Codex workbench ready!${NC}"
echo ""
echo -e "  Start: ${BOLD}codex-brain${NC}"
echo -e "  Or:    ${BOLD}cd ${BRAIN} && codex${NC}"
echo ""
