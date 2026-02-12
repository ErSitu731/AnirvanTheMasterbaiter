-- Optional mod configuration to expose settings in the Mods menu
-- This avoids the "Could not load mod_config_data/modconfiguration_anirvan" message.

name = "Anirvan Mod Configuration"
description = "Configuration options for the Anirvan character mod."

configuration_options = {
    {
        name = "enable_debug_logs",
        label = "Enable debug logs",
        options = {
            {description = "Off", data = false},
            {description = "On", data = true},
        },
        default = false,
    },
}
