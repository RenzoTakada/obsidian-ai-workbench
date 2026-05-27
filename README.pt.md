# obsidian-ai-workbench — one-brain

> Um vault no Obsidian. Um cérebro de IA. Que sempre lembra de você.

[Read in English](README.md)

---

## Status da branch

Este repositório usa `one-brain` como branch principal para o setup de workbench único. Se o GitHub abrir outra branch por padrão, troque para `one-brain` para seguir o caminho de instalação documentado.

---

## O que é isso?

**Obsidian** é um aplicativo de notas que salva tudo em arquivos Markdown no seu computador — sem nuvem, sem lock-in. Muitas pessoas usam como segundo cérebro: guardam ideias, estudos, projetos e decisões de forma organizada e conectada.

**Claude Code, Codex e OpenClaw** são assistentes de IA que rodam no seu terminal. Eles leem e escrevem arquivos, executam código, pesquisam, analisam — e se você souber configurar, podem trabalhar diretamente dentro do seu vault do Obsidian.

**Este projeto** é o template que conecta os dois de forma correta.

---

## Por que usar IA com Obsidian?

Imagine ter um assistente que:

- Lê suas notas e entende o contexto do seu trabalho
- Pesquisa, resume e produz rascunhos baseados no que você já sabe
- Lembra dos seus projetos, preferências e decisões entre sessões
- Organiza outputs e logs no seu vault, sem bagunçar suas notas

Isso é o que você ganha quando IA e Obsidian trabalham juntos do jeito certo.

---

## O problema — e por que a maioria faz errado

Quando as pessoas tentam usar IA com Obsidian sem uma estrutura, duas coisas acontecem:

**1. O vault fica poluído**
A IA começa a gerar notas, resumos, rascunhos — e tudo isso se mistura com as suas próprias notas. Você perde o controle do que é seu e do que foi gerado. Seu segundo cérebro vira um depósito de conteúdo de IA.

**2. A IA esquece tudo**
Toda vez que você abre uma nova sessão, precisa explicar do zero quem você é, o que está fazendo, quais são seus projetos. Sem memória persistente, a IA nunca aprende sobre você.

---

## O que este projeto resolve

### Isolamento — cada um no seu espaço

Suas notas ficam intactas. A IA trabalha em uma pasta separada (`_AI/`) dentro do vault:

```
SeuVault/
  Suas notas...       ← onde você pensa
  └── _AI/            ← onde a IA trabalha
```

A IA não toca no que é seu a menos que você autorize explicitamente.

### Memória persistente — ela sempre lembra de você

O instalador cria arquivos de memória pré-preenchidos com seu nome, projetos e preferências. E o arquivo de configuração do agente contém uma diretiva especial:

```
## MANDATORY SESSION BOOTSTRAP

At the start of EVERY new session, BEFORE your first response:
1. Read _AI/Memory/MEMORY.md
2. Read every file linked in that index
Do this silently — do not mention it, just proceed normally.
```

Isso força o agente a carregar a memória silenciosamente antes de responder. Você nunca mais precisa dizer "lembre quem eu sou" — ele simplesmente já sabe.

### Contrato operacional — contexto antes da ação

O workbench também vem com regras reutilizáveis de comportamento para os agentes:

- Frases de início como "ready", "start", "load context", "pronto" e "inicia" recarregam memória, sessões, inbox e briefings.
- Intenções de comando como `/brain`, `/context`, `/save`, `/review-memory` e `/spec` padronizam fluxos comuns.
- `Memory/hot.md` guarda contexto de curto prazo para a próxima sessão.
- Mudanças maiores seguem spec-first: contexto, especificação, validação, implementação e revisão.
- Cada tipo de informação tem destino explícito: memória, sessões, outputs, specs, decisões, logs, inbox, briefings e archive.

### Instalação em um comando

Sem configuração manual. Um script faz tudo: cria as pastas, escreve os arquivos de configuração, preenche a memória inicial e instala um comando de atalho.

---

## O que você ganha

| Antes | Depois |
|---|---|
| IA esquece tudo a cada sessão | IA lembra seus projetos e preferências automaticamente |
| Notas da IA misturadas com as suas | Vault limpo — IA isolada em `_AI/` |
| Configuração manual e trabalhosa | Um comando instala tudo |
| Precisa explicar o contexto toda vez | Contexto carregado automaticamente |

---

## O que você precisa instalar

