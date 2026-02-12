PrefabFiles = {
	"anirvan",
	"anirvan_none",
	"ragebait_staff",
	"ragebait_manual_base",
}

Assets = {
    Asset( "IMAGE", "images/saveslot_portraits/anirvan.tex" ),
    Asset( "ATLAS", "images/saveslot_portraits/anirvan.xml" ),

    Asset( "IMAGE", "images/selectscreen_portraits/anirvan.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/anirvan.xml" ),
	
    Asset( "IMAGE", "images/selectscreen_portraits/anirvan_silho.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/anirvan_silho.xml" ),

    Asset( "IMAGE", "bigportraits/anirvan.tex" ),
    Asset( "ATLAS", "bigportraits/anirvan.xml" ),
	
	Asset( "IMAGE", "images/map_icons/anirvan.tex" ),
	Asset( "ATLAS", "images/map_icons/anirvan.xml" ),
	
	Asset( "IMAGE", "images/avatars/avatar_anirvan.tex" ),
    Asset( "ATLAS", "images/avatars/avatar_anirvan.xml" ),
	
	Asset( "IMAGE", "images/avatars/avatar_ghost_anirvan.tex" ),
    Asset( "ATLAS", "images/avatars/avatar_ghost_anirvan.xml" ),
	
	Asset( "IMAGE", "images/avatars/self_inspect_anirvan.tex" ),
    Asset( "ATLAS", "images/avatars/self_inspect_anirvan.xml" ),
	
	Asset( "IMAGE", "images/names_anirvan.tex" ),
    Asset( "ATLAS", "images/names_anirvan.xml" ),
	
	Asset( "IMAGE", "images/names_gold_anirvan.tex" ),
    Asset( "ATLAS", "images/names_gold_anirvan.xml" ),
}

AddMinimapAtlas("images/map_icons/anirvan.xml")

local require = GLOBAL.require
local STRINGS = GLOBAL.STRINGS

-- ============================================================================
-- MOD CONFIGURATION OPTIONS
-- ============================================================================

local function GetConfig(option_name)
	return GetModConfigData(option_name)
end

-- Override ragebait constants with mod config values (if provided)
local function ApplyModConfigToConstants()
	if not RAGEBAIT_CONSTANTS then return end
	
	-- Base range
	local base_range = GetConfig("base_range")
	if base_range then
		RAGEBAIT_CONSTANTS.BASE_RANGE = base_range
	end
	
	-- Cooldown multiplier (affects all tier cooldowns)
	local cooldown_mult = GetConfig("cooldown_multiplier")
	if cooldown_mult and cooldown_mult > 0 then
		RAGEBAIT_CONSTANTS.COOLDOWN_TIER1 = RAGEBAIT_CONSTANTS.COOLDOWN_TIER1 * cooldown_mult
		RAGEBAIT_CONSTANTS.COOLDOWN_TIER2 = RAGEBAIT_CONSTANTS.COOLDOWN_TIER2 * cooldown_mult
		RAGEBAIT_CONSTANTS.COOLDOWN_TIER3 = RAGEBAIT_CONSTANTS.COOLDOWN_TIER3 * cooldown_mult
		RAGEBAIT_CONSTANTS.COOLDOWN_TIER4 = RAGEBAIT_CONSTANTS.COOLDOWN_TIER4 * cooldown_mult
		RAGEBAIT_CONSTANTS.COOLDOWN_TIER5 = RAGEBAIT_CONSTANTS.COOLDOWN_TIER5 * cooldown_mult
	end
	
	-- Player damage multiplier (incoming damage while ragebait active)
	local damage_mult = GetConfig("player_damage_multiplier")
	if damage_mult then
		RAGEBAIT_CONSTANTS.PLAYER_DAMAGE_MULTIPLIER = damage_mult
	end
	
	-- Movement speed bonus
	local speed_bonus = GetConfig("movement_speed_bonus")
	if speed_bonus then
		RAGEBAIT_CONSTANTS.PLAYER_MOVE_SPEED_BONUS = speed_bonus
	end
	
	-- Damage output reduction
	local damage_reduction = GetConfig("damage_output_reduction")
	if damage_reduction then
		RAGEBAIT_CONSTANTS.PLAYER_DAMAGE_REDUCTION = damage_reduction
	end
end

-- The character select screen lines
STRINGS.CHARACTER_TITLES.anirvan = "Anirvan, the Masterbaiter"
STRINGS.CHARACTER_NAMES.anirvan = "Anirvan"
STRINGS.CHARACTER_DESCRIPTIONS.anirvan = "*Can activate Ragebait with staff\n*Enemies target you exclusively\n*Gain speed and reduced damage output"
STRINGS.CHARACTER_QUOTES.anirvan = "\"I live to fish.\""
STRINGS.CHARACTER_SURVIVABILITY.anirvan = "Medium"

