using BepInEx.Configuration;

namespace DrakesModStub;

/// <summary>Plain BepInEx config. Add entries here; sync them from the server yourself if the mod needs it.</summary>
public static class DrakesModStubConfig
{
    private static ConfigEntry<bool> _enabled = null!;

    public static bool Enabled => _enabled.Value;

    public static void Bind(ConfigFile config)
    {
        _enabled = config.Bind("01 General", "Enabled", true, "Master switch for the mod.");
    }
}
