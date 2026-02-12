name = "Anirvan - Character Mod"
description = "Play as Anirvan, the Masterbaiter, with the unique Ragebait mechanic.\n\n" ..
	"Ragebait Staff: Taunt enemies to attack only you.\n" ..
	"Manual System: Craft creature-specific manuals to unlock ragebait for each enemy type.\n" ..
	"Tier Progression: Unlock enhanced abilities as you craft more manuals (1/4/10/20/45).\n" ..
	"High Risk, High Reward: Gain speed and take more damage, but any hit cancels the effect!"

author = "Your Name"
version = "0.1.0"

forumthread = ""

api_version = 10

dont_starve_compatible = false
reign_of_giants_compatible = false
dst_compatible = true

all_clients_require_mod = true
client_only_mod = false

icon_atlas = "modicon.xml"
icon = "modicon.tex"

server_filter_tags = {"character", "ragebait"}

-- Mod configuration options
configuration_options =
{
	{
		name = "base_range",
		label = "Ragebait Base Range",
		hover = "Base activation range for ragebait (scales with sanity)",
		options = 
		{
			{description = "10 units", data = 10},
			{description = "15 units (Default)", data = 15},
			{description = "20 units", data = 20},
			{description = "25 units", data = 25},
		},
		default = 15,
	},
	{
		name = "cooldown_multiplier",
		label = "Cooldown Duration",
		hover = "Multiplier for all cooldown durations",
		options = 
		{
			{description = "0.5x (Faster)", data = 0.5},
			{description = "0.75x", data = 0.75},
			{description = "1.0x (Default)", data = 1.0},
			{description = "1.5x", data = 1.5},
			{description = "2.0x (Slower)", data = 2.0},
		},
		default = 1.0,
	},
	{
		name = "player_damage_multiplier",
		label = "Damage Taken Multiplier",
		hover = "How much more damage you take while ragebait is active",
		options = 
		{
			{description = "1.5x (Easier)", data = 1.5},
			{description = "2.0x (Default)", data = 2.0},
			{description = "2.5x", data = 2.5},
			{description = "3.0x (Harder)", data = 3.0},
		},
		default = 2.0,
	},
	{
		name = "movement_speed_bonus",
		label = "Movement Speed Bonus",
		hover = "Movement speed increase while ragebait is active",
		options = 
		{
			{description = "15%", data = 0.15},
			{description = "30% (Default)", data = 0.30},
			{description = "45%", data = 0.45},
			{description = "60%", data = 0.60},
		},
		default = 0.30,
	},
	{
		name = "damage_output_reduction",
		label = "Damage Output Penalty",
		hover = "How much your damage output is reduced while ragebait is active",
		options = 
		{
			{description = "25%", data = 0.25},
			{description = "50% (Default)", data = 0.50},
			{description = "75%", data = 0.75},
			{description = "90%", data = 0.90},
		},
		default = 0.50,
	},
}
