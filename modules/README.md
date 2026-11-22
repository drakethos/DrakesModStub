# Optional modules

Self-contained code lifted out of DrakeModsLibs and the other DrakeMods, with no shared-library dependency. Each is
copied into your mod under your own namespace (`<YourMod>.Ui`, `<YourMod>.Forge`, ...), so two mods never share state.
They are copies: a fix in one place does not reach the others.

Turn on what you need: `./add-module.sh Ui Forge` (Windows: `.\Add-Module.ps1 Ui,Forge`; `all` adds everything). That moves
`modules/<Name>` to `<Name>/`; the csproj compiles it and adds its Unity references. Add the folder, then build.

| Module | What it is | Notes |
|---|---|---|
| Ui | Wood action menu, confirm and text prompts, slider, stepper, message stack, tab host, UI Toolkit look | Call `Ui.UiSettings.Bind(Config)` in `Awake` |
| Forge | Load textures, sprites, `.glb` models and look settings embedded in your DLL (Drakes Asset Forge export calls) | Needs the Unity ImageConversion and ParticleSystem modules (added for you) |
| Compat | Soft-dependency scaffolding: one compat host per plugin, prioritised modules for optional foreign mods | |
| Input | Menu key binding registry with conflict detection | |

Always on, not a module: `Defense/ModGuard.cs`.

## Not here

- **Config sync (`DrakeConfigSync`)** wraps the ServerSync library; it cannot be copied without ServerSync itself.
- **Item customization engine** (Display, Tags, Data, Permissions, Patches, Stack): RenameIt's naming and tag engine, too
  tangled with its own mod to be a drop-in module.
- Compiled only against the same Libs reference layout; none of these modules have been built or run since being copied out.
