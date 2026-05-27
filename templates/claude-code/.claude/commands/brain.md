# /brain

Load the workbench operating context.

Steps:

1. Read `_AI/Memory/MEMORY.md`.
2. Read every file linked from that index.
3. Read `_AI/Memory/hot.md` if it exists.
4. Check the latest file in `_AI/Sessions/` if present.
5. Check `_AI/Inbox/` and `_AI/Briefings/` for pending context.
6. Return a concise summary with active context, open items, and next recommended action.

Do not modify files unless the user explicitly asks.
