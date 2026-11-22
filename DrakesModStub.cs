using BepInEx;
using BepInEx.Logging;
using DrakesModStub.Defense;
using HarmonyLib;
using Jotunn;
using Jotunn.Utils;

namespace DrakesModStub
{
    // GUID, ModName and Version are generated from mod.package.props (ModInfo.g.cs): edit them there.
    [BepInPlugin(GUID, ModName, Version)]
    [BepInDependency(Main.ModGuid)]
    [NetworkCompatibility(CompatibilityLevel.EveryoneMustHaveMod, VersionStrictness.Minor)]
    public partial class DrakesModStub : BaseUnityPlugin
    {
        public static DrakesModStub Instance { get; private set; } = null!;

        public static ManualLogSource? Log { get; private set; }

        private readonly Harmony _harmony = new Harmony(GUID);

        private void Awake()
        {
            Instance = this;
            Log = Logger;

            // BepInEx rewrites the whole .cfg on every Bind by default: batch them into one save.
            var saveOnSet = Config.SaveOnConfigSet;
            Config.SaveOnConfigSet = false;
            try { DrakesModStubConfig.Bind(Config); }
            finally { Config.SaveOnConfigSet = saveOnSet; }
            Config.Save();

            // Patch classes are applied one by one, runtime errors are attributed to the mod that threw them,
            // and BepInEx/DrakeMods-compat-report.txt lists other mods patching the same methods.
            var guard = ModGuard.Create(ModName, GUID, Version, typeof(DrakesModStub).Assembly, _harmony, Logger);
            guard.ReportTo = "the mod's Hexium page (Threads tab)";
            guard.PatchAll();
            guard.Arm();

            Logger.LogInfo($"{ModName} {Version} Awake.");
        }
    }
}
