#!/bin/sh
set -eu
[ -z "${IPKG_INSTROOT:-}" ] || exit 0
command -v uci >/dev/null 2>&1 || exit 0
[ -f /etc/config/luci ] || exit 0
current=$(uci -q get luci.main.mediaurlbase || true)
if [ "$current" = '/luci-static/ctmodem-tricolor' ]; then
  if [ -f /usr/share/ucode/luci/template/themes/ctmodem-ohbaby/header.ut ]; then
    uci -q set luci.main.mediaurlbase='/luci-static/ctmodem-ohbaby'
  elif [ -f /usr/share/ucode/luci/template/themes/bootstrap/header.ut ]; then
    uci -q set luci.main.mediaurlbase='/luci-static/bootstrap'
  else
    echo 'Select another installed LuCI theme before removing CTModem Tricolor.' >&2
    exit 1
  fi
fi
uci -q delete luci.themes.CTModem_Tricolor || true
uci -q commit luci
