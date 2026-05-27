# Workbench Lint

The lint script is read-only. It checks a vault or workbench folder for common maintenance issues.

```bash
bash scripts/lint-workbench.sh /path/to/vault
```

Or pass the workbench folder explicitly:

```bash
bash scripts/lint-workbench.sh /path/to/vault /path/to/vault/_AI
```

## Checks

- Broken Markdown links inside the workbench
- Memory files not linked from `Memory/MEMORY.md`
- Old outputs that do not show review or promotion status
- Possible sensitive data patterns

## Exit codes

- `0` means no issues found
- `1` means lint issues found
- `2` means no workbench folder was found

The script does not edit, delete, move, or rewrite files.
