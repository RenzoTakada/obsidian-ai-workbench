# Ollama Embeddings

Ollama is optional. It does not replace Obsidian or your main AI model.

## What Ollama does

Ollama can run a local embedding model. Embeddings help the AI search your Markdown notes by meaning instead of exact words.

```text
Obsidian = visual editor for Markdown files
Claude Code = reads files and answers questions
Ollama = local semantic search helper
```

## Install Ollama on macOS

```bash
brew install ollama
brew services start ollama
ollama pull nomic-embed-text
```

Check it:

```bash
ollama list
curl http://127.0.0.1:11434/api/version
```

## Recommended embedding model

```text
nomic-embed-text
```

It is small enough for local use and works well for text memory search.

## Claude Code usage

Claude Code works with the Markdown files directly. Ollama is optional helper infrastructure for local semantic search workflows; it is not required for the native slash commands.

## Important clarification

Ollama does not talk to Obsidian directly.

Claude reads Markdown files from disk. Optional search scripts can ask Ollama for embeddings and use those embeddings to search better.
