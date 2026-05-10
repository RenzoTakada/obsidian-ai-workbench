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

# ── Safety / Maintenance / Templates / Logs / Archive ─────────────────────────
step "Creating Safety/, Maintenance/, Templates/, Logs/, Archive/"
[ ! -f "$BRAIN/Safety/SECURITY_RULES.md" ] && printf "# Security Rules\nLeast privilege. Ask when in doubt.\nFree inside _Codex/. Outside: ask and show summary first.\nNever: edit outside _Codex/ without confirmation, run destructive commands, access sensitive paths, expose secrets, auto-commit, auto-delete memory.\n" > "$BRAIN/Safety/SECURITY_RULES.md"
[ ! -f "$BRAIN/Safety/DANGEROUS_COMMANDS.md" ] && printf "# Dangerous Commands\nrm -rf | git reset --hard | git push --force | DROP TABLE | chmod -R | docker rm\nAny command modifying files outside _Codex/, touching .git/, or reading credentials.\n" > "$BRAIN/Safety/DANGEROUS_COMMANDS.md"
[ ! -f "$BRAIN/Safety/SENSITIVE_PATHS.md" ] && printf "# Sensitive Paths\n~/.ssh/ | ~/.aws/ | ~/.docker/ | **/.env | **/secrets.* | ~/Downloads/ | /etc/ | .git/\n" > "$BRAIN/Safety/SENSITIVE_PATHS.md"
[ ! -f "$BRAIN/Maintenance/MEMORY_CLEANUP_CHECKLIST.md" ] && printf "# Memory Cleanup Checklist\nFrequency: weekly light / monthly full / after major projects\n- [ ] Memory/MEMORY.md — current?\n- [ ] Duplicates? Contradictions? Sensitive data? Closed projects?\nProcess (never automatic): template → proposal in Outputs/ → confirm → apply → log\n" > "$BRAIN/Maintenance/MEMORY_CLEANUP_CHECKLIST.md"
[ ! -f "$BRAIN/Maintenance/MEMORY_HEALTH_REPORT.md" ] && printf "# Memory Health Report\nRun when asked: health check, memory review, etc.\nProcess: read Memory/ → answer questions → proposal in Outputs/ → present only, no auto-apply\n" > "$BRAIN/Maintenance/MEMORY_HEALTH_REPORT.md"
[ ! -f "$BRAIN/Templates/memory-review-template.md" ] && printf "# Memory Review — {{date}}\n## Files reviewed | Still relevant | Duplicates | Outdated | Contradictions\n## Sensitive data (file+line only) | Suggestions | To archive | To summarize\n## Decisions to document | Bootstrap files | On-demand files | Next actions\n## Confirmation required — no changes made automatically\n" > "$BRAIN/Templates/memory-review-template.md"
[ ! -f "$BRAIN/Logs/README.md" ] && printf "# Logs — YYYY-MM-DD.md\nLog: memory changes, actions outside _Codex/ (authorized), high-impact commands, decisions.\n" > "$BRAIN/Logs/README.md"
[ ! -f "$BRAIN/Archive/README.md" ] && printf "# Archive — YYYY-MM-DD_original-name.md\nNo file moved here automatically. Requires proposal in Outputs/ and confirmation.\n" > "$BRAIN/Archive/README.md"
ok "Safety/, Maintenance/, Templates/, Logs/, Archive/ created"


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