-- Custom speech strings
STRINGS.CHARACTERS.ANIRVAN = require "speech_anirvan"

-- The character's name as appears in-game 
STRINGS.NAMES.ANIRVAN = "Anirvan"
STRINGS.SKIN_NAMES.anirvan_none = "Anirvan"

-- ============================================================================
-- ITEM STRINGS (Names and Descriptions)
-- ============================================================================

-- Ragebait Staff
STRINGS.NAMES.RAGEBAIT_STAFF = "Ragebait Staff"
STRINGS.RECIPE_DESC.RAGEBAIT_STAFF = "Channel your inner taunter."
STRINGS.CHARACTERS.GENERIC.DESCRIBE.RAGEBAIT_STAFF = "It pulses with provocative energy."

-- Ragebait Manuals - Dynamic registration
local CREATURE_MAP = require("data/ragebait_creature_map")
local creature_list = CREATURE_MAP.GetAllCreatures()
if creature_list then
	for _, creature_id in ipairs(creature_list) do
		local creature_data = CREATURE_MAP.GetCreatureMapping(creature_id)
		if creature_data and creature_data.manual_id then
			local upper_id = string.upper(creature_data.manual_id)
			local friendly_name = creature_data.friendly_name or creature_id
			STRINGS.NAMES[upper_id] = friendly_name .. " Manual"
			STRINGS.RECIPE_DESC[upper_id] = "Study the " .. friendly_name .. " to taunt it."
			STRINGS.CHARACTERS.GENERIC.DESCRIBE[upper_id] = "A manual for taunting " .. friendly_name .. "s."
		end
	end
end

-- The skins shown in the cycle view window on the character select screen.
-- A good place to see what you can put in here is in skinutils.lua, in the function GetSkinModes
local skin_modes = {
    { 
        type = "ghost_skin",
        anim_bank = "ghost",
        idle_anim = "idle", 
        scale = 0.75, 
        offset = { 0, -25 } 
    },
}

-- Add mod character to mod character list. Also specify a gender. Possible genders are MALE, FEMALE, ROBOT, NEUTRAL, and PLURAL.
AddModCharacter("anirvan", "FEMALE", skin_modes)

-- ============================================================================
-- RAGEBAIT MECHANIC SYSTEM OVERVIEW
-- ============================================================================
--
-- The Ragebait Mechanic is a high-risk/high-reward combat system that allows
-- the Anirvan character to taunt enemies into attacking exclusively the player,
-- while gaining bonuses in movement speed but taking more damage.
--
-- CORE FLOW:
-- ----------
-- 1. PREPARATION:
--    - Craft creature-specific manuals using required ingredients (papyrus,
--      charcoal, creature-specific drop)
--    - Each manual unlocks ragebait for that specific creature type
--    - Distinct manual count determines progression tier (1/4/10/20/45 manuals)
--
-- 2. COMBAT ACTIVATION:
--    - Equip the ragebait staff (consumes tool slot)
--    - Attack an enemy with the staff (after crafting its manual)
--    - Ragebait activator checks preconditions:
--      * Staff equipped and manual crafted for target
--      * Target is not immune (bosses, structures, etc.)
--      * Not currently on cooldown
--      * Target is in range (scaled by sanity: 1x/2x/4x multiplier)
--    - If all checks pass, ragebait buff is applied
--
-- 3. ACTIVE RAGEBAIT:
--    - Player gains: +30% movement speed
--    - Player takes: 2x incoming damage (vulnerability)
--    - Player deals: -50% outgoing damage (reduced offense)
--    - Target: Forced to attack only the player (exclusive taunt)
--    - Duration: Until the player takes ANY damage (one-hit-cancel)
--
-- 4. INTERRUPTION & COOLDOWN:
--    - Ragebait ends immediately on:
--      * Player hit (one-hit-cancel) → triggers stealth (Tier 3+)
--      * Staff unequipped
--      * Target death
--    - Cooldown begins: 60s→55s→45s→30s→20s (Tier 1→5)
--    - Cooldown duration is tier-dependent (faster at higher tiers)
--
-- 5. TIER PROGRESSION:
--    - Unlocked by crafting distinct creature manuals:
--      * Tier 1: ≥1 manual (basic ragebait)
--      * Tier 2: ≥4 manuals (ally buff for nearby teammates)
--      * Tier 3: ≥10 manuals (stealth on interrupt for 2 seconds)
--      * Tier 4: ≥20 manuals (multi-target: up to 3 enemies simultaneous)
--      * Tier 5: ≥45 manuals (shortest cooldown, all features unlocked)
--
-- CONFIGURATION:
-- ---------------
-- All tuning constants are defined in `anirvan/data/ragebait_constants.lua`
-- and can be overridden via mod configuration in modinfo.lua:
-- - base_range: Activation range in world units
-- - cooldown_multiplier: Global cooldown duration multiplier
-- - player_damage_multiplier: Incoming damage multiplier during ragebait
-- - movement_speed_bonus: Movement speed increase percentage
-- - damage_output_reduction: Outgoing damage penalty percentage
--
-- COMPONENTS (Per-Player):
-- -------------------------
-- - ragebait_progress: Tracks crafted manuals and current tier
-- - ragebait_activator: Checks preconditions and initiates activation
-- - ragebait_buff: Manages active state, buffs/debuffs, and interruption
-- - ragebait_cooldown: Tracks post-activation cooldown (tier-dependent)
-- - ragebait_stealth: (Tier 3+) Brief invisibility on interrupt
-- - ragebait_ally_buff: (Tier 2+) Team support when ragebait is active
-- - ragebait_multitarget: (Tier 4+) Multiple simultaneous targets
--
-- ITEMS:
-- -------
-- - ragebait_staff: Equippable weapon (tool slot) that triggers activation
-- - ragebait_manual_*: 62 creature-specific manuals (one per hostile/neutral creature)
--
-- ============================================================================

