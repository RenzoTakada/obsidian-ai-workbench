# Sensitive Paths — Do Not Access Without Explicit Authorization

Never read, write, list, or reference the paths below without a direct request from the user.

---

## Credentials and keys

```
~/.ssh/
~/.gnupg/
~/.aws/
~/.config/
~/.kube/
~/.docker/
~/.npmrc
~/.netrc
~/.pypirc
**/.env
**/.env.*
**/secrets.*
**/credentials.*
**/keystore.*
```

## System and desktop

```
~/Downloads/
~/Desktop/
~/Library/
/etc/
/var/
/private/
```

## Corporate and external projects

```
Any directory outside the vault
Client or employer projects
Corporate repositories
```

## Vault — outside `_AI/`

```
Human-authored notes
Permanent notes
Any folder not explicitly authorized
```

## Git

```
.git/
~/.gitconfig
~/.gitcredentials
```

---

## If sensitive data is found in memory

1. Do not copy, display, or transmit the data
2. Notify the user immediately
3. Propose removal in `_AI/Outputs/`
4. Wait for confirmation before acting
5. Log the occurrence in `_AI/Logs/`
