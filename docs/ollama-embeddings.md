# Ollama Embeddings

Ollama is optional. It does not replace Obsidian or your main AI model.

## What Ollama does

Ollama can run a local embedding model. Embeddings help the AI search your Markdown notes by meaning instead of exact words.

```text
Obsidian = visual editor for Markdown files
AI tool = reads files and answers questions
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

## Tool-specific configuration

Each AI tool handles embeddings differently. For OpenClaw:

```json5
{
  agents: {
    defaults: {
      memorySearch: {
        provider: "ollama",
        model: "nomic-embed-text",
        remote: {
          baseUrl: "http://127.0.0.1:11434",
          nonBatchConcurrency: 1
        }
      }
    }
  }
}
```

## Important clarification

Ollama does not talk to Obsidian directly.

The AI tool reads Markdown files from disk, asks Ollama for embeddings, and uses those embeddings to search better.