-- ============================================================================
-- RAGEBAIT MECHANIC INITIALIZATION
-- ============================================================================

-- Load ragebait data and utilities
local CREATURE_MAP = require("data/ragebait_creature_map")
local RAGEBAIT_ASSETS = require("data/ragebait_assets")
local RAGEBAIT_CONSTANTS = require("data/ragebait_constants")

-- Apply mod configuration to constants
ApplyModConfigToConstants()

-- ============================================================================
-- RAGEBAIT RECIPE REGISTRATION
-- ============================================================================

-- Register all ragebait manual recipes with DST's recipe system
local ragebait_recipes = require("recipes_ragebait_manuals")
ragebait_recipes.RegisterAll({
	Ingredient = GLOBAL.Ingredient,
	TECH = GLOBAL.TECH,
	AddRecipe2 = AddRecipe2,
})

-- ============================================================================
-- CHARACTER COMPONENT SETUP
-- ============================================================================

-- Add ragebait components to the character when spawned
local function SetupAnirvanRagebaitComponents(inst)
	if inst.prefab == "anirvan" then
		-- Add ragebait progress tracker (tier/manual tracking)
		inst:AddComponent("ragebait_progress")
		
		-- Add ragebait activator (handles staff use and preconditions)
		inst:AddComponent("ragebait_activator")
		
		-- Add ragebait buff manager (handles active state and effects)
		inst:AddComponent("ragebait_buff")
		
		-- Add cooldown tracker
		inst:AddComponent("ragebait_cooldown")
		
		-- Add stealth component (for Tier 3+ stealth mode)
		inst:AddComponent("ragebait_stealth")
		
		-- Add ally buff component (for Tier 2+ team support)
		inst:AddComponent("ragebait_ally_buff")
		
		-- Add multi-target component (for Tier 4+ multiple targets)
		inst:AddComponent("ragebait_multitarget")
		
		-- Hook recipe completion callback for tier tracking
		-- Listen for when Anirvan crafts items and check if they're ragebait manuals
		inst:ListenForEvent("builditem", function(inst, data)
			print("[Ragebait] builditem event fired")
			if data and data.item then
				print("[Ragebait] Built item: " .. tostring(data.item.prefab) .. ", has ragebait_manual tag: " .. tostring(data.item:HasTag("ragebait_manual")))
				if data.item:HasTag("ragebait_manual") then
					-- Extract creature ID from the manual
					local creature_id = data.item.creature_id
					print("[Ragebait] Manual creature_id: " .. tostring(creature_id))
					if creature_id then
						local progress = inst.components.ragebait_progress
						if progress then
							local result = progress:MarkManualCrafted(creature_id)
							print("[Ragebait] MarkManualCrafted result: " .. tostring(result) .. ", new count: " .. progress:GetDistinctManualsCount())
							-- Mark the item as crafted by this player
							data.item.crafted_by_player = true
						else
							print("[Ragebait] ERROR: No ragebait_progress component!")
						end
					else
						print("[Ragebait] ERROR: creature_id is nil on manual!")
					end
				end
			end
		end)
	end
end

-- Hook into character spawn
AddPlayerPostInit(function(inst)
	SetupAnirvanRagebaitComponents(inst)
end)
