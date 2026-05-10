#!/usr/bin/env bash
set -euo pipefail

# Create a command that always starts Claude Code inside a chosen workbench.
# Usage:
#   ./scripts/create-claude-brain-command.sh /path/to/vault/_Claude [command-name]
# Example:
#   ./scripts/create-claude-brain-command.sh "$HOME/Documents/MyVault/_Claude" claude-brain

WORKBENCH="${1:-}"
COMMAND_NAME="${2:-claude-brain}"
BIN_DIR="$HOME/.local/bin"

if [[ -z "$WORKBENCH" ]]; then
  echo "Usage: $0 /path/to/_Claude [command-name]" >&2
  exit 1
fi

if [[ ! -d "$WORKBENCH" ]]; then
  echo "Workbench does not exist: $WORKBENCH" >&2
  exit 1
fi

if [[ ! -f "$WORKBENCH/CLAUDE.md" ]]; then
  echo "Warning: $WORKBENCH/CLAUDE.md not found. Claude Code may not receive workbench instructions." >&2
fi

if ! command -v claude >/dev/null 2>&1; then
  echo "Claude Code CLI not found in PATH. Install or log in to Claude Code first." >&2
  exit 1
fi

mkdir -p "$BIN_DIR"
TARGET="$BIN_DIR/$COMMAND_NAME"

cat > "$TARGET" <<SCRIPT
#!/usr/bin/env bash
set -euo pipefail
cd "$WORKBENCH"
exec claude "\$@"
SCRIPT

chmod +x "$TARGET"

echo "Created: $TARGET"
echo "Use: $COMMAND_NAME"
echo
if [[ ":$PATH:" != *":$BIN_DIR:"* ]]; then
  echo "Note: $BIN_DIR is not currently in PATH. Add this to your shell profile:"
  echo "  export PATH=\"\$HOME/.local/bin:\$PATH\""
fi
