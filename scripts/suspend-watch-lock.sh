#!/usr/bin/env bash
# suspend-watch-lock.sh — lock on ANY suspend (DMS 1.6.2 misses PrepareForSleep).
# Watches logind for PrepareForSleep(true) and locks via hyprlock
# (DMS `lock` IPC renders nothing on Hyprland — verified 2026-09-23).
# Started from hyprland.lua autostart.
set -u
LOCK="/run/current-system/sw/bin/hyprlock"
gdbus monitor --system --dest org.freedesktop.login1 \
  --object-path /org/freedesktop/login1 2>/dev/null |
while IFS= read -r line; do
  case "$line" in
    *PrepareForSleep*"(true"*)
      # shellcheck disable=SC2086
      eval "$LOCK" >/dev/null 2>&1
      ;;
  esac
done
