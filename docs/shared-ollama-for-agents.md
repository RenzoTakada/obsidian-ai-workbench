# Shared Ollama for Multiple Agents

Ollama is a local model server. It is not tied to a single AI agent.

Multiple tools can use the same Ollama server:

```text
OpenClaw -> Ollama embeddings
Claude Code -> optional script/MCP/search integration -> Ollama
Codex -> optional search integration -> Ollama
```

## Default endpoint

```text
http://127.0.0.1:11434
```

## Recommended embedding model

```text
nomic-embed-text
```

Install:

```bash
brew install ollama
brew services start ollama
ollama pull nomic-embed-text
```

## Important

Each agent should still have its own workbench and memory files.

Ollama can be shared, but the agent workspaces should remain separate.
