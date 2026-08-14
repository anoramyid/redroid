# Usage

## Instance Reference

| Instance | ADB Address | Window Title (suggested) |
|---|---|---|
| redroid-gapps | `<HOST-IP>:5555` | Redroid GApps |
| redroid-non-gapps | `<HOST-IP>:5581` | Redroid Non-GApps |

Replace `<HOST-IP>` with the Docker host's IP address, or `localhost` if running the client tools directly on the host.

---

## Client Tools Install (adb + scrcpy)

| OS | Install Command |
|---|---|
| Linux (Debian/Ubuntu) | `sudo apt install scrcpy adb -y` |
| Linux (Alpine) | `sudo apk add android-tools` (ADB only) |
| Linux (latest via snap) | `sudo snap install scrcpy` |
| Windows | `winget install Genymobile.scrcpy` |
| macOS | `brew install scrcpy` |

Notes:
- **Windows:** if `adb` isn't detected after installing scrcpy, install separately: `winget install Google.PlatformTools`
- **macOS:** `brew install scrcpy` pulls in `adb` automatically via `android-platform-tools`
- **Linux:** the `apt` version may lag behind; use `snap` for the latest scrcpy release

---

## 1. Connect via ADB

```bash
adb start-server
adb connect <HOST-IP>:5555   # redroid-gapps
adb connect <HOST-IP>:5581   # redroid-non-gapps
```

Verify:

```bash
adb devices
```

Expected:

```
<HOST-IP>:5555    device
<HOST-IP>:5581    device
```

If the list is empty:
- Confirm the target port is reachable: `nc -zv <HOST-IP> 5555`
- Confirm the container has finished Android boot: `docker logs redroid-gapps --tail 50` (look for `Boot completed`)
- Confirm port mapping: `docker port redroid-gapps`

---

## 2. Mirror Screen with scrcpy

### Single instance

```bash
scrcpy -s <HOST-IP>:5555 --max-size 1024 --bit-rate 2M
```

### Both instances simultaneously

```bash
scrcpy -s <HOST-IP>:5555 --window-title "Redroid GApps" --max-size 1024 --bit-rate 2M & \
scrcpy -s <HOST-IP>:5581 --window-title "Redroid Non-GApps" --max-size 1024 --bit-rate 2M &
```

Optional — auto-arrange windows side by side (Linux, requires `wmctrl`):

```bash
sleep 2 && wmctrl -r "Redroid GApps" -e 0,0,0,960,1080
wmctrl -r "Redroid Non-GApps" -e 0,960,0,960,1080
```

---

## 3. Shell Access

```bash
adb -s <HOST-IP>:5555 shell
```

## 4. Install an APK

```bash
adb -s <HOST-IP>:5555 install /path/to/app.apk
```
