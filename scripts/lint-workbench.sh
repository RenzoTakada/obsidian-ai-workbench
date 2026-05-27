#!/usr/bin/env bash
# Read-only lint for an Obsidian AI workbench.
set -euo pipefail

ROOT="${1:-.}"
WORKBENCH="${2:-}"
ISSUES=0

report() {
  printf 'lint: %s\n' "$1"
  ISSUES=$((ISSUES + 1))
}

find_workbench() {
  if [ -n "$WORKBENCH" ]; then
    printf '%s\n' "$WORKBENCH"
    return
  fi

  for candidate in "$ROOT/_AI"; do
    if [ -d "$candidate" ]; then
      printf '%s\n' "$candidate"
      return
    fi
  done

  find "$ROOT" -maxdepth 3 -type d -name '_AI' | head -n 1
}

BRAIN="$(find_workbench)"

if [ -z "$BRAIN" ] || [ ! -d "$BRAIN" ]; then
  echo "lint: no workbench folder found. Pass vault path as first argument or workbench path as second argument."
  exit 2
fi

echo "lint: checking $BRAIN"

check_broken_links() {
  local link_regex='\]\(([^)]*)\)'

  while IFS= read -r file; do
    dir="$(dirname "$file")"
    while IFS= read -r line; do
      rest="$line"
      while [[ "$rest" =~ $link_regex ]]; do
        target="${BASH_REMATCH[1]}"
        rest="${rest#*"${BASH_REMATCH[0]}"}"

        case "$target" in
          http://*|https://*|mailto:*|\#*|'')
            continue
            ;;
        esac

        target="${target%%#*}"
        target="${target%%\?*}"

        if [ ! -e "$dir/$target" ] && [ ! -e "$BRAIN/$target" ]; then
          report "broken link in ${file#$ROOT/}: $target"
        fi
      done
    done < "$file"
  done < <(find "$BRAIN" -type f -name '*.md')
}

check_orphan_memory() {
  index="$BRAIN/Memory/MEMORY.md"
  [ -f "$index" ] || {
    report "missing Memory/MEMORY.md"
    return
  }

  while IFS= read -r file; do
    base="$(basename "$file")"
    case "$base" in
      MEMORY.md|hot.md)
        continue
        ;;
    esac

    if ! grep -Fq "$base" "$index"; then
      report "memory file not linked from MEMORY.md: ${file#$BRAIN/}"
    fi
  done < <(find "$BRAIN/Memory" -maxdepth 1 -type f -name '*.md')
}

check_old_outputs() {
  [ -d "$BRAIN/Outputs" ] || return

  while IFS= read -r file; do
    if ! grep -Eiq 'reviewed:[[:space:]]*true|status:[[:space:]]*reviewed|promoted:[[:space:]]*true' "$file"; then
      report "old output may need review: ${file#$BRAIN/}"
    fi
  done < <(find "$BRAIN/Outputs" -type f -name '*.md' -mtime +30)
}

check_sensitive_data() {
  if command -v rg >/dev/null 2>&1; then
    matches="$(rg -n -i '(api[_-]?key|access[_-]?token|refresh[_-]?token|password|secret)[[:space:]]*[:=][[:space:]]*["'\'']?[A-Za-z0-9_./+=-]{12,}|BEGIN (RSA |OPENSSH |EC |DSA )?PRIVATE KEY' "$BRAIN" -g '*.md' -g '!Safety/**' || true)"
  else
    matches="$(grep -RInE '(api[_-]?key|access[_-]?token|refresh[_-]?token|password|secret)[[:space:]]*[:=][[:space:]]*["'\'']?[A-Za-z0-9_./+=-]{12,}|BEGIN (RSA |OPENSSH |EC |DSA )?PRIVATE KEY' "$BRAIN" --include='*.md' 2>/dev/null || true)"
  fi

  if [ -n "$matches" ]; then
    echo "$matches"
    report "possible sensitive data found"
  fi
}

check_broken_links
check_orphan_memory
check_old_outputs
check_sensitive_data

if [ "$ISSUES" -gt 0 ]; then
  echo "lint: found $ISSUES issue(s)"
  exit 1
fi

echo "lint: ok"
