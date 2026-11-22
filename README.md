# DrakesModStub

Template for a new DrakeMods Valheim mod. Self-contained: no DrakeModsLibs, no ServerSync. Use GitHub's
"Use this template" (or clone), then run the rename script.

## New mod in three steps

1. Create the repo from this template.
2. Rename everything:
   - Linux / macOS: `./new-mod.sh MyMod "One sentence description"`
   - Windows: `.\New-Mod.ps1 -Name MyMod -Description "One sentence description"`
   This renames files and folders, the namespace, the csproj, the plugin GUID (`com.drakemods.mymod`) and gives the project a new GUID.
3. Edit `mod.package.props` (version, description, dependencies), then build.

The script deletes itself and its copy of this section. It does not commit anything.

## What you get

- Shared build props and targets (`build/`): version and metadata from `mod.package.props`, generated `ModInfo`,
  deploy to the Gale and r2modman profile named by `ProfileName`, Thunderstore-format package.
- `ModGuard` (`Defense/`): isolated Harmony patching, errors attributed to the mod that threw them, and a compat report
  at `BepInEx/DrakeMods-compat-report.txt`. Add `[HarmonyPatch]` classes and `guard.PatchAll()` applies them.
- Windows and Linux builds. Linux: `build/scripts/build-linux.sh` (NuGet, game references from the Pfhoenix package,
  zip to `dist/`). Windows: Visual Studio or `msbuild`.
- Tag-driven release (`.github/workflows/release.yml`): push `vX.Y.Z` matching `<Version>`; CI builds, checks the zip
  layout for Gale, creates a GitHub release and publishes to Hexium (needs the `HEXIUM_TOKEN` secret).
- `.cursor/rules` shared with the other DrakeMods.

## Machine setup

Copy `environment.props.example` (Windows) or `environment.props.example.linux` to `environment.props` (gitignored) and
fix the paths.

## Optional modules (no Libs needed)

`modules/` holds UI, Forge, Compat and Input, lifted out of DrakeModsLibs and cut loose under your mod's own namespace.
`./add-module.sh Ui Forge` (Windows `.\Add-Module.ps1 Ui,Forge`) turns them on; see `modules/README.md`.
The UI needs `Ui.UiSettings.Bind(Config);` in `Awake`.

## Not included on purpose

DrakeModsLibs (tag gates, config sync, item display; the UI, Forge, Compat and Input are available above without it). If a mod needs them, add the Libs reference then (see LockSmith's
`Directory.Build.props`) and remove `<EmbedServerSync>` from this repo's `Directory.Build.props`.

## Known gaps

Not built or run since it was assembled; no dotnet SDK was available. Build once after creating a mod from it.
