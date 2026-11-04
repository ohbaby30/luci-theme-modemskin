#!/bin/sh
# Run with GNU tar/coreutils, using the pinned official OpenWrt ipkg-build.
set -eu
BASE=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
SRC="$BASE/luci-theme-modemskin"
OUT=${1:?Usage: build-ipk.sh OUTPUT_DIRECTORY PREPARED_ASSETS IPKG_BUILD}
ASSETS=${2:?Pass prepared assets}
IPKG_BUILD=${3:?Pass verified OpenWrt ipkg-build}
VERSION=$(sed -n 's/^PKG_VERSION:=//p' "$SRC/Makefile")
printf '%s\n' "$VERSION" | grep -Eq '^[0-9]+\.[0-9]+\.[0-9]+$' || { echo 'Expected a three-part package version' >&2; exit 1; }
mkdir -p "$OUT"
OUT=$(CDPATH= cd -- "$OUT" && pwd)
STAGE=$(mktemp -d)
trap 'rm -rf "$STAGE"' EXIT HUP INT TERM
sh "$BASE/scripts/stage-theme.sh" "$ASSETS" "$STAGE"
mkdir "$STAGE/CONTROL"
cat > "$STAGE/CONTROL/control" <<CONTROL
Package: luci-theme-modemskin
Version: $VERSION
Depends: luci-base
Source: ModemSkin
Section: luci
Architecture: all
Maintainer: Ohbaby
License: MIT
Installed-Size: 0
Description: ModemSkin - three switchable carrier-style LuCI layouts (ucode LuCI required)
CONTROL
printf '/etc/config/modemskin\n' > "$STAGE/CONTROL/conffiles"
cp "$BASE/scripts/post-install.sh" "$STAGE/CONTROL/postinst"
# opkg invokes removal hooks during an upgrade too. Keep the selected theme then.
{
  printf '#!/bin/sh\n[ "${1:-}" != upgrade ] || exit 0\n'
  sed '1d' "$BASE/scripts/pre-deinstall.sh"
} > "$STAGE/CONTROL/prerm"
{
  printf '#!/bin/sh\n[ "${1:-}" != upgrade ] || exit 0\n'
  sed '1d' "$BASE/scripts/reload-rpcd.sh"
} > "$STAGE/CONTROL/postrm"
chmod 755 "$STAGE/CONTROL/postinst" "$STAGE/CONTROL/prerm" "$STAGE/CONTROL/postrm"
SOURCE_DATE_EPOCH=0 sh "$IPKG_BUILD" "$STAGE" "$OUT"
cp "$STAGE/CONTROL/control" "$OUT/ipk-control.txt"
cd "$OUT"
sha256sum "luci-theme-modemskin_${VERSION}_all.ipk" > IPK-SHA256SUMS
