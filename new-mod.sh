#!/usr/bin/env bash
# Turns this template into a new mod.   ./new-mod.sh MyMod "One sentence description"
set -euo pipefail
NAME="${1:-}"; DESC="${2:-Template mod. Replace this sentence.}"
[[ "$NAME" =~ ^[A-Za-z][A-Za-z0-9]*$ ]] || { echo "Usage: $0 <Name> [description]  (Name: letters and digits, starts with a letter)" >&2; exit 1; }
cd "$(dirname "${BASH_SOURCE[0]}")"
OLD=DrakesModStub; OLDGUID=com.drakemods.modstub; OLDPROJ=7C0A4D52-3E19-4B6F-9A21-D8E5F10B3C47
NEWGUID="com.drakemods.$(echo "$NAME" | tr 'A-Z' 'a-z')"
NEWPROJ="$(python3 -c 'import uuid;print(str(uuid.uuid4()).upper())')"

# contents
grep -rIl --exclude-dir=.git --exclude=new-mod.sh --exclude=New-Mod.ps1 -e "$OLD" -e "$OLDGUID" -e "$OLDPROJ" . | while read -r f; do
  sed -i "s/$OLDPROJ/$NEWPROJ/g; s/$OLDGUID/$NEWGUID/g; s/$OLD/$NAME/g" "$f"
done
sed -i "s|<Description>.*</Description>|<Description>$DESC</Description>|" mod.package.props
# names
for f in "$OLD.cs" "${OLD}Config.cs" "$OLD.csproj" "$OLD.sln"; do
  [ -e "$f" ] && mv "$f" "${f/$OLD/$NAME}"
done
# README: replace the template text with a stub
printf '# %s\n\n%s\n' "$NAME" "$DESC" > README.md
printf '# Changelog\n\n## 0.1.0\n\nInitial version.\n' > CHANGELOG.md
rm -f New-Mod.ps1 new-mod.sh
echo "Created $NAME ($NEWGUID). Edit mod.package.props, copy environment.props.example(.linux) to environment.props, then build."
