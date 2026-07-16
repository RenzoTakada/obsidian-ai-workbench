#!/usr/bin/env bash
# =============================================================================
# check-template-sync.sh — verifies that the static heredoc blocks embedded in
# install-claude.sh match their canonical reference copy under templates/.
#
# install-claude.sh is self-contained (heredocs, not `cp` from templates/) so
# it can be curled and run standalone. That means templates/ is documentation,
# not the actual install source — and the two can silently drift apart if one
# is edited without the other. This script catches that.
#
# Usage: scripts/check-template-sync.sh
# Exit code 0 = all in sync, 1 = drift found (or a referenced file is missing).
# =============================================================================
set -euo pipefail
cd "$(dirname "$0")/.."

FAIL=0

check() {
  local marker="$1" file="$2"
  if [ ! -f "$file" ]; then
    echo "✗ missing reference file: $file"
    FAIL=1
    return
  fi
  local extracted
  extracted="$(awk "/<< '?${marker}'?\$/{flag=1; next} /^${marker}\$/{flag=0} flag" scripts/install-claude.sh | sed 's/\\\`/\`/g')"
  if [ -z "$extracted" ]; then
    echo "✗ heredoc marker '${marker}' not found in scripts/install-claude.sh"
    FAIL=1
    return
  fi
  if ! diff -q <(printf '%s\n' "$extracted") "$file" >/dev/null 2>&1; then
    echo "✗ drift: install-claude.sh heredoc '${marker}' != ${file}"
    FAIL=1
  else
    echo "✓ ${marker} == ${file}"
  fi
}

check CLAUDEMD    templates/claude-code/CLAUDE.md
check SRULES      templates/generic/_AI/Safety/SECURITY_RULES.md
check DCMDS       templates/generic/_AI/Safety/DANGEROUS_COMMANDS.md
check SPATHS      templates/generic/_AI/Safety/SENSITIVE_PATHS.md
check MCHECK      templates/generic/_AI/Maintenance/MEMORY_CLEANUP_CHECKLIST.md
check MHEALTH     templates/generic/_AI/Maintenance/MEMORY_HEALTH_REPORT.md
check MARCHIVE    templates/generic/_AI/Maintenance/MEMORY_ARCHIVE_POLICY.md
check TMPL        templates/generic/_AI/Templates/memory-review-template.md
check FSPEC       templates/shared/feature-spec-template.md
check APLAN       templates/shared/action-plan-template.md
check CBRAIN      templates/claude-code/.claude/commands/brain.md
check CCONTEXT    templates/claude-code/.claude/commands/context.md
check CSAVE       templates/claude-code/.claude/commands/save.md
check CREVIEW     templates/claude-code/.claude/commands/review-memory.md
check CSPEC       templates/claude-code/.claude/commands/spec.md
check CCHROMEIA   templates/claude-code/.claude/commands/chrome-ia.md
check CCHROMEDEV  templates/claude-code/.claude/commands/chrome-dev-browser.md

echo ""
if [ "$FAIL" -eq 0 ]; then
  echo "check-template-sync: all templates in sync."
else
  echo "check-template-sync: drift detected — update templates/ or install-claude.sh to match, then re-run."
  exit 1
fi
