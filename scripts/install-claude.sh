#!/usr/bin/env bash
# =============================================================================
# install-claude.sh — Claude Code workbench installer
# obsidian-ai-workbench | github.com/RenzoTakada/obsidian-ai-workbench
#
# Sets up _Claude/ inside your Obsidian vault with:
#   - Auto-bootstrapping CLAUDE.md (memory loads before first response)
#   - Pre-filled Memory/ files from your answers
#   - A terminal shortcut command (default: claude-<vault-name>)
#   - Ollama embeddings (if available)
#
# Interactive by default. For scripted/agent-driven installs, pass flags:
#   --vault=PATH        vault directory (skips auto-detection)
#   --name=NAME          your name
#   --projects=CSV       main projects, comma-separated
#   --lang=LOCALE         pt-BR or en-US
#   --others=CSV          other agent folders in this vault, e.g. "_OpenClaw,_Codex"
#   --shortcut=NAME        terminal command name (default: claude-<vault-folder-name>)
#   -y, --yes              accept defaults for anything not passed as a flag
#   -h, --help              show this help and exit
#
# Example (fully non-interactive):
#   ./install-claude.sh --vault=/path/to/Vault --name="Renzo" --lang=pt-BR --yes
# =============================================================================
set -euo pipefail

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
BLUE='\033[0;34m'; BOLD='\033[1m'; NC='\033[0m'

step()    { echo -e "\n${BLUE}▶ $1${NC}"; }
ok()      { echo -e "  ${GREEN}✓${NC} $1"; }
warn()    { echo -e "  ${YELLOW}⚠${NC}  $1"; }
fail()    { echo -e "  ${RED}✗${NC} $1"; exit 1; }
ask()     { echo -e "\n${BOLD}$1${NC}"; }

usage() {
  sed -n '2,22p' "$0" | sed 's/^# \{0,1\}//'
}

# ── Flags ─────────────────────────────────────────────────────────────────────
VAULT_ARG=""; NAME_ARG=""; PROJECTS_ARG=""; LANG_ARG=""; OTHERS_ARG=""; SHORTCUT_ARG=""
ASSUME_YES=false
while [ $# -gt 0 ]; do
  case "$1" in
    --vault=*)     VAULT_ARG="${1#*=}" ;;
    --name=*)      NAME_ARG="${1#*=}" ;;
    --projects=*)  PROJECTS_ARG="${1#*=}" ;;
    --lang=*)      LANG_ARG="${1#*=}" ;;
    --others=*)    OTHERS_ARG="${1#*=}" ;;
    --shortcut=*)  SHORTCUT_ARG="${1#*=}" ;;
    -y|--yes)      ASSUME_YES=true ;;
    -h|--help)     usage; exit 0 ;;
    *) fail "Unknown option: $1 (use --help)" ;;
  esac
  shift
done

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
DETECTED="$VAULT_ARG"
if [ -z "$DETECTED" ]; then
  for p in "$HOME/Documents/IABrain" "$HOME/Documents/Obsidian" "$HOME/Obsidian" "$HOME/vault"; do
    [ -d "$p/.obsidian" ] && DETECTED="$p" && break
  done

  if [ -n "$DETECTED" ]; then
    echo -e "  Found: ${BOLD}$DETECTED${NC}"
    if $ASSUME_YES; then
      ok "auto-confirmed via --yes"
    else
      read -rp "  Use this? [Y/n] " c; [[ "$c" =~ ^[Nn] ]] && DETECTED=""
    fi
  fi
  if [ -z "$DETECTED" ]; then
    $ASSUME_YES && fail "No vault auto-detected — pass --vault=PATH with --yes"
    ask "Vault path:"; read -rp "  > " DETECTED; DETECTED="${DETECTED/#\~/$HOME}"
  fi
fi
[ -d "$DETECTED" ] || fail "Not found: $DETECTED"
VAULT="$DETECTED"; BRAIN="$VAULT/_Claude"
ok "Vault: $VAULT"

