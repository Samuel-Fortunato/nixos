#!/usr/bin/env bash
set -euo pipefail
umask 077

state="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/noctalia-caffeine-lock.state"

case "${1:-}" in
  lock)
    # Avoid overwriting a pending saved state
    [[ ! -e "$state" ]] || exit 0

    # Detect Noctalia's existing caffeine inhibitor
    inhibitors=$(systemd-inhibit --list \
      --what=idle --who=noctalia --why=Caffeine \
      --no-pager --no-legend)

    if grep -q 'Caffeine' <<< "$inhibitors"; then
      printf 'on\n' > "$state"
    else
      printf 'off\n' > "$state"
    fi

    if ! noctalia msg caffeine-enable; then
      rm -f "$state"
      exit 1
    fi

    noctalia msg panel-close session || true

    if ! noctalia msg session lock; then
      "$0" restore
      exit 1
    fi
    ;;

  restore)
    [[ -f "$state" ]] || exit 0

    case "$(cat "$state")" in
      on)  noctalia msg caffeine-enable ;;
      off) noctalia msg caffeine-disable ;;
      *)   echo "Invalid saved state" >&2; exit 1 ;;
    esac

    rm -f "$state"
    ;;

  *)
    echo "Usage: $0 {lock|restore}" >&2
    exit 2
    ;;
esac
