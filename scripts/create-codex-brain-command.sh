#!/usr/bin/env bash
set -euo pipefail

# Create a command that always starts Codex inside a chosen workbench.
# Usage:
#   ./scripts/create-codex-brain-command.sh /path/to/vault/_Codex [command-name]
# Example:
#   ./scripts/create-codex-brain-command.sh "$HOME/Documents/MyVault/_Codex" codex-brain

WORKBENCH="${1:-}"
COMMAND_NAME="${2:-codex-brain}"
BIN_DIR="$HOME/.local/bin"

if [[ -z "$WORKBENCH" ]]; then
  echo "Usage: $0 /path/to/_Codex [command-name]" >&2
  exit 1
fi

if [[ ! -d "$WORKBENCH" ]]; then
  echo "Workbench does not exist: $WORKBENCH" >&2
  exit 1
fi

if [[ ! -f "$WORKBENCH/AGENTS.md" ]]; then
  echo "Warning: $WORKBENCH/AGENTS.md not found. Codex may not receive workbench instructions." >&2
fi

mkdir -p "$BIN_DIR"
TARGET="$BIN_DIR/$COMMAND_NAME"

cat > "$TARGET" <<SCRIPT
#!/usr/bin/env bash
set -euo pipefail
cd "$WORKBENCH"
if ! command -v codex >/dev/null 2>&1; then
  echo "codex CLI not found in PATH. Install/configure Codex CLI first, then run $COMMAND_NAME again." >&2
  exit 127
fi
exec codex "\$@"
SCRIPT

chmod +x "$TARGET"

echo "Created: $TARGET"
echo "Use: $COMMAND_NAME"
echo
if [[ ":$PATH:" != *":$BIN_DIR:"* ]]; then
  echo "Note: $BIN_DIR is not currently in PATH. Add this to your shell profile:"
  echo "  export PATH=\"\$HOME/.local/bin:\$PATH\""
fi
