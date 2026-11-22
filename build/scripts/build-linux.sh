#!/usr/bin/env bash
# Linux build for DrakesModStub: the same steps CI runs (.github/workflows/release.yml), runnable locally.
#   build/scripts/build-linux.sh [Debug|Release]
# Needs: dotnet SDK 8, nuget (or mono's nuget), git, zip, python3, jq.
# Compiles against the game DLLs from the Pfhoenix NuGet package (no Valheim install needed).
set -euo pipefail

CONFIG="${1:-Release}"
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$ROOT"

VERSION="$(sed -n 's/.*<Version>\([^<]*\)<\/Version>.*/\1/p' mod.package.props | head -1 | xargs)"
NET48_VER="1.0.3"
export CI_NET48_FWPATH="$ROOT/packages/Microsoft.NETFramework.ReferenceAssemblies.net48.$NET48_VER/build"
export CI_SKIP_POST_BUILD=true

echo "== restore"
nuget restore DrakesModStub.csproj -PackagesDirectory packages

echo "== stage game DLLs"
"$ROOT/build/scripts/stage-valheim-refs.sh" "$ROOT"
CI_ROOT="$ROOT/ci_valheim"
MANAGED="$CI_ROOT/valheim_Data/Managed"
export VALHEIM_INSTALL="$CI_ROOT"

echo "== build DrakesModStub $VERSION ($CONFIG)"
dotnet msbuild DrakesModStub.csproj \
  /p:Configuration="$CONFIG" /p:TargetFrameworkVersion=v4.8 \
  /p:BepInExPath="$CI_ROOT/BepInEx" /p:CorlibPath="$MANAGED" \
  /p:PublicizedAssembliesPath="$MANAGED/publicized_assemblies" \
  /p:Version="$VERSION" /t:Build /v:minimal

echo "== package"
PKG="DrakeMods-DrakesModStub-$VERSION"
rm -rf "dist/$PKG" "dist/$PKG.zip"
mkdir -p "dist/$PKG/plugins"
cp "bin/$CONFIG/DrakesModStub.dll" "dist/$PKG/plugins/"
cp README.md CHANGELOG.md "dist/$PKG/"
[ -f icon.png ] && cp icon.png "dist/$PKG/"
dotnet msbuild DrakesModStub.csproj /p:Version="$VERSION" /p:ThunderstoreManifestDir="$ROOT/dist/$PKG" /t:WriteThunderstoreManifest /v:minimal
(cd "dist/$PKG" && zip -qr "../$PKG.zip" .)
python3 .github/scripts/check-gale-layout.py "dist/$PKG.zip" "DrakeMods-DrakesModStub" --expect "DrakesModStub.dll"
echo "OK: dist/$PKG.zip"
