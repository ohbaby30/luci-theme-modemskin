#!/bin/sh
set -eu
BASE=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
OUT=${1:?Usage: build-in-docker.sh ABSOLUTE_OUTPUT_DIRECTORY [apk|ipk|both]}
FORMAT=${2:-apk}
case "$FORMAT" in apk|ipk|both) ;; *) echo "Choose apk, ipk or both" >&2; exit 1;; esac
case "$OUT" in /*) ;; *) echo 'Output must be an absolute path outside the source tree' >&2; exit 1;; esac
mkdir -p "$OUT"
OUT=$(CDPATH= cd -- "$OUT" && pwd)
case "$OUT/" in "$BASE/"*) echo 'Keep build output outside the source tree' >&2; exit 1;; esac
# Build dependencies and generated assets stay outside the upload source tree.
mkdir -p "$OUT/tools"
cp "$BASE/package.json" "$BASE/package-lock.json" "$OUT/tools/"
npm ci --prefix "$OUT/tools" --cache "$OUT/npm-cache" --no-audit --no-fund
node "$BASE/scripts/prepare-assets.cjs" "$OUT/assets" "$OUT/tools/node_modules/esbuild"
# apk-tools 3.0.7; the same multi-architecture image is used locally and in Actions.
IMAGE='alpine@sha256:020dfcbaaf4cc1078bf2d9c7ba31a8466e334061dcd2f248001d68f79e52c000'
if [ "$FORMAT" != ipk ]; then
docker run --rm --network none \
  --mount "type=bind,source=$BASE,target=/source,readonly" \
  --mount "type=bind,source=$OUT/assets,target=/assets,readonly" \
  --mount "type=bind,source=$OUT,target=/output" \
  "$IMAGE" sh /source/scripts/build-apk.sh /output /assets

fi
if [ "$FORMAT" != apk ]; then
  IPKG_URL='https://raw.githubusercontent.com/openwrt/openwrt/49e8f532989c342fff44c1c558f8182585673833/scripts/ipkg-build'
  IPKG_SHA='60714afe9b93fd0d3ecfd2fcef7839928b1a99e826ae30e2e3c0e24f1efde474'
  curl --fail --location --proto '=https' --tlsv1.2 --retry 3 --max-time 120 "$IPKG_URL" -o "$OUT/tools/ipkg-build"
  node -e 'const fs=require("fs"),c=require("crypto");if(c.createHash("sha256").update(fs.readFileSync(process.argv[1])).digest("hex")!==process.argv[2])throw Error("ipkg-build checksum mismatch")' "$OUT/tools/ipkg-build" "$IPKG_SHA"
  DEBIAN='debian@sha256:3783cc01769c7b2b1b83a5c5ad96c815348e28ed7da68e2e3687004faa906251'
  docker run --rm --network none \
    --mount "type=bind,source=$BASE,target=/source,readonly" \
    --mount "type=bind,source=$OUT/assets,target=/assets,readonly" \
    --mount "type=bind,source=$OUT/tools/ipkg-build,target=/tools/ipkg-build,readonly" \
    --mount "type=bind,source=$OUT,target=/output" \
    "$DEBIAN" sh /source/scripts/build-ipk.sh /output /assets /tools/ipkg-build
fi
# One checksum manifest for every selected format.
node -e 'const fs=require("fs"),p=require("path"),c=require("crypto"),d=process.argv[1];fs.writeFileSync(p.join(d,"SHA256SUMS"),fs.readdirSync(d).filter(n=>/\.(apk|ipk)$/.test(n)).sort().map(n=>c.createHash("sha256").update(fs.readFileSync(p.join(d,n))).digest("hex")+"  "+n+"\n").join(""))' "$OUT"
