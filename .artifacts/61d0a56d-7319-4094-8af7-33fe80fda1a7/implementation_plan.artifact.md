# Alpine Linux Support Implementation Plan

This plan outlines the changes needed to support Alpine Linux as a host for Redroid instances. Alpine Linux handles kernel modules like `binder` differently (often built-in via `binderfs` instead of loadable modules) and uses `musl` libc, requiring specific configuration for stability.

## User Review Required

> [!IMPORTANT]
> Alpine Linux's default kernel (`linux-lts`) typically includes `binder` support built-in. This means `modprobe` will fail, but the feature is available. The `deploy.sh` script will be updated to handle this automatically by attempting to mount `binderfs` if the module isn't found.

## Proposed Changes

### 1. Script Enhancements

#### [MODIFY] [deploy.sh](file:///home/sam/Documents/redroid-repo/scripts/deploy.sh)
- Add detection for Alpine Linux.
- Add logic to mount `binderfs` if `modprobe binder_linux` is not applicable.
- Add `androidboot.use_memfd=1` to both `docker run` commands to ensure compatibility with modern kernels (standard in Alpine 3.20+).

### 2. Documentation Updates

#### [MODIFY] [SETUP.md](file:///home/sam/Documents/redroid-repo/docs/SETUP.md)
- Add an "Alpine Linux" section under Host Requirements.
- Document `binderfs` mounting requirements and persistent `/etc/fstab` configuration.
- Explain the necessity of the `use_memfd=1` flag.

#### [MODIFY] [USAGE.md](file:///home/sam/Documents/redroid-repo/docs/USAGE.md)
- Add Alpine Linux (`apk`) commands for installing client tools (`android-tools` for ADB).

#### [MODIFY] [current-state.md](file:///home/sam/Documents/redroid-repo/docs/pipeline/current-state.md)
- Update "Supported OS" list to include Alpine Linux.

## Open Questions

> [!NOTE]
> Are you planning to run the **client** (scrcpy/adb) or the **host** (Docker/Redroid) on the Alpine device? I am assuming the **host**, but I will include instructions for both just in case.

## Verification Plan

### Automated Tests
- Validate `deploy.sh` syntax for POSIX compatibility (Alpine uses `ash` by default, though we target `bash`).
- Verify that `androidboot.use_memfd=1` does not break existing Ubuntu deployments.

### Manual Verification
- The user should run `./scripts/deploy.sh` on the Alpine device and check `docker logs` for any binder-related errors.
- Verify `ls -l /dev/binderfs` contains `binder`, `hwbinder`, and `vndbinder` nodes.
