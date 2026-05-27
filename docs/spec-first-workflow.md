# Spec-First Workflow

Use spec-first when the request is bigger than a direct edit: multi-layer features, refactors, architecture decisions, unclear requirements, external integrations, or anything that can affect important files outside `_AI/`.

## Workflow

1. Context — inspect the current project, files, constraints, and existing decisions.
2. Spec — create a proposal in `_AI/Specs/` before implementation.
3. Validation — wait for explicit human approval.
4. Implementation — execute only the approved scope.
5. Review — summarize what changed, tests run, risks, and follow-ups.

## When not to use it

- Clear bug fixes
- Small documentation edits
- Formatting-only changes
- Explicit user instruction to implement directly
- Low-risk changes fully contained inside `_AI/`

## Minimum spec contents

- Context and problem
- Goal and non-goals
- Proposed architecture or approach
- Why this approach instead of alternatives
- Files, layers, or systems affected
- Implementation plan
- Validation plan
- Risks and rollback notes

Use [`templates/shared/feature-spec-template.md`](../templates/shared/feature-spec-template.md) as the default structure.
