# obsidian-ai-workbench — multi-brain

> Um vault no Obsidian. Vários cérebros de IA. Cada um no seu espaço.

[Read in English](README.md)

---

## O problema que isso resolve

Quando você começa a usar uma IA com o Obsidian, duas coisas acontecem:

1. **O vault fica poluído** — notas geradas pela IA se misturam com o seu pensamento, e você perde o controle do que é seu.
2. **A IA esquece tudo** — toda sessão começa do zero, mesmo que você já tenha trabalhado junto por meses.

Este projeto resolve os dois.

---

## A ideia

Seu vault no Obsidian tem três camadas:

```
Suas notas          ← onde você pensa
  └── _Claude/      ← onde o Claude trabalha
  └── _Codex/       ← onde o Codex trabalha
  └── _OpenClaw/    ← onde o OpenClaw trabalha
```

Cada agente de IA tem seu próprio workbench isolado dentro do vault. Eles não tocam nas suas notas sem autorização. E como o workbench vive dentro do vault, ele estará lá na próxima vez que você abrir.

A inovação principal é o **auto-bootstrap**: uma diretiva dentro do arquivo de configuração de cada agente (`CLAUDE.md`, `AGENTS.md`) que força o agente a ler silenciosamente seus arquivos de memória antes da primeira resposta de cada sessão. Você nunca mais precisa dizer "lembre quem eu sou".

---

## O que você precisa

| Ferramenta | Obrigatório | Propósito |
|---|---|---|
| [Obsidian](https://obsidian.md) | Sim | Seu vault de conhecimento pessoal |
| [Claude Code CLI](https://claude.ai/code) | Para workbench Claude | Assistente de código e raciocínio com IA |
| [OpenAI Codex CLI](https://github.com/openai/codex) | Para workbench Codex | Assistente de código com IA |
| [OpenClaw](https://openclaw.ai) | Para workbench OpenClaw | Agente TUI multi-modelo |
| [Ollama](https://ollama.ai) | Opcional | Busca semântica local na memória |

Instale pelo menos um CLI de agente de IA antes de rodar o script de setup.

---

## Instalação

Escolha o(s) agente(s) que você quer:

```bash
# Workbench Claude Code
bash <(curl -fsSL https://raw.githubusercontent.com/RenzoTakada/obsidian-ai-workbench/multi-brain/scripts/install-claude.sh)

# Workbench Codex
bash <(curl -fsSL https://raw.githubusercontent.com/RenzoTakada/obsidian-ai-workbench/multi-brain/scripts/install-codex.sh)

# Workbench OpenClaw
bash <(curl -fsSL https://raw.githubusercontent.com/RenzoTakada/obsidian-ai-workbench/multi-brain/scripts/install-openclaw.sh)
```

Cada script roda um wizard rápido (caminho do vault, seu nome, projetos atuais, idioma preferido) e então:

- Cria a pasta workbench do agente dentro do seu vault
- Escreve o arquivo de configuração com a diretiva de auto-bootstrap de memória
- Cria arquivos de memória pré-preenchidos (`MEMORY.md`, `user_profile.md`, `project_vault_setup.md`)
- Instala um comando de atalho (`claude-brain`, `codex-brain`, `openclaw-brain`)
- Configura busca semântica com Ollama se o Ollama estiver rodando

Depois da instalação, só rodar:

```bash
claude-brain      # abre o Claude Code dentro do seu workbench
codex-brain       # abre o Codex dentro do seu workbench
openclaw-brain    # abre o OpenClaw TUI dentro do seu workbench
```

---

## Como o auto-bootstrap funciona

O arquivo de configuração de cada agente contém:

```
## MANDATORY SESSION BOOTSTRAP

At the start of EVERY new session, BEFORE your first response:
1. Read Memory/MEMORY.md
2. Read every file linked in that index
Do this silently — do not mention it, just proceed normally.
```

O Claude Code lê o `CLAUDE.md` como system prompt. O Codex lê o `AGENTS.md`. Então quando você manda a primeira mensagem, o agente já tem todo o contexto — sem precisar lembrar nada manualmente.

---

## O que o instalador cria

```
SeuVault/
  _Claude/
    CLAUDE.md                    ← configuração com auto-bootstrap
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
    Briefings/
    Skills/
    Projects/
    Inbox/
  _Codex/                        ← mesma estrutura se Codex instalado
  _OpenClaw/                     ← mesma estrutura se OpenClaw instalado

~/.local/bin/claude-brain        ← comando de atalho
~/.local/bin/codex-brain
~/.local/bin/openclaw-brain
~/.claude/CLAUDE.md              ← atualizado com o caminho do workbench (só Claude)
```

---

## Os três fluxos

```
[Você pensa]      Suas notas no Obsidian, Zettelkasten, projetos
      ↓ você autoriza
[IA trabalha]     _Claude/, _Codex/, _OpenClaw/ — cada um no seu espaço
      ↓ você revisa
[Você decide]     O que vira nota permanente no seu segundo cérebro
```

A IA é bibliotecária, revisora e multiplicadora — não é a autora do seu segundo cérebro.

---

## Só um agente?

Se você usa só uma ferramenta de IA, veja a [branch one-brain](../../tree/one-brain) — setup mais simples com uma única pasta `_AI/`.

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
