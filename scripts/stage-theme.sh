#!/bin/sh
# One runtime payload for APK and IPK. Never copy development metadata.
set -eu
BASE=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
SRC="$BASE/luci-theme-ctmodem-tricolor"
ASSETS=${1:?Usage: stage-theme.sh PREPARED_ASSETS EMPTY_STAGE_DIRECTORY}
STAGE=${2:?Pass an empty temporary stage directory}
STATIC="$STAGE/www/luci-static/ctmodem-tricolor"
mkdir -p "$STATIC/img" "$STAGE/usr/share/ucode/luci/template/themes/ctmodem-tricolor" \
  "$STAGE/usr/share/doc/luci-theme-ctmodem-tricolor" "$STAGE/etc/uci-defaults" "$STAGE/etc/config" "$STAGE/usr/share/rpcd/acl.d" "$STAGE/usr/share/rpcd/ucode"
# Explicit runtime formats keep Finder metadata and build files out of the APK.
cp "$ASSETS/luci-static/ctmodem-tricolor/"*.css "$ASSETS/luci-static/ctmodem-tricolor/"*.js \
  "$ASSETS/luci-static/ctmodem-tricolor/"*.svg "$STATIC/"
cp "$ASSETS/luci-static/ctmodem-tricolor/img/"*.jpg "$ASSETS/luci-static/ctmodem-tricolor/img/"*.gif "$STATIC/img/"
cp "$SRC/ucode/template/themes/ctmodem-tricolor/"*.ut "$STAGE/usr/share/ucode/luci/template/themes/ctmodem-tricolor/"
cp "$SRC/root/etc/uci-defaults/30_luci-theme-ctmodem-tricolor" "$STAGE/etc/uci-defaults/"
cp "$SRC/root/etc/config/ctmodem_tricolor" "$STAGE/etc/config/"
cp "$SRC/root/usr/share/rpcd/acl.d/luci-theme-ctmodem-tricolor.json" "$STAGE/usr/share/rpcd/acl.d/"
cp "$SRC/root/usr/share/rpcd/ucode/ctmodem-tricolor.uc" "$STAGE/usr/share/rpcd/ucode/"
cp "$BASE/LICENSE" "$BASE/NOTICE.md" "$STAGE/usr/share/doc/luci-theme-ctmodem-tricolor/"
find "$STAGE" -type d -exec chmod 755 {} \;
find "$STAGE" -type f -exec chmod 644 {} \;
chmod 755 "$STAGE/etc/uci-defaults/30_luci-theme-ctmodem-tricolor"
