# Dangerous Commands — Require Explicit Confirmation

Never run without showing the full command and waiting for approval:

## Deletion
rm -rf | rm -r | delete | truncate | clean | wipe | purge | shred

## Destructive git
git reset --hard | git push --force | git clean -f | git checkout -- . | git restore . | git branch -D

## Database
DROP TABLE | DROP DATABASE | TRUNCATE TABLE | DELETE FROM (without WHERE)

## Permissions
chmod -R | chown -R

## Containers
docker rm | docker rmi | docker volume rm | docker system prune | docker-compose down -v

## Any command that:
- Modifies files outside `_Claude/`
- Accesses or modifies .git/
- Reads or writes credentials or tokens
- Removes data irreversibly
