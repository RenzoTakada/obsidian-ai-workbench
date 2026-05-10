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
for d in Memory Sessions Outputs Logs Specs Decisions Templates Maintenance Skills Projects Briefings Inbox; do
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
