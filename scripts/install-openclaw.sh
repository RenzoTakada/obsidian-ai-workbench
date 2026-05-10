#!/usr/bin/env bash
# =============================================================================
# install-openclaw.sh — OpenClaw workbench installer
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
echo -e "${BOLD}OpenClaw — AI Workbench Installer${NC}"
echo -e "obsidian-ai-workbench | OpenClaw setup"
echo ""

# ── Dependencies ──────────────────────────────────────────────────────────────
step "Checking dependencies"
command -v openclaw &>/dev/null || fail "OpenClaw not found. Install from https://openclaw.ai"
ok "openclaw found ($(openclaw --version 2>/dev/null | head -1))"
command -v ollama &>/dev/null && OLLAMA=true || OLLAMA=false
$OLLAMA && ok "ollama found" || warn "ollama not found — recommended for OpenClaw memory search (https://ollama.ai)"

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
VAULT="$DETECTED"; BRAIN="$VAULT/_OpenClaw"
ok "Vault: $VAULT"

# ── Wizard ────────────────────────────────────────────────────────────────────
step "Setup wizard"
ask "Your name:"; read -rp "  > " NAME; NAME="${NAME:-User}"
ask "Main projects:"; read -rp "  > " PROJECTS
ask "Language [pt-BR/en-US]:"; read -rp "  > " LANG; LANG="${LANG:-en-US}"
ask "Your timezone (e.g. America/Sao_Paulo):"; read -rp "  > " TZ_VAL; TZ_VAL="${TZ_VAL:-UTC}"
TODAY=$(date +%Y-%m-%d)

# ── Folders ───────────────────────────────────────────────────────────────────
step "Creating _OpenClaw/ structure"
for d in Memory Sessions Outputs Logs Specs Decisions Maintenance Skills Projects Briefings; do
  mkdir -p "$BRAIN/$d"
done
ok "Folders created"

# ── OpenClaw persona files ────────────────────────────────────────────────────
step "Creating OpenClaw config files"

[ ! -f "$BRAIN/SOUL.md" ] && cat > "$BRAIN/SOUL.md" << SOUL
# SOUL.md — Assistant Persona

Be useful, careful, and direct.

You are a working assistant inside a human-owned Obsidian vault.
Respect the boundary between human-authored knowledge and AI-generated work.

