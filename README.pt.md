# obsidian-ai-workbench

> Um vault no Obsidian. Um workbench para Claude Code. Slash commands nativos. Memoria persistente.

[Read in English](README.md)

---

## O Que É Isso?

**Obsidian** salva suas notas como arquivos Markdown locais.

**Claude Code** é um assistente de IA no terminal que lê e escreve arquivos, executa comandos, inspeciona projetos e ajuda com pesquisa ou implementação.

**obsidian-ai-workbench** conecta os dois com uma estrutura segura: Claude trabalha dentro de uma pasta isolada `_AI/`, carrega memória durável no início da sessão e expõe slash commands nativos do Claude Code como `/brain` e `/save`.

---

## Por Que Existe

Sem estrutura, duas coisas costumam acontecer:

- notas geradas por IA se misturam com suas notas pessoais;
- cada nova sessão começa sem memória dos seus projetos, preferências e decisões.

Este projeto resolve isso criando um workbench dedicado para Claude Code dentro do seu vault.

```
SeuVault/
  Suas notas...       <- onde voce pensa
  _AI/                <- onde Claude trabalha
```

Claude não toca em notas fora de `_AI/` sem autorização explícita.

---

## O Que Você Ganha

| Antes | Depois |
|---|---|
| Claude esquece o contexto a cada sessão | Memória carrega automaticamente |
| Rascunhos da IA misturados com suas notas | Trabalho gerado fica em `_AI/` |
| Prompts improvisados | Slash commands nativos |
| Setup manual | Um instalador |

---

## Slash Commands Nativos

O instalador cria comandos de projeto do Claude Code em `_AI/.claude/commands/`:

| Comando | Objetivo |
|---|---|
| `/brain` | Carregar memória, hot context, última sessão, inbox e briefings |
| `/context` | Resumir o contexto atual sem alterar arquivos |
| `/save` | Rotear informação para memória, outputs, sessões, decisões, specs, inbox ou hot context |
| `/review-memory` | Auditar memória e criar uma proposta de limpeza |
| `/spec` | Criar uma proposta spec-first antes da implementação |
| `/chrome-ia` | Iniciar um perfil persistente do Chrome com debug na porta 9222 |
| `/chrome-dev-browser` | Conectar nessa sessão do Chrome e inspecionar páginas via DOM/HTML |

Os comandos de Chrome exigem Google Chrome no macOS e o CLI `dev-browser` disponível no `PATH`.

Veja [docs/commands.md](docs/commands.md).

---

## Requisitos

| Ferramenta | Obrigatório | Como instalar |
|---|---|---|
| [Obsidian](https://obsidian.md) | Sim | Download em obsidian.md |
| [Claude Code](https://claude.ai/code) | Sim | Download em claude.ai/code |
| [Ollama](https://ollama.ai) | Opcional | Para busca semântica local na memória |

---

## Instalação

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/RenzoTakada/obsidian-ai-workbench/one-brain/scripts/install-claude.sh)
```

Prefere auditar o instalador antes?

```bash
curl -fsSL -o install-claude.sh https://raw.githubusercontent.com/RenzoTakada/obsidian-ai-workbench/one-brain/scripts/install-claude.sh
less install-claude.sh
bash install-claude.sh
```

O script pergunta:

- caminho do seu vault Obsidian;
- seu nome;
- seus projetos atuais;
- seu idioma preferido.

Depois abra Claude Code dentro do workbench:

```bash
claude-brain
```

Ou manualmente:

```bash
cd /caminho/para/SeuVault/_AI
claude
```

---

## O Que O Instalador Cria

```
SeuVault/
  _AI/
    CLAUDE.md                  <- instrucoes do Claude Code e bootstrap de memoria
    .claude/commands/          <- slash commands nativos do Claude Code
    Commands/                  <- documentacao dos comandos
    Memory/
      MEMORY.md                <- indice de memoria
      hot.md                   <- contexto curto para a proxima sessao
      user_profile.md          <- seu perfil e preferencias
      project_vault_setup.md   <- setup do vault/workbench
    Sessions/                  <- notas de sessao
    Outputs/                   <- rascunhos e entregaveis gerados por IA
    Specs/                     <- specs e planos de implementacao
    Decisions/                 <- decisoes e racional
    Templates/                 <- templates reutilizaveis
    Logs/                      <- logs operacionais
    Maintenance/               <- rotinas de revisao de memoria
    Safety/                    <- regras de seguranca
    Archive/                   <- contexto antigo mas util
    Projects/
    Briefings/
    Inbox/

~/.local/bin/claude-brain      <- comando de atalho
~/.claude/CLAUDE.md            <- ponteiro global para o workbench
```

---

## Modelo De Segurança

Claude é bibliotecário, revisor e multiplicador, não o autor do seu segundo cérebro.

- Tudo que Claude cria fica em `_AI/` por padrão.
- Arquivos fora de `_AI/` exigem autorização explícita antes de leitura ou edição.
- Limpeza de memória é proposta antes e aplicada só depois de confirmação.
- Comandos perigosos exigem confirmação explícita.
- Segredos, tokens, chaves privadas e dados de cliente não devem ser salvos na memória.

Documentação completa: [docs/security-model.md](docs/security-model.md).

---

## Demo

Veja [docs/demo-script.md](docs/demo-script.md). Fluxo esperado:

1. Rodar o instalador.
2. Abrir o workbench com `claude-brain`.
3. Salvar uma pequena memória com `/save`.
4. Iniciar uma nova sessão e rodar `/brain`.

---

## Documentação

- [Como funciona](docs/system.md)
- [Setup Claude Code](docs/claude-code.md)
- [Comandos do workbench](docs/commands.md)
- [Contrato de comportamento do Claude Code](docs/claude-code-behavior.md)
- [Workflow spec-first](docs/spec-first-workflow.md)
- [Roteamento de informações](docs/information-routing.md)
- [Schema de memória](docs/memory-schema.md)
- [MCP opcional com Obsidian](docs/mcp-obsidian.md)
- [Lint do workbench](docs/lint-workbench.md)
- [Roteiro de demo](docs/demo-script.md)
- [Embeddings com Ollama](docs/ollama-embeddings.md)
- [Guia de manutenção](docs/maintenance.md)

---

## Licença

MIT. Veja [LICENSE](LICENSE).
