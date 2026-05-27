# Optional Obsidian MCP

The workbench does not require MCP. It works with plain files. MCP can be added when you want richer access to Obsidian from Claude Code.

## Options

### Filesystem MCP

Use this when you want Claude to read and write Markdown files through a constrained filesystem server.

Recommended boundary:

- Allow the workbench folder, such as `_AI/`
- Avoid granting full-vault write access by default
- Keep human-authored notes read-only unless explicitly needed

### Obsidian Local REST API

Use this when you want Claude workflows to interact with Obsidian through the Local REST API plugin.

Recommended boundary:

- Use a local-only API endpoint
- Store API keys outside the vault
- Do not commit API keys or plugin config
- Prefer read-only operations first
- Require confirmation before creating or modifying notes outside `_AI/`

## Suggested policy

Start without MCP. Add MCP only when a specific workflow needs it:

- Querying notes from inside Obsidian
- Creating links or canvas entries
- Running vault-aware maintenance
- Building dashboards

## Security notes

- MCP servers run with permissions you grant them.
- A broad filesystem MCP can bypass the `_AI/` boundary if misconfigured.
- Treat MCP configuration as security-sensitive.
- Document any MCP setup in `_AI/Memory/project_vault_setup.md`.
