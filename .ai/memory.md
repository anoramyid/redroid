# memory.md · Redroid Repo
<!-- 
  Attach alongside TSA-X.md at every session start.
  AI maintains this file. Human pastes MEMORY UPDATE blocks here after each session.
  Workflow: copy === MEMORY UPDATE === from AI response → paste to [LOG] → save
-->

## [PROJECT]
Name    : Redroid Repo
Stack   : Redroid (Docker) | Shell Scripting
Root    : /home/sam/Documents/redroid-repo
Created : 2026-08-14

## [ENV & PORTS]
- GApps Instance: Port 5555
- Non-GApps Instance: Port 5581
- Docker Host: localhost (or specific IP)

## [OPEN ISSUES] ← AI reads this before starting any work
STATUS      PRI   DESCRIPTION
─────────────────────────────────────────────────────────
(none)

## [LOG] ← paste MEMORY UPDATE blocks here, newest on top
[2026-08-14 09:45]  FILE_NEW — scripts/upload-to-release.sh created
                    RESOLVED — Initial backup (1.5GB total) uploaded to GitHub Releases v1.0.0-initial-backup
                    DOCS — README.md and PIPELINE.md updated with release automation steps
                    NOTE — Verified 'gh' CLI is authenticated and functional for 'anoramyid'

[2026-08-14 09:35]  FILE_EDIT — TSA-X Framework initialized
                    DIR_CREATE: .ai/, docs/pipeline/, backups/
                    FILE_NEW: scripts/backup-redroid.sh, PIPELINE.md, CONTRIBUTING.md
                    RESOLVED: Backup completed for redroid-gapps (333MB) and redroid-non_gapps (1.1GB)
                    NOTE: Git repository initialized locally. Backups excluded via .gitignore.

## [FILE INDEX]
FILE                         LAST TOUCHED
─────────────────────────────────────────
README.md                    2026-08-14
PIPELINE.md                  2026-08-14
CHANGELOG.md                 2026-08-14
CONTRIBUTING.md              2026-08-14
scripts/backup-redroid.sh    2026-08-14
scripts/upload-to-release.sh 2026-08-14
.ai/memory.md                2026-08-14

## [NOTES]
- Backups larger than 100MB are stored in GitHub Releases, not in the Git repository.
- Use `git lfs` only if absolutely necessary; GitHub Releases is preferred for large .tar.gz files.
