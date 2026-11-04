#!/bin/sh
# One runtime payload for APK and IPK. Never copy development metadata.
set -eu
BASE=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
SRC="$BASE/luci-theme-modemskin"
ASSETS=${1:?Usage: stage-theme.sh PREPARED_ASSETS EMPTY_STAGE_DIRECTORY}
STAGE=${2:?Pass an empty temporary stage directory}
STATIC="$STAGE/www/luci-static/modemskin"
mkdir -p "$STATIC/img" "$STAGE/usr/share/ucode/luci/template/themes/modemskin" \
  "$STAGE/usr/libexec" "$STAGE/usr/share/doc/luci-theme-modemskin" "$STAGE/etc/uci-defaults" "$STAGE/etc/config" "$STAGE/usr/share/rpcd/acl.d" "$STAGE/usr/share/rpcd/ucode"
# Explicit runtime formats keep Finder metadata and build files out of the APK.
cp "$ASSETS/luci-static/modemskin/"*.css "$ASSETS/luci-static/modemskin/"*.js \
  "$ASSETS/luci-static/modemskin/"*.svg "$STATIC/"
cp "$ASSETS/luci-static/modemskin/img/"*.jpg "$ASSETS/luci-static/modemskin/img/"*.gif "$STATIC/img/"
cp "$SRC/ucode/template/themes/modemskin/"*.ut "$STAGE/usr/share/ucode/luci/template/themes/modemskin/"
cp "$SRC/root/etc/uci-defaults/30_luci-theme-modemskin" "$STAGE/etc/uci-defaults/"
cp "$SRC/root/etc/config/modemskin" "$STAGE/etc/config/"
cp "$SRC/root/usr/share/rpcd/acl.d/luci-theme-modemskin.json" "$STAGE/usr/share/rpcd/acl.d/"
cp "$SRC/root/usr/share/rpcd/ucode/modemskin.uc" "$STAGE/usr/share/rpcd/ucode/"
cp "$SRC/root/usr/libexec/modemskin-setup.uc" "$SRC/root/usr/libexec/modemskin-pre-remove" "$STAGE/usr/libexec/"
cp "$BASE/LICENSE" "$BASE/NOTICE.md" "$BASE/THIRD_PARTY_LICENSES.md" "$STAGE/usr/share/doc/luci-theme-modemskin/"
find "$STAGE" -type d -exec chmod 755 {} \;
find "$STAGE" -type f -exec chmod 644 {} \;
chmod 755 "$STAGE/etc/uci-defaults/30_luci-theme-modemskin" "$STAGE/usr/libexec/modemskin-pre-remove"
