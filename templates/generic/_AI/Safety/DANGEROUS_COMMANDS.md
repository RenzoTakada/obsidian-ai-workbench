# Dangerous Commands — Require Explicit Confirmation

Never run the commands below without explicit user confirmation.
Show the full command and wait for approval before executing.

---

## Deletion and cleanup

```
rm -rf
rm -r
delete
truncate
clean
wipe
purge
shred
```

## Destructive git

```
git reset --hard
git push --force / git push -f
git clean -f / git clean -fd
git checkout -- .
git restore .
git branch -D
```

## Database

```
DROP TABLE
DROP DATABASE
TRUNCATE TABLE
DELETE FROM (without WHERE)
```

## Recursive permissions

```
chmod -R
chown -R
```

## Containers and volumes

```
docker rm
docker rmi
docker volume rm
docker system prune
docker-compose down -v
```

## Any command that:

- Modifies files outside `_AI/`
- Accesses or modifies `.git/`
- Reads or writes credentials or tokens
- Removes data irreversibly
- Affects shared infrastructure (CI/CD, cloud, database)