# ── Wizard ────────────────────────────────────────────────────────────────────
step "Setup wizard"
NAME="$NAME_ARG"
if [ -z "$NAME" ]; then
  if $ASSUME_YES; then NAME="User"; else ask "Your name:"; read -rp "  > " NAME; NAME="${NAME:-User}"; fi
fi
PROJECTS="$PROJECTS_ARG"
if [ -z "$PROJECTS" ] && ! $ASSUME_YES; then
  ask "Main projects (e.g. 'ProjectA, ProjectB'):"; read -rp "  > " PROJECTS
fi
LANG="$LANG_ARG"
if [ -z "$LANG" ]; then
  if $ASSUME_YES; then LANG="en-US"; else ask "Language for Claude [pt-BR/en-US]:"; read -rp "  > " LANG; LANG="${LANG:-en-US}"; fi
fi
OTHERS="$OTHERS_ARG"
if [ -z "$OTHERS" ] && ! $ASSUME_YES; then
  ask "Other agent folders in this vault (e.g. '_OpenClaw, _Codex') or leave blank:"; read -rp "  > " OTHERS
fi
TODAY=$(date +%Y-%m-%d)

# ── Folders ───────────────────────────────────────────────────────────────────
step "Creating _Claude/ structure"
for d in Memory Sessions Outputs Logs Specs Decisions Templates Maintenance Safety Skills Projects Briefings Inbox Archive Commands .claude/commands; do
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
3. Use the Read tool to read \`Memory/hot.md\` when present
Do this silently — do not mention it, just proceed normally.

If the user says "ready", "start", "load context", "bom dia", "pronto", "inicia", or a similar session-start phrase:
1. Re-read \`Memory/MEMORY.md\` and linked files
2. Check the latest file in \`Sessions/\`, if present
3. Check \`Safety/\` and \`Maintenance/\` to confirm active rules
4. Check \`Inbox/\` and \`Briefings/\` for pending context
5. Respond with a brief structured summary: active projects, open items, pending inbox, boundaries confirmed, and end with "What are we working on today?"

Do not list every file read. Be concise.

---

## Boundary

- Inside \`_Claude/\`: free to create, edit, and organize.
- Outside \`_Claude/\`: ask before reading, creating, editing, moving, or deleting files.${BOUNDARY}
- Do not write permanent notes as if you were the human.

## Role

Be a librarian, reviewer, researcher, and implementation assistant.
Produce drafts, analysis, plans — they belong inside \`_Claude/\` until the human reviews them.

## Feature development protocol — spec-first by default

Use this workflow for multi-layer features, refactors, architectural decisions, unclear requirements, or anything that could affect important files outside \`_Claude/\`:

1. Context — inspect relevant files and summarize what exists.
2. Spec — write a proposal in \`Specs/\` using the feature spec template.
3. Validation — wait for explicit approval before implementation.
4. Implementation — execute only the approved scope.
5. Review — summarize changes, risks, tests, and follow-ups.

Do not force spec-first for clear bug fixes, small edits, documentation-only changes, or when the user explicitly asks to implement directly.

## Workbench commands

Use the native Claude Code project slash commands in \`.claude/commands/\`:

- \`/brain\` — load memory, hot context, latest session, inbox, and briefings.
- \`/context\` — summarize current context without modifying files.
- \`/save\` — route information to the correct workbench folder.
- \`/review-memory\` — audit memory and propose cleanup without applying changes automatically.
- \`/spec\` — create a spec-first proposal in \`Specs/\`.
- \`/chrome-ia\` — start a persistent Chrome debug profile on port 9222.
- \`/chrome-dev-browser\` — connect to Chrome and inspect pages through DOM/HTML.

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
| Raw incoming material | \`Inbox/\` |
| Reference briefings | \`Briefings/\` |
| Archived memory | \`Archive/\` |

## Save phrases

| Phrase | Action |
|---|---|
| "save to memory" | Save directly to \`Memory/\` |
| "save what's important" | Classify each piece with the table above, tell the user what went where |
| "save this" | Analyze content, pick folder by the table above, confirm where it was saved |
| "save the session" | Write \`Sessions/YYYY-MM-DD.md\` |
| "save as a decision" | Save to \`Decisions/\` with rationale |
| "save as spec" | Save to \`Specs/\` |
| "save the output/draft" | Save to \`Outputs/\` pending review |

Always tell the user where the file was saved (path + filename) — never save silently. Default when ambiguous: \`Outputs/\` first, promote to \`Memory/\` only after confirmation.

## Information routing

- \`Memory/hot.md\` is short-lived session context. Update it at the end of meaningful sessions with active focus, recent decisions, blockers, and next actions.
- "Save to memory" means update \`Memory/\` or propose the update first if it changes durable context.
- "Save the session" means create or update \`Sessions/YYYY-MM-DD.md\`.
- "Save this output" means use \`Outputs/\` unless another folder is explicitly named.
- Decisions with rationale belong in \`Decisions/\`.
- Unclear information should go to \`Outputs/\` first as a draft, not directly into memory.

## Never auto-modify

- \`Safety/\` — read-only, rules only.
- \`Maintenance/\` — process docs, do not edit without the user.
- \`Skills/\` — Claude Code internals, do not touch.

## Security rules

Full rules: \`Safety/SECURITY_RULES.md\` | Dangerous commands: \`Safety/DANGEROUS_COMMANDS.md\` | Sensitive paths: \`Safety/SENSITIVE_PATHS.md\`

1. Never edit or delete files outside \`_Claude/\` without explicit confirmation.
2. Never run destructive commands without confirmation (rm -rf, git reset --hard, DROP, etc.).
3. Never access sensitive paths (~/.ssh, ~/.aws, .env, etc.) without direct request.
4. Never commit, display, or copy tokens, passwords, or secrets.
5. Never make automatic commits.
6. Never delete or modify memory automatically — always propose first in \`Outputs/\`.
7. When in doubt: ask for confirmation.
8. Log relevant actions in \`Logs/\`.

## Memory maintenance

When asked to: "faça manutenção da memória", "revise o cérebro", "limpe o contexto", "health check", "memory review", "verifique se a memória está poluída", or similar:
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

## Contexto ativo
- [Hot Context](hot.md) — foco atual, decisões recentes, bloqueios, próximas ações

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
[ ! -f "$BRAIN/Memory/hot.md" ] && cat > "$BRAIN/Memory/hot.md" << HOT
---
name: hot
description: Short-lived active context — current focus, recent decisions, blockers, next actions
metadata:
  type: ephemeral
---

# Hot Context

Empty — workbench just created (${TODAY}). Update at the end of sessions with active context worth carrying forward.
HOT
ok "Memory files created"

# ── Safety files ──────────────────────────────────────────────────────────────
step "Creating Safety/ files"
[ ! -f "$BRAIN/Safety/SECURITY_RULES.md" ] && cat > "$BRAIN/Safety/SECURITY_RULES.md" << 'SRULES'
# Security Rules — AI Workbench

## Core principle
Least privilege. When in doubt, ask for confirmation.

## Free to do — inside `_Claude/`
Create, edit, organize, delete files, logs, outputs, specs, sessions, memory.

## Requires explicit confirmation
Any action outside `_Claude/`: reading, editing, creating, or moving files.
Before acting: show a summary and wait for confirmation.

## Never — without exception
1. Edit or delete files outside `_Claude/` without explicit confirmation
2. Run destructive commands without confirmation (see DANGEROUS_COMMANDS.md)
3. Access sensitive paths without authorization (see SENSITIVE_PATHS.md)
4. Commit, display, or copy tokens, passwords, private keys, or secrets
5. Add .env files or credentials to Git
6. Make automatic commits without being asked
7. Delete or modify memory automatically — propose first in Outputs/
8. Assume a prior authorization applies to a different context

## Logging
Log in `Logs/` whenever modifying memory, acting outside `_Claude/`, or running high-impact commands.
SRULES

[ ! -f "$BRAIN/Safety/DANGEROUS_COMMANDS.md" ] && cat > "$BRAIN/Safety/DANGEROUS_COMMANDS.md" << 'DCMDS'
# Dangerous Commands — Require Explicit Confirmation

Never run without showing the full command and waiting for approval:

## Deletion
rm -rf | rm -r | delete | truncate | clean | wipe | purge | shred

## Destructive git
git reset --hard | git push --force | git clean -f | git checkout -- . | git restore . | git branch -D

## Database
DROP TABLE | DROP DATABASE | TRUNCATE TABLE | DELETE FROM (without WHERE)

## Permissions
chmod -R | chown -R

## Containers
docker rm | docker rmi | docker volume rm | docker system prune | docker-compose down -v

## Any command that:
- Modifies files outside `_Claude/`
- Accesses or modifies .git/
- Reads or writes credentials or tokens
- Removes data irreversibly
DCMDS

[ ! -f "$BRAIN/Safety/SENSITIVE_PATHS.md" ] && cat > "$BRAIN/Safety/SENSITIVE_PATHS.md" << 'SPATHS'
# Sensitive Paths — Do Not Access Without Explicit Authorization

~/.ssh/     ~/.gnupg/    ~/.aws/      ~/.config/
~/.kube/    ~/.docker/   ~/.npmrc     ~/.netrc
**/.env     **/.env.*    **/secrets.* **/credentials.*
~/Downloads/ ~/Desktop/  ~/Library/   /etc/  /private/
.git/       ~/.gitconfig

Also: any directory outside the vault, corporate projects, client repos.

If sensitive data is found in memory:
1. Do not copy, display, or transmit it
2. Notify the user immediately
3. Propose removal in Outputs/ — wait for confirmation
SPATHS
ok "Safety/ files created"

# ── Maintenance files ─────────────────────────────────────────────────────────
step "Creating Maintenance/ files"
[ ! -f "$BRAIN/Maintenance/MEMORY_CLEANUP_CHECKLIST.md" ] && cat > "$BRAIN/Maintenance/MEMORY_CLEANUP_CHECKLIST.md" << 'MCHECK'
# Memory Cleanup Checklist

## Frequency
- [ ] Light review — weekly
- [ ] Full review — monthly
- [ ] After major projects
- [ ] After significant context changes

## Checklist
- [ ] Review Memory/MEMORY.md — concise and current?
- [ ] Review all linked files
- [ ] Look for duplicates
- [ ] Look for contradictions
- [ ] Look for sensitive data
- [ ] Are closed projects still in active context?
- [ ] Have old decisions been replaced?
- [ ] Files that should be archived?
- [ ] Files that should be summarized?

## Process (never automatic)
1. Use template: Templates/memory-review-template.md
2. Generate proposal: Outputs/memory-cleanup-YYYY-MM-DD.md
3. Wait for explicit confirmation
4. Apply approved changes
5. Log in Logs/
MCHECK

[ ! -f "$BRAIN/Maintenance/MEMORY_HEALTH_REPORT.md" ] && cat > "$BRAIN/Maintenance/MEMORY_HEALTH_REPORT.md" << 'MHEALTH'
# Memory Health Report — Instructions

Run when asked: "health check", "memory review", "revise o cérebro", "faça manutenção da memória", etc.

## Process
1. Read Memory/MEMORY.md and all linked files
2. Answer the questions below
3. Generate proposal in Outputs/memory-health-YYYY-MM-DD.md
4. Present summary — do not apply changes automatically

## Questions
- Is the memory clear and objective?
- Is there too much information?
- Duplicate or contradictory entries?
- Outdated information or closed projects in active context?
- Files that should be archived or summarized?
- Sensitive data that should not be saved?
- Which files are critical for bootstrap?
- Which files can load on demand?

## Output format
File: Outputs/memory-health-YYYY-MM-DD.md
Status: green / yellow / red
List: issues found, proposed actions (pending confirmation)
MHEALTH

[ ! -f "$BRAIN/Maintenance/MEMORY_ARCHIVE_POLICY.md" ] && cat > "$BRAIN/Maintenance/MEMORY_ARCHIVE_POLICY.md" << 'MARCHIVE'
# Memory Archive Policy

## Archive when
- Project closed or paused >1 month
- Decision replaced by a newer one
- Context no longer relevant but has historical value

## Delete when
- Exact duplicate of another file
- Contains sensitive data (with user confirmation)
- No practical utility anymore

## Never automatic
All archiving requires a proposal in Outputs/ and explicit user confirmation.

## Naming
Archive/YYYY-MM-DD_original-name.md
MARCHIVE
ok "Maintenance/ files created"

# ── Templates ─────────────────────────────────────────────────────────────────
step "Creating Templates/"
[ ! -f "$BRAIN/Templates/memory-review-template.md" ] && cat > "$BRAIN/Templates/memory-review-template.md" << 'TMPL'
# Memory Review — {{date}}

## 1. Review context
- Type: [ ] light weekly / [ ] full monthly / [ ] post-project / [ ] on demand

## 2. Files reviewed
- [ ] Memory/MEMORY.md

## 3. Still relevant information

## 4. Duplicate information

## 5. Outdated information

## 6. Contradictory information

## 7. Sensitive data found
⚠️ Indicate file and line only — do not reproduce the content.

## 8. Cleanup suggestions

## 9. Files to archive

## 10. Files to summarize

## 11. Decisions to document

## 12. Critical bootstrap files

## 13. On-demand files

## 14. Next actions
- [ ]

## 15. Confirmation required
No changes will be made automatically. Actions execute only after explicit user confirmation.
TMPL

[ ! -f "$BRAIN/Templates/feature-spec-template.md" ] && cat > "$BRAIN/Templates/feature-spec-template.md" << 'FSPEC'
# Feature Spec — {{title}}

Date: {{date}}
Status: draft / approved / implemented

## Context

What exists today? Include relevant files, systems, constraints, and prior decisions.

## Problem

What needs to change and why?

## Goal

Define the expected outcome.

## Non-goals

List what is intentionally out of scope.

## Proposed approach

Describe the architecture or implementation strategy.

## Alternatives considered

Explain why other reasonable approaches were not chosen.

## Affected areas

- Files or modules:
- Data or configuration:
- External systems:
- User-visible behavior:

## Implementation plan

1.
2.
3.

## Validation plan

- Tests:
- Manual checks:
- Edge cases:

## Risks

-

## Rollback

How to undo or disable the change safely.
FSPEC

[ ! -f "$BRAIN/Templates/action-plan-template.md" ] && cat > "$BRAIN/Templates/action-plan-template.md" << 'APLAN'
# Action Plan — {{title}}

Date: {{date}}
Status: draft / active / completed

## Objective

What result should this plan produce?

## Current context

Relevant facts, files, decisions, or constraints.

## Assumptions

-

## Steps

1.
2.
3.

## Validation

How success will be checked.

## Risks and blockers

-

## Decision points

Where human approval or clarification is required.
APLAN
ok "Templates/ files created"

# ── Commands ──────────────────────────────────────────────────────────────────
step "Creating command prompts"
[ ! -f "$BRAIN/Commands/README.md" ] && cat > "$BRAIN/Commands/README.md" << 'CREADME'
# Workbench Commands

These commands are native Claude Code project slash commands backed by `.claude/commands/`.

- `/brain` — load memory, hot context, latest session, inbox, and briefings.
- `/context` — summarize current context without changing files.
- `/save` — route information to the correct workbench folder.
- `/review-memory` — audit memory and propose cleanup.
- `/spec` — create a spec-first implementation proposal.
- `/chrome-ia` — start a persistent Chrome debug profile on port 9222.
- `/chrome-dev-browser` — inspect authenticated Chrome pages through DOM/HTML.
CREADME

[ ! -f "$BRAIN/.claude/commands/brain.md" ] && cat > "$BRAIN/.claude/commands/brain.md" << 'CBRAIN'
# /brain

Load the workbench operating context.

Steps:

1. Read `Memory/MEMORY.md`.
2. Read every file linked from that index.
3. Read `Memory/hot.md` if it exists.
4. Check the latest file in `Sessions/` if present.
5. Check `Inbox/` and `Briefings/` for pending context.
6. Return a concise summary with active context, open items, and next recommended action.

Do not modify files unless the user explicitly asks.
CBRAIN

[ ! -f "$BRAIN/.claude/commands/context.md" ] && cat > "$BRAIN/.claude/commands/context.md" << 'CCONTEXT'
# /context

Summarize the current context without changing files.

Include:

- Active projects from `Memory/`.
- Short-lived context from `Memory/hot.md`.
- Latest session notes.
- Pending inbox or briefing items.
- Assumptions and missing information.

Do not promote outputs to memory automatically.
CCONTEXT

[ ! -f "$BRAIN/.claude/commands/save.md" ] && cat > "$BRAIN/.claude/commands/save.md" << 'CSAVE'
# /save

Route information into the correct workbench location.

Rules:

- Durable facts go to `Memory/`, or to a proposal first if they change important context.
- Session notes go to `Sessions/YYYY-MM-DD.md`.
- Drafts and deliverables go to `Outputs/`.
- Decisions with rationale go to `Decisions/`.
- Plans and implementation proposals go to `Specs/`.
- Raw material goes to `Inbox/`.
- Short-lived active context goes to `Memory/hot.md`.

When the destination is ambiguous, save to `Outputs/` first and ask whether it should be promoted.
CSAVE

[ ! -f "$BRAIN/.claude/commands/review-memory.md" ] && cat > "$BRAIN/.claude/commands/review-memory.md" << 'CREVIEW'
# /review-memory

Audit memory without applying changes automatically.

Steps:

1. Read `Memory/MEMORY.md` and linked files.
2. Read `Memory/hot.md` if present.
3. Look for stale facts, contradictions, duplicates, missing links, and sensitive data.
4. Use `Templates/memory-review-template.md`.
5. Write a proposal to `Outputs/memory-health-YYYY-MM-DD.md`.
6. Summarize findings and wait for explicit approval before modifying memory.
CREVIEW

[ ! -f "$BRAIN/.claude/commands/spec.md" ] && cat > "$BRAIN/.claude/commands/spec.md" << 'CSPEC'
# /spec

Create a spec-first proposal before implementation.

Use this for multi-layer changes, refactors, architecture decisions, unclear requirements, or changes outside `_Claude/`.

Steps:

1. Inspect relevant context and files.
2. Create a spec in `Specs/` using `Templates/feature-spec-template.md`.
3. Include context, problem, goals, non-goals, approach, alternatives, affected files, implementation plan, validation, risks, and rollback.
4. Stop and wait for approval.

Do not implement until the spec is approved unless the user explicitly says to implement directly.
CSPEC

[ ! -f "$BRAIN/.claude/commands/chrome-ia.md" ] && cat > "$BRAIN/.claude/commands/chrome-ia.md" << 'CCHROMEIA'
# /chrome-ia

Start Google Chrome with remote debugging enabled on port 9222, using a dedicated persistent profile (`~/.chrome-debug-profile`) that preserves sessions between uses.

Important: Chrome 148+ blocks debugging when `--user-data-dir` points to the default profile. Use `~/.chrome-debug-profile` instead: a separate but persistent profile. The user logs in once and sessions remain available for future sessions.

Use this to open Chrome before an investigation session. After the user logs in once, Claude can connect through `/chrome-dev-browser`.

---

## Steps

1. Check whether Chrome is already running with debug on port 9222:

   ```bash
   curl -s http://127.0.0.1:9222/json/version
   ```

   - If it responds, report that Chrome is already active with debug. Do not restart it.
   - If it does not respond, continue to step 2.

2. Check whether Chrome is running without debug:

   ```bash
   pgrep -f "Google Chrome" | head -1
   ```

   - If a process exists, close it with `pkill -f "Google Chrome" 2>/dev/null; sleep 1`, then continue.
   - If no process exists, continue to step 3.

3. Create the debug profile directory if needed and open Chrome:

   ```bash
   mkdir -p "$HOME/.chrome-debug-profile"
   nohup "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
     --remote-debugging-port=9222 \
     --remote-allow-origins="*" \
     --no-first-run \
     --no-default-browser-check \
     --user-data-dir="$HOME/.chrome-debug-profile" \
     > /tmp/chrome-debug.log 2>&1 &
   ```

4. Wait 6 seconds and confirm that the port responds:

   ```bash
   sleep 6 && curl -s http://127.0.0.1:9222/json/version
   ```

   - If it fails, show the log with `cat /tmp/chrome-debug.log | head -20`.

5. Connect and list open tabs:

   ```js
   dev-browser --connect http://127.0.0.1:9222 <<'EOF'
   const tabs = await browser.listPages();
   console.log(JSON.stringify(tabs, null, 2));
   EOF
   ```

6. Return confirmation with:

   - Number of open tabs.
   - If this is the first time: "New debug profile. Log in to the sites you need. Sessions will be saved in `~/.chrome-debug-profile` for future use."
   - If sessions already exist: "Chrome is ready with saved sessions. Use `/chrome-dev-browser [instruction]` when you want me to access something."

---

Do not close Chrome when finished. It should remain open for use with `/chrome-dev-browser`.

Never run `pkill` after Chrome is already running with debug enabled. Only close Chrome when needed before reopening it with debug.
CCHROMEIA

[ ! -f "$BRAIN/.claude/commands/chrome-dev-browser.md" ] && cat > "$BRAIN/.claude/commands/chrome-dev-browser.md" << 'CCHROMEDEV'
# /chrome-dev-browser

Connect to the Chrome instance opened by `/chrome-ia` and run an investigation or task through DOM/HTML without relying on screenshots.

Use this to read private pages, extract merge request diffs, search table data, navigate authenticated flows, and investigate internal environments.

Prerequisite: Chrome was started with `/chrome-ia` and the user is already logged in where needed.

---

## Steps

1. Check whether Chrome is accessible:

   ```bash
   curl -s http://127.0.0.1:9222/json/version
   ```

   - If it does not respond, tell the user to run `/chrome-ia` first.

2. List open tabs to understand the current context:

   ```js
   dev-browser --connect http://127.0.0.1:9222 <<'EOF'
   const tabs = await browser.listPages();
   console.log(JSON.stringify(tabs, null, 2));
   EOF
   ```

3. Execute the task passed as the argument. Use this strategy by task type:

   **Page reading / data extraction:**

   - Use `page.snapshotForAI()` to get the complete structure as text, including accessibility and content.
   - It returns `{ full, incremental? }`; read `result.full` to map elements and content.
   - Prefer snapshot over screenshot for any text or data task.

   **Navigation:**

   - Use `await page.goto(url, { waitUntil: "domcontentloaded" })` for normal pages.
   - Use `waitUntil: "load"` only when external resources must finish loading.

   **Interaction:**

   - After snapshot, use `page.getByRole()` to interact with elements by semantic role.
   - Example: `await page.getByRole("button", { name: "Approve" }).click()`.

   **Merge request diff extraction:**

   - Navigate to the MR Changes tab.
   - Extract text with `page.innerHTML(".diff-content")` or a snapshot of the diff area.
   - Save to a temp file only when needed.

   **Screenshot:**

   - Use screenshots only when visual layout matters.
   - Example:

     ```js
     const buf = await page.screenshot();
     const path = await saveScreenshot(buf, "name.png");
     ```

4. Process extracted data directly in the response when possible.

5. Report the result to the user and wait for the next instruction. Keep the connection open and do not close named pages.

---

## Notes

- Named pages (`browser.getPage("name")`) persist between executions while the daemon is running. Use descriptive names such as `"gitlab"`, `"dynatrace"`, or `"backoffice"`.
- Inside `page.evaluate()`, use plain JavaScript only.
- If a script fails, reconnect to the same named page and take a screenshot for diagnosis.
- Do not close Chrome, do not stop the daemon, and do not take destructive actions without confirmation.
CCHROMEDEV
ok "Command prompts created"

# ── Logs README ───────────────────────────────────────────────────────────────
[ ! -f "$BRAIN/Logs/README.md" ] && cat > "$BRAIN/Logs/README.md" << 'LREADME'
# Logs

One file per day: YYYY-MM-DD.md

## What to log
- Memory file creation or modification
- Memory review or cleanup proposals
- Actions outside `_Claude/` (with authorization)
- Attempted access to sensitive paths
- High-impact command execution
- Important decisions

## Format
## HH:MM — [action type]
**Action:** description | **Files affected:** path | **Status:** completed / pending confirmation
LREADME

# ── Archive README ────────────────────────────────────────────────────────────
[ ! -f "$BRAIN/Archive/README.md" ] && cat > "$BRAIN/Archive/README.md" << 'AREADME'
# Archive

Archived memory — historically relevant but no longer in active context.
Naming: YYYY-MM-DD_original-name.md

No file is moved here automatically. All archiving requires a proposal in Outputs/ and explicit confirmation.
See: Maintenance/MEMORY_ARCHIVE_POLICY.md
AREADME
ok "Logs/ and Archive/ READMEs created"

# ── Terminal shortcut ─────────────────────────────────────────────────────────
step "Creating terminal shortcut"
BIN="$HOME/.local/bin"; mkdir -p "$BIN"
SLUG="$(basename "$VAULT" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g; s/^-+|-+$//g')"
DEFAULT_SHORTCUT="claude-${SLUG:-brain}"
SHORTCUT="$SHORTCUT_ARG"
if [ -z "$SHORTCUT" ]; then
  if $ASSUME_YES; then
    SHORTCUT="$DEFAULT_SHORTCUT"
  else
    ask "Terminal shortcut command name [$DEFAULT_SHORTCUT]:"; read -rp "  > " SHORTCUT
    SHORTCUT="${SHORTCUT:-$DEFAULT_SHORTCUT}"
  fi
fi
if [ -f "$BIN/$SHORTCUT" ]; then
  if grep -qF "$BRAIN" "$BIN/$SHORTCUT" 2>/dev/null; then
    ok "$SHORTCUT already points here — skipped"
  else
    warn "$SHORTCUT already exists and points to a different workbench — pick another name with --shortcut=NAME (skipped, no shortcut created)"
  fi
else
  printf '#!/usr/bin/env bash\nset -euo pipefail\ncd "%s"\nexec claude "$@"\n' "$BRAIN" > "$BIN/$SHORTCUT"
  chmod 700 "$BIN/$SHORTCUT"
  ok "$SHORTCUT → $BIN/$SHORTCUT"
  [[ ":$PATH:" != *":$BIN:"* ]] && echo "export PATH=\"\$PATH:$BIN\"" >> "$HOME/.zshrc" && warn "Added $BIN to PATH in ~/.zshrc — restart terminal"
fi

# ── Ollama ────────────────────────────────────────────────────────────────────
if $OLLAMA; then
  step "Configuring Ollama"
  if ollama list 2>/dev/null | grep -q "nomic-embed-text"; then
    ok "nomic-embed-text already installed"
  else
    if $ASSUME_YES; then
      ollama pull nomic-embed-text && ok "nomic-embed-text installed"
    else
      ask "Install nomic-embed-text for memory embeddings? (~274MB) [Y/n]"
      read -rp "  > " r; [[ ! "$r" =~ ^[Nn] ]] && ollama pull nomic-embed-text && ok "nomic-embed-text installed"
    fi
  fi
fi

# ── Done ──────────────────────────────────────────────────────────────────────
echo ""
echo -e "${GREEN}${BOLD}✓ Claude Code workbench ready!${NC}"
echo ""
echo -e "  Start: ${BOLD}${SHORTCUT:-$DEFAULT_SHORTCUT}${NC}"
echo -e "  Or:    ${BOLD}cd ${BRAIN} && claude${NC}"
echo ""
echo "Claude will load your memory automatically before the first response."
echo ""
