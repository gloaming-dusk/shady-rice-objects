#!/usr/bin/env bash
# Try Objects in a window on your current Wayland desktop.
#
#   SHADY_ROOT=~/src/shady ./run.sh
#
# SHADY_ROOT is a Shady checkout with a build in build/ (./tools/build.sh),
# by default ../shady next to this repository.
set -euo pipefail

RICE="$(cd "$(dirname "$0")" && pwd)"
ROOT="${SHADY_ROOT:-$RICE/../shady}"
if [[ ! -x "$ROOT/build/shady" || ! -x "$ROOT/build/shady-shell" ]]; then
  echo "Objects: no Shady build in $ROOT/build. Set SHADY_ROOT to a built Shady checkout." >&2
  exit 1
fi
ROOT="$(cd "$ROOT" && pwd)"

export SHADY_ROOT="$ROOT"
export SHADY_LUA_INIT="$RICE/init.lua"
export SHADY_SHELL_CONFIG="${SHADY_SHELL_CONFIG:-$RICE/shell.lua}"
export WLR_BACKENDS="${WLR_BACKENDS:-wayland}"

if [[ $# -eq 0 ]]; then
  default_startup="'$ROOT/build/shady-shell' & exec ${TERMINAL:-foot}"
  set -- -s "${SHADY_STARTUP:-$default_startup}"
fi

exec "$ROOT/build/shady" -c "$RICE/config.lua" "$@"
