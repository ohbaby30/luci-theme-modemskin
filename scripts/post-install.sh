#!/bin/sh
set -eu
# Do not operate on the host when included in an offline firmware root.
[ -z "${IPKG_INSTROOT:-}" ] || exit 0
[ "${IPKG_NO_SCRIPT:-0}" != 1 ] || exit 0
command -v uci >/dev/null 2>&1 || exit 0
[ -f /etc/config/luci ] || exit 0
uci -q set luci.themes.CTModem_Tricolor='/luci-static/ctmodem-tricolor'
uci -q commit luci
# Load/unload only the LuCI RPC extension; no network or proxy restart.
if command -v pidof >/dev/null 2>&1; then
  for rpcd_pid in $(pidof rpcd 2>/dev/null || true); do
    kill -HUP "$rpcd_pid" 2>/dev/null || true
  done
fi
echo 'CTModem Tricolor installed. Select CTModem_Tricolor in System > System > Language and Style.'
