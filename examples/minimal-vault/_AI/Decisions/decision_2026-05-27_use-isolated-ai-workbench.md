# Decision — Use an isolated AI workbench

Date: 2026-05-27
Status: accepted

## Context

AI-generated notes can pollute personal notes if there is no boundary.

## Decision

Keep all AI-generated drafts, memory, sessions, and logs inside `_AI/`.

## Alternatives considered

- Let the agent write anywhere in the vault.
- Keep all context only in chat history.

## Consequences

- Human notes stay clean.
- AI context is easier to audit.
- The human must explicitly promote outputs into permanent notes.
