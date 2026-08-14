# Decision Log

## [2026-08-14] TSA-X Adoption
- **Decision**: Adopt TSA-X v6.2 framework for project management.
- **Rationale**: Improve AI consistency in handling Redroid backups and deployments.

## [2026-08-14] Backup Strategy
- **Decision**: Use `tar` via temporary container for named volume backups.
- **Rationale**: Safest and cleanest method compared to `docker export`.

## [2026-08-14] Storage Strategy for Large Files
- **Decision**: Use GitHub Releases instead of Git LFS for file sizes > 100MB.
- **Rationale**: GitHub LFS has strict free tier limits (1GB), while Releases allows up to 2GB per file with fewer bandwidth restrictions.
