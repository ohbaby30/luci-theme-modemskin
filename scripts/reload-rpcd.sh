#!/bin/sh
set -eu
[ -z "${IPKG_INSTROOT:-}" ] || exit 0
[ "${IPKG_NO_SCRIPT:-0}" != 1 ] || exit 0
# Load/unload only the LuCI RPC extension; no network or proxy restart.
if command -v pidof >/dev/null 2>&1; then
  for rpcd_pid in $(pidof rpcd 2>/dev/null || true); do
    kill -HUP "$rpcd_pid" 2>/dev/null || true
  done
fi
