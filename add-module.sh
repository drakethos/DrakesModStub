#!/usr/bin/env bash
# Turns on optional modules:  ./add-module.sh Ui Forge Compat Input     (or: ./add-module.sh all)
# Moves modules/<Name> to <Name>/ ; the csproj compiles it and adds its Unity references when the folder exists.
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"
[ $# -gt 0 ] || { echo "Usage: $0 <Ui|Forge|Compat|Input|all> ..." >&2; exit 1; }
names=("$@"); [ "$1" = all ] && names=($(ls modules | grep -v '\.md$'))
for n in "${names[@]}"; do
  [ -d "modules/$n" ] || { echo "No module '$n' (have: $(ls modules | grep -v '\.md$' | tr '\n' ' '))" >&2; exit 1; }
  [ -e "$n" ] && { echo "$n already added"; continue; }
  mv "modules/$n" "$n" && echo "Added $n"
done
rmdir modules 2>/dev/null || true