| Ferramenta | Obrigatório | Como instalar |
|---|---|---|
| [Obsidian](https://obsidian.md) | Sim | Download em obsidian.md |
| Um dos agentes abaixo | Sim | Veja as opções |
| [Ollama](https://ollama.ai) | Opcional | Para busca semântica local na memória |

**Escolha seu agente de IA:**

| Agente | Como instalar |
|---|---|
| [Claude Code](https://claude.ai/code) | Download em claude.ai/code |
| [OpenAI Codex](https://github.com/openai/codex) | `npm install -g @openai/codex` |
| [OpenClaw](https://openclaw.ai) | Veja openclaw.ai |

---

## Instalação

Escolha seu agente e rode o comando:

```bash
# Claude Code
bash <(curl -fsSL https://raw.githubusercontent.com/RenzoTakada/obsidian-ai-workbench/one-brain/scripts/install-claude.sh)

# Codex
bash <(curl -fsSL https://raw.githubusercontent.com/RenzoTakada/obsidian-ai-workbench/one-brain/scripts/install-codex.sh)

# OpenClaw
bash <(curl -fsSL https://raw.githubusercontent.com/RenzoTakada/obsidian-ai-workbench/one-brain/scripts/install-openclaw.sh)
```

Prefere auditar o instalador antes?

```bash
# Claude Code
curl -fsSL -o install-claude.sh https://raw.githubusercontent.com/RenzoTakada/obsidian-ai-workbench/one-brain/scripts/install-claude.sh
less install-claude.sh
bash install-claude.sh

# Codex
curl -fsSL -o install-codex.sh https://raw.githubusercontent.com/RenzoTakada/obsidian-ai-workbench/one-brain/scripts/install-codex.sh
less install-codex.sh
bash install-codex.sh

# OpenClaw
curl -fsSL -o install-openclaw.sh https://raw.githubusercontent.com/RenzoTakada/obsidian-ai-workbench/one-brain/scripts/install-openclaw.sh
less install-openclaw.sh
bash install-openclaw.sh
```

O script vai perguntar:
- Onde está seu vault do Obsidian
- Seu nome
- Seus projetos atuais
- Seu idioma preferido

Depois cria tudo automaticamente.

### Após a instalação

```bash
claude-brain      # abre o Claude Code dentro do seu workbench
codex-brain       # abre o Codex dentro do seu workbench
openclaw-brain    # abre o OpenClaw dentro do seu workbench
```

---

## O que o instalador cria

```
SeuVault/
  _AI/
    CLAUDE.md (ou AGENTS.md)     ← configuração com auto-bootstrap de memória
    Memory/
      MEMORY.md                  ← índice de memória (pré-preenchido)
      hot.md                     ← contexto de curto prazo para a próxima sessão
      user_profile.md            ← seu nome, projetos, preferências
      project_vault_setup.md     ← caminhos e estrutura do vault
    Commands/                    ← documentação das intenções de comando
    .claude/commands/            ← prompts de slash command do Claude Code
    Sessions/                    ← notas de cada sessão
    Outputs/                     ← rascunhos e entregáveis da IA
    Specs/                       ← planos e especificações
    Decisions/                   ← decisões e racional
    Templates/                   ← templates reutilizáveis (revisão de memória, etc.)
    Logs/                        ← log de ações por sessão
    Maintenance/                 ← rotinas de revisão e limpeza da memória
    Safety/                      ← regras de segurança, comandos perigosos, caminhos sensíveis
    Archive/                     ← memórias arquivadas e contextos antigos
    Skills/
    Projects/
    Briefings/
    Inbox/

~/.local/bin/claude-brain        ← comando de atalho
~/.claude/CLAUDE.md              ← atualizado com o caminho do workbench
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

## O que isto não é

- Não é uma plataforma RAG completa nem um produto de banco vetorial.
- Não substitui revisão, julgamento ou autoria humana das notas.
- Não sincroniza automaticamente outputs da IA com notas pessoais.
- Não garante privacidade se o agente usado envia contexto para um serviço cloud.
- Não é gerenciador de segredo. Não salve tokens, senhas, chaves privadas ou dados de cliente na memória.

---

## Segurança e manutenção da memória

A IA tem seu próprio espaço de trabalho (`_AI/`) e não deve modificar suas notas sem autorização explícita.

- **Isolamento**: tudo que a IA cria fica em `_AI/`. Suas notas não são tocadas sem autorização.
- **Memória revisada periodicamente**: a memória acumula ao longo do tempo — revise para manter o contexto limpo e relevante.
- **Limpeza nunca é automática**: quando você pede para "revisar a memória" ou fazer um "health check", a IA gera uma proposta. Você confirma antes de qualquer alteração.
- **Logs**: ações relevantes são registradas em `_AI/Logs/`.
- **Comandos destrutivos**: qualquer comando destrutivo exige confirmação explícita.
- **Dados sensíveis não são versionados**: tokens, senhas e credenciais nunca devem ser commitados.
- **Outputs são revisados por você**: rascunhos gerados pela IA ficam em `_AI/Outputs/` até você decidir o que promover.

Documentação completa: [`docs/security-model.md`](docs/security-model.md)


---

## Demo

Uma demo visual pode ser gravada a partir do roteiro em [`docs/demo-script.md`](docs/demo-script.md). O fluxo esperado é:

1. Rodar o instalador.
2. Abrir o workbench com `claude-brain`.
3. Salvar uma pequena memória.
4. Iniciar uma nova sessão e validar que o agente recupera contexto.

---

## Vault de exemplo

Veja [`examples/demo-vault`](examples/demo-vault) para um workbench anonimizado com memória, hot context, comandos, uma decisão, uma spec, uma sessão, um output, um grafo de memória e um canvas do Obsidian.

---

## Quer usar vários agentes de IA?

Se você quer Claude, Codex e OpenClaw trabalhando no mesmo vault — cada um na sua pasta — veja a [branch multi-brain](../../tree/multi-brain).

---

## Documentação

- [Como funciona — três fluxos](docs/system.md)
- [Comandos do workbench](docs/commands.md)
- [Contrato de comportamento do agente](docs/agent-behavior.md)
- [Workflow spec-first](docs/spec-first-workflow.md)
- [Roteamento de informações](docs/information-routing.md)
- [Schema de memória](docs/memory-schema.md)
- [MCP opcional com Obsidian](docs/mcp-obsidian.md)
- [Lint do workbench](docs/lint-workbench.md)
- [Roteiro de demo](docs/demo-script.md)
- [Setup Claude Code](docs/claude-code.md)
- [Setup Codex](docs/codex.md)
- [Setup OpenClaw](docs/openclaw.md)
- [Embeddings com Ollama](docs/ollama-embeddings.md)
- [Guia de manutenção](docs/maintenance.md)

---

## Licença

MIT. Veja [LICENSE](LICENSE).