Your workspace is \`_OpenClaw/\`. Outside it, ask before acting.
SOUL

[ ! -f "$BRAIN/USER.md" ] && cat > "$BRAIN/USER.md" << USER
# USER.md — User Profile

Name: ${NAME}
Language: ${LANG}
Timezone: ${TZ_VAL}
Projects: ${PROJECTS:-not set}
Vault: ${VAULT}

## Preferences

- Respond in ${LANG}
- Keep responses concise and direct
- Always ask before modifying files outside _OpenClaw/
USER

[ ! -f "$BRAIN/HEARTBEAT.md" ] && cat > "$BRAIN/HEARTBEAT.md" << HEARTBEAT
# HEARTBEAT.md — Operational Rules

## Session start

At the start of every session:
1. Read \`Memory/MEMORY.md\` and all files linked in it
2. Note the current date and last session date
3. Check for any open commitments or pending tasks

## Boundaries

- \`_OpenClaw/\`: full autonomy
- Outside \`_OpenClaw/\`: ask first, always

## Memory maintenance

- Save durable knowledge to \`Memory/\`
- Log each session in \`Sessions/YYYY-MM-DD.md\`
- Review and prune \`Memory/\` monthly
HEARTBEAT

[ ! -f "$BRAIN/Memory/MEMORY.md" ] && cat > "$BRAIN/Memory/MEMORY.md" << MEM
# Memory — Index

Read this file at the start of every session, then read all linked files.

---

## User
- [User profile](user_profile.md)

## Setup
- [Vault setup](vault_setup.md)
MEM

[ ! -f "$BRAIN/Memory/user_profile.md" ] && printf -- "---\ntype: user\ncreated: %s\n---\n\nName: %s\nLanguage: %s\nTimezone: %s\nProjects: %s\nVault: %s\n" "$TODAY" "$NAME" "$LANG" "$TZ_VAL" "${PROJECTS:-not set}" "$VAULT" > "$BRAIN/Memory/user_profile.md"
[ ! -f "$BRAIN/Memory/vault_setup.md" ] && printf -- "---\ntype: project\ncreated: %s\n---\n\nVault: \`%s\`\nWorkbench: \`%s\`\n\nOutside \`_OpenClaw/\`: ask before reading or editing.\n" "$TODAY" "$VAULT" "$BRAIN" > "$BRAIN/Memory/vault_setup.md"

ok "Config files created"

# ── Configure OpenClaw workspace ──────────────────────────────────────────────
step "Configuring OpenClaw"
if openclaw config get agents.defaults.workspace &>/dev/null; then
  CURRENT_WS=$(openclaw config get agents.defaults.workspace 2>/dev/null || echo "")
  if [ "$CURRENT_WS" = "$BRAIN" ]; then
    ok "OpenClaw workspace already set to $BRAIN"
  else
    warn "OpenClaw workspace is currently: $CURRENT_WS"
    ask "Update to $BRAIN? [Y/n]"
    read -rp "  > " r
    if [[ ! "$r" =~ ^[Nn] ]]; then
      openclaw config set agents.defaults.workspace "$BRAIN" 2>/dev/null && ok "Workspace updated" || warn "Could not update — set manually in ~/.openclaw/openclaw.json"
    fi
  fi
else
  warn "Could not read OpenClaw config — set workspace manually: $BRAIN"
fi

# ── Ollama for memory search ──────────────────────────────────────────────────
if $OLLAMA; then
  step "Configuring Ollama for OpenClaw memory search"
  if ollama list 2>/dev/null | grep -q "nomic-embed-text"; then
    ok "nomic-embed-text already installed"
  else
    ask "Install nomic-embed-text for semantic memory search? (~274MB) [Y/n]"
    read -rp "  > " r
    [[ ! "$r" =~ ^[Nn] ]] && ollama pull nomic-embed-text && ok "Installed"
  fi

  # Try to configure OpenClaw memory search
  openclaw config set agents.defaults.memorySearch.provider ollama 2>/dev/null \
    && openclaw config set agents.defaults.memorySearch.model nomic-embed-text 2>/dev/null \
    && openclaw config set agents.defaults.memorySearch.remote.baseUrl "http://127.0.0.1:11434" 2>/dev/null \
    && ok "OpenClaw memory search configured with Ollama" \
    || warn "Could not configure memory search automatically — set manually in ~/.openclaw/openclaw.json"
fi

# ── openclaw-brain ────────────────────────────────────────────────────────────
step "Creating openclaw-brain command"
BIN="$HOME/.local/bin"; mkdir -p "$BIN"
if [ ! -f "$BIN/openclaw-brain" ]; then
  cat > "$BIN/openclaw-brain" << CMD
#!/usr/bin/env bash
# openclaw-brain — Open OpenClaw TUI connected to your workbench
exec openclaw tui "\$@"
CMD
  chmod +x "$BIN/openclaw-brain"; ok "openclaw-brain → $BIN/openclaw-brain"
  [[ ":$PATH:" != *":$BIN:"* ]] && echo "export PATH=\"\$PATH:$BIN\"" >> "$HOME/.zshrc" && warn "Added $BIN to PATH"
else
  warn "openclaw-brain already exists — skipped"
fi

echo ""
echo -e "${GREEN}${BOLD}✓ OpenClaw workbench ready!${NC}"
echo ""
echo -e "  Start: ${BOLD}openclaw-brain${NC}  (or: openclaw tui)"
echo -e "  Vault: ${BOLD}$VAULT${NC}"
echo -e "  Workbench: ${BOLD}$BRAIN${NC}"
echo ""
if $OLLAMA; then
  echo "Run 'openclaw memory index --force' to index your memory files."
  echo ""
fi
