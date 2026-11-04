#!/bin/sh
# Run with apk-tools v3 (the Docker wrapper supplies it).
set -eu
BASE=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
SRC="$BASE/luci-theme-ctmodem-tricolor"
OUT=${1:?Usage: build-apk.sh OUTPUT_DIRECTORY}
ASSETS=${2:?Pass the prepared asset directory}
VERSION=$(sed -n 's/^PKG_VERSION:=//p' "$SRC/Makefile")
RELEASE=$(sed -n 's/^PKG_RELEASE:=//p' "$SRC/Makefile")
case "$VERSION-r$RELEASE" in *[!0-9a-zA-Z._+-]*) echo 'Invalid package version' >&2; exit 1;; esac
mkdir -p "$OUT"
OUT=$(CDPATH= cd -- "$OUT" && pwd)
STAGE=$(mktemp -d)
trap 'rm -rf "$STAGE"' EXIT HUP INT TERM
sh "$BASE/scripts/stage-theme.sh" "$ASSETS" "$STAGE"
PACKAGE="$OUT/luci-theme-ctmodem-tricolor-$VERSION-r$RELEASE.apk"
SOURCE_DATE_EPOCH=0 apk mkpkg --compat 3.0.0 \
  --info 'name:luci-theme-ctmodem-tricolor' \
  --info "version:$VERSION-r$RELEASE" \
  --info 'arch:noarch' --info 'license:MIT' \
  --info 'description:CTModem Tricolor - three switchable gateway layouts' \
  --info 'depends:luci-base' \
  --script "post-install:$BASE/scripts/post-install.sh" \
  --script "post-upgrade:$BASE/scripts/post-install.sh" \
  --script "pre-deinstall:$BASE/scripts/pre-deinstall.sh" \
  --script "post-deinstall:$BASE/scripts/reload-rpcd.sh" \
  --files "$STAGE" --output "$PACKAGE"
cd "$OUT"
sha256sum "$(basename "$PACKAGE")" > SHA256SUMS
apk adbdump "$PACKAGE" > package-metadata.txt
printf 'Built %s\n' "$PACKAGE"
