#!/usr/bin/env bash
set -euo pipefail

if ! command -v ollama >/dev/null 2>&1; then
  echo "Ollama is not installed. On macOS, run: brew install ollama" >&2
  exit 1
fi

if command -v brew >/dev/null 2>&1; then
  brew services start ollama || true
else
  echo "Start Ollama manually with: ollama serve" >&2
fi

ollama pull nomic-embed-text

echo "Ollama is ready at http://127.0.0.1:11434 with model nomic-embed-text"
