# obsidian-ai-workbench — one-brain

> Um vault no Obsidian. Um cérebro de IA. Que sempre lembra de você.

[Read in English](README.md)

---

## O problema que isso resolve

Quando você começa a usar uma IA com o Obsidian, duas coisas acontecem:

1. **O vault fica poluído** — notas geradas pela IA se misturam com o seu pensamento, e você perde o controle do que é seu.
2. **A IA esquece tudo** — toda sessão começa do zero, mesmo que você já tenha trabalhado junto por meses.

Este projeto resolve os dois.

---

## A ideia

Seu vault no Obsidian tem duas zonas bem definidas:

```
Suas notas          ← onde você pensa
  └── _AI/          ← onde a IA trabalha
```

A IA tem seu próprio workbench isolado dentro do vault. Ela não toca nas suas notas sem autorização. E como o workbench vive dentro do vault, tudo persiste entre as sessões.

A inovação principal é o **auto-bootstrap**: uma diretiva dentro do arquivo de configuração do agente (`CLAUDE.md` ou `AGENTS.md`) que força o agente a ler silenciosamente seus arquivos de memória antes da primeira resposta de cada sessão. Você nunca mais precisa dizer "lembre quem eu sou".

---

## O que você precisa

| Ferramenta | Obrigatório | Propósito |
|---|---|---|
| [Obsidian](https://obsidian.md) | Sim | Seu vault de conhecimento pessoal |
| Uma das opções abaixo | Sim | Seu assistente de IA |
| [Ollama](https://ollama.ai) | Opcional | Busca semântica local na memória |

Escolha seu agente de IA:

| Agente | Instalação |
|---|---|
| [Claude Code CLI](https://claude.ai/code) | `brew install claude` ou baixar |
| [OpenAI Codex CLI](https://github.com/openai/codex) | `npm install -g @openai/codex` |
| [OpenClaw](https://openclaw.ai) | Veja openclaw.ai |

---

## Instalação

Escolha seu agente e rode um comando:

```bash
# Claude Code
bash <(curl -fsSL https://raw.githubusercontent.com/RenzoTakada/obsidian-ai-workbench/one-brain/scripts/install-claude.sh)

# Codex
bash <(curl -fsSL https://raw.githubusercontent.com/RenzoTakada/obsidian-ai-workbench/one-brain/scripts/install-codex.sh)

# OpenClaw
bash <(curl -fsSL https://raw.githubusercontent.com/RenzoTakada/obsidian-ai-workbench/one-brain/scripts/install-openclaw.sh)
```

O script roda um wizard rápido (caminho do vault, seu nome, projetos atuais, idioma preferido) e então:

- Cria a pasta `_AI/` dentro do seu vault
- Escreve o arquivo de configuração do agente com a diretiva de auto-bootstrap de memória
- Cria arquivos de memória pré-preenchidos (`MEMORY.md`, `user_profile.md`, `project_vault_setup.md`)
- Instala um comando de atalho (`claude-brain`, `codex-brain` ou `openclaw-brain`)
- Configura busca semântica com Ollama se o Ollama estiver rodando

Depois da instalação, só rodar:

```bash
claude-brain     # abre o Claude Code dentro do seu workbench
# ou
codex-brain      # abre o Codex dentro do seu workbench
# ou
openclaw-brain   # abre o OpenClaw TUI dentro do seu workbench
```

---

## Como o auto-bootstrap funciona

O arquivo de configuração do agente contém:

```
## MANDATORY SESSION BOOTSTRAP

At the start of EVERY new session, BEFORE your first response:
1. Read _AI/Memory/MEMORY.md
2. Read every file linked in that index
Do this silently — do not mention it, just proceed normally.
```

O Claude Code lê o `CLAUDE.md` como system prompt. O Codex lê o `AGENTS.md`. Então quando você manda a primeira mensagem, o agente já tem todo o contexto — sem precisar lembrar nada manualmente.

---

## O que o instalador cria

```
SeuVault/
  _AI/
    CLAUDE.md (ou AGENTS.md)     ← configuração com auto-bootstrap
    Memory/
      MEMORY.md                  ← índice de memória (pré-preenchido)
      user_profile.md            ← seu nome, projetos, preferências
      project_vault_setup.md     ← caminhos e estrutura do vault
    Sessions/
    Outputs/
    Specs/
    Decisions/
    Templates/
    Logs/
    Maintenance/

~/.local/bin/claude-brain        ← comando de atalho
~/.claude/CLAUDE.md              ← atualizado com o caminho do workbench (só Claude)
```

---

## Os três fluxos

```
[Você pensa]      Suas notas no Obsidian, Zettelkasten, projetos
      ↓ você autoriza
[IA trabalha]     _AI/ — workbench isolado das suas notas
      ↓ você revisa
[Você decide]     O que vira nota permanente no seu segundo cérebro
```

A IA é bibliotecária, revisora e multiplicadora — não é a autora do seu segundo cérebro.

---

## Quer usar vários agentes de IA?

Se você quer Claude, Codex e OpenClaw trabalhando no mesmo vault — cada um na sua pasta — veja a [branch multi-brain](../../tree/multi-brain).

---

## Documentação

- [Como funciona — três fluxos](docs/system.md)
- [Setup Claude Code](docs/claude-code.md)
- [Setup Codex](docs/codex.md)
- [Setup OpenClaw](docs/openclaw.md)
- [Embeddings com Ollama](docs/ollama-embeddings.md)
- [Guia de manutenção](docs/maintenance.md)

---

## Licença

MIT. Veja [LICENSE](LICENSE).
