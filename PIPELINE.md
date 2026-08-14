# Pipeline Documentation

## Branching Strategy
- `main`: Production / Stable branch.
- `dev`: Development branch for new features.

## Development Workflow
1. Update `docs/` for any configuration changes.
2. Test scripts in a local environment.
3. Perform a backup before making significant changes to containers.

## Build & Deploy
- `scripts/deploy.sh`: Container initialization.
- `scripts/backup-redroid.sh`: Local data backup.
- `scripts/upload-to-release.sh`: Upload backup files to GitHub Releases.

## Definition of Done (DoD)
- [ ] Scripts run without errors.
- [ ] Documentation is updated (English).
- [ ] Memory Update is performed in `.ai/memory.md`.
- [ ] Changes are pushed to the remote repository.
