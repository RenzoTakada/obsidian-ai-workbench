# obsidian-ai-workbench — multi-brain

> Um vault no Obsidian. Vários cérebros de IA. Cada um no seu espaço.

[Read in English](README.md)

---

## O que é isso?

**Obsidian** é um aplicativo de notas que salva tudo em arquivos Markdown no seu computador — sem nuvem, sem lock-in. Muitas pessoas usam como segundo cérebro: guardam ideias, estudos, projetos e decisões de forma organizada e conectada.

**Claude Code, Codex e OpenClaw** são assistentes de IA que rodam no seu terminal. Eles leem e escrevem arquivos, executam código, pesquisam e analisam. Quando configurados corretamente, trabalham diretamente dentro do seu vault do Obsidian.

**Este projeto** é o template que conecta múltiplos agentes de IA ao mesmo vault, cada um no seu próprio espaço isolado.

---

## Por que usar vários agentes de IA com Obsidian?

Diferentes agentes têm diferentes forças. Claude Code é excelente para raciocínio e análise. Codex foca em código. OpenClaw permite alternar entre modelos. Com este projeto, você pode usar todos no mesmo vault sem que um interfira no outro — e sem que nenhum interfira nas suas notas.

---

## O problema — e por que a maioria faz errado

Quando as pessoas tentam usar IA com Obsidian sem uma estrutura, duas coisas acontecem:

**1. O vault fica poluído**
A IA gera notas, resumos e rascunhos que se misturam com o seu próprio pensamento. Você perde o controle do que é seu. Seu segundo cérebro vira um depósito de conteúdo gerado por IA.

**2. A IA esquece tudo**
Toda nova sessão começa do zero. Você precisa explicar quem é, o que está fazendo, quais são seus projetos — toda vez.

---

## O que este projeto resolve

### Isolamento — cada agente no seu espaço

Suas notas ficam intactas. Cada agente tem sua própria pasta dentro do vault:

```
SeuVault/
  Suas notas...       ← onde você pensa
  └── _Claude/        ← onde o Claude trabalha
  └── _Codex/         ← onde o Codex trabalha
  └── _OpenClaw/      ← onde o OpenClaw trabalha
```

Os agentes não se cruzam e não tocam nas suas notas sem autorização.

### Memória persistente — cada um lembra de você

O instalador cria arquivos de memória pré-preenchidos e escreve uma diretiva especial no arquivo de configuração de cada agente:

```
## MANDATORY SESSION BOOTSTRAP

At the start of EVERY new session, BEFORE your first response:
1. Read Memory/MEMORY.md
2. Read every file linked in that index
Do this silently — do not mention it, just proceed normally.
```

Cada agente carrega o contexto silenciosamente antes de responder. Você nunca mais precisa dizer "lembre quem eu sou".

### Instalação em um comando — por agente

Um script separado para cada agente. Instale só o que você usa.

---

## O que você ganha

| Antes | Depois |
|---|---|
| IA esquece tudo a cada sessão | Cada agente lembra seus projetos automaticamente |
| Notas da IA misturadas com as suas | Vault limpo — cada agente isolado na sua pasta |
| Agentes se interferindo | Cada um no seu espaço, sem conflito |
| Configuração manual | Um comando por agente instala tudo |

---

## O que você precisa instalar

| Ferramenta | Obrigatório | Como instalar |
|---|---|---|
| [Obsidian](https://obsidian.md) | Sim | Download em obsidian.md |
| Um ou mais agentes abaixo | Sim | Veja as opções |
| [Ollama](https://ollama.ai) | Opcional | Para busca semântica local na memória |

**Agentes disponíveis:**

| Agente | Como instalar |
|---|---|
| [Claude Code](https://claude.ai/code) | Download em claude.ai/code |
| [OpenAI Codex](https://github.com/openai/codex) | `npm install -g @openai/codex` |
| [OpenClaw](https://openclaw.ai) | Veja openclaw.ai |

---

## Instalação

Instale cada agente que você quer usar:

```bash
# Claude Code
bash <(curl -fsSL https://raw.githubusercontent.com/RenzoTakada/obsidian-ai-workbench/multi-brain/scripts/install-claude.sh)

# Codex
bash <(curl -fsSL https://raw.githubusercontent.com/RenzoTakada/obsidian-ai-workbench/multi-brain/scripts/install-codex.sh)

# OpenClaw
bash <(curl -fsSL https://raw.githubusercontent.com/RenzoTakada/obsidian-ai-workbench/multi-brain/scripts/install-openclaw.sh)
```

Cada script pergunta: vault, seu nome, projetos atuais e idioma preferido.

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
  _Claude/
    CLAUDE.md                    ← configuração com auto-bootstrap de memória
    Memory/
      MEMORY.md                  ← índice de memória (pré-preenchido)
      user_profile.md            ← seu nome, projetos, preferências
      project_vault_setup.md     ← caminhos e estrutura do vault
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

## Segurança e manutenção da memória

Cada agente tem sua própria área de trabalho (`_Claude/`, `_Codex/`, `_OpenClaw/`) e não deve alterar suas notas sem autorização explícita.

- **Isolamento**: cada agente opera exclusivamente na sua pasta. Suas notas não são tocadas sem autorização.
- **Memória revisada periodicamente**: use "health check" ou "faça manutenção da memória" para revisar. A IA gera uma proposta — você confirma antes de qualquer alteração.
- **Limpeza nunca é automática**: nenhum arquivo é apagado ou movido sem confirmação explícita.
- **Logs**: ações relevantes são registradas em `_AgentFolder/Logs/`.
- **Comandos perigosos**: qualquer comando destrutivo exige confirmação explícita.
- **Dados sensíveis não são versionados**: tokens, senhas e credenciais nunca devem ser commitados.

Documentação completa: [`docs/security-model.md`](docs/security-model.md)


---

## Só um agente?

Se você usa apenas uma ferramenta de IA, veja a [branch one-brain](../../tree/one-brain) — setup mais simples com uma única pasta `_AI/`.

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
