-- Ragebait Mechanic Tunable Constants
-- All numerical values for balance, ranges, cooldowns, damage/movement multipliers, etc.
-- These values are intended to be adjusted during playtesting; keep them centralized for easy tuning

local RAGEBAIT_CONSTANTS = {
	-- ============================================================================
	-- ACTIVATION & RANGE PARAMETERS
	-- ============================================================================
	
	-- Base activation range (in world units) when sanity is above 50%
	BASE_RANGE = 15,
	
	-- Sanity-scaled range multipliers
	RANGE_SANITY_HIGH = 1.0,    -- Above 50% sanity: 1x base range
	RANGE_SANITY_MEDIUM = 2.0,  -- 25%-50% sanity: 2x base range
	RANGE_SANITY_LOW = 4.0,     -- Below 25% sanity: 4x base range
	
	-- Range usage threshold boundaries (sanity percentages)
	SANITY_MEDIUM_THRESHOLD = 0.50,  -- 50% sanity
	SANITY_LOW_THRESHOLD = 0.25,     -- 25% sanity
	
	-- ============================================================================
	-- RAGEBAIT ACTIVE STATE PARAMETERS
	-- ============================================================================
	
	-- Player damage taken multiplier while ragebait is active (x2 damage = double vulnerability)
	PLAYER_DAMAGE_MULTIPLIER = 2.0,
	
	-- Player damage dealt reduction while ragebait is active (-50% outgoing damage)
	PLAYER_DAMAGE_REDUCTION = 0.5,
	
	-- Player movement speed bonus while ragebait is active (+30% speed)
	PLAYER_MOVE_SPEED_BONUS = 0.30,
	
	-- ============================================================================
	-- COOLDOWN DURATIONS (per tier, in seconds)
	-- ============================================================================
	
	COOLDOWN_TIER1 = 60,  -- Tier 1: 60 seconds
	COOLDOWN_TIER2 = 55,  -- Tier 2: 55 seconds (unlocks ally buff)
	COOLDOWN_TIER3 = 45,  -- Tier 3: 45 seconds (unlocks stealth mode)
	COOLDOWN_TIER4 = 30,  -- Tier 4: 30 seconds (unlocks multi-target)
	COOLDOWN_TIER5 = 20,  -- Tier 5: 20 seconds (max cooldown reduction)
	
	-- ============================================================================
	-- STEALTH MODE (Tier 3+ Unlock)
	-- ============================================================================
	
	-- Duration of stealth effect upon interrupt (in seconds)
	STEALTH_DURATION = 2.0,
	
	-- Stealth type: "invisibility" or "speed_boost"
	-- Placeholder: use invisibility (brief invulnerability/invis buff)
	STEALTH_TYPE = "invisibility",
	
	-- ============================================================================
	-- ALLY BUFF (Tier 2+ Unlock)
	-- ============================================================================
	
	-- Range at which nearby allies receive the buff when ragebait is active (in world units)
	ALLY_BUFF_RANGE = 20,
	
	-- Type of ally buff: "damage" or "healing"
	ALLY_BUFF_TYPE = "damage",
	
	-- Ally buff value (if type is "damage": +X% damage; if "healing": +X per second)
	ALLY_BUFF_VALUE = 0.25,  -- +25% damage or +0.25 health/sec (placeholder, tune in gameplay)
	
	-- ============================================================================
	-- MULTI-TARGET (Tier 4+ Unlock)
	-- ============================================================================
	
	-- Maximum number of enemies that can be taunted simultaneously (Tier 4+)
	MAX_SIMULTANEOUS_TARGETS = 3,
	
	-- ============================================================================
	-- TIER PROGRESSION THRESHOLDS
	-- ============================================================================
	
	-- These thresholds define how many distinct manual types must be crafted to unlock each tier
	-- Adjusted for 62-creature roster (was 1/4/10/30/70 for ~100 creatures)
	TIER_THRESHOLD_1 = 1,   -- 1.6% of roster
	TIER_THRESHOLD_2 = 4,   -- 6.5% of roster
	TIER_THRESHOLD_3 = 10,  -- 16% of roster
	TIER_THRESHOLD_4 = 20,  -- 32% of roster
	TIER_THRESHOLD_5 = 45,  -- 73% of roster
	
	-- ============================================================================
	-- INTERRUPTION & EDGE CASES
	-- ============================================================================
	
	-- Tags that make creatures immune to ragebait taunt (bosses, special enemies)
	-- If a creature has any of these tags, ragebait activation will gracefully fail
	IMMUNE_TAGS = {
		"epic",           -- Boss creatures (Deerclops, Bearger, Dragonfly, etc.)
		"shadowcreature", -- Shadow creatures (immune to most combat mechanics)
		"playerghost",    -- Player ghosts
		"player",         -- Other players
		"wall",           -- Walls (though they shouldn't be targetable anyway)
		"structure",      -- Structures (shouldn't be combat targets)
		"chess",          -- Ancient Chess pieces (special category, can be made vulnerable if desired)
	},
	
	-- Bypass cooldown on immune target failure (if true, no cooldown penalty for trying to taunt immune targets)
	BYPASS_COOLDOWN_ON_IMMUNE = true,

	
	-- Whether taking any positive damage immediately cancels ragebait (one-hit cancel)
	ONE_HIT_CANCEL = true,
	
	-- Whether staff swap immediately cancels ragebait
	STAFF_SWAP_CANCELS = true,
	
	-- Whether target death immediately ends ragebait
	TARGET_DEATH_ENDS = true,
	
	-- Whether immune-to-taunt enemies should gracefully fail (true) or silently fail (false)
	GRACEFUL_FAIL_ON_IMMUNE = true,
	
	-- ============================================================================
	-- BALANCE NOTES & TUNING RANGES
	-- ============================================================================
	-- 
	-- RECOMMENDED TUNING RANGES (based on playtesting feedback):
	--
	-- BASE_RANGE: 12-18 (start at 15, adjust if activation feels restrictive or too easy)
	-- PLAYER_DAMAGE_MULTIPLIER: 1.5-2.5 (1.5 = less risky, 2.5 = extreme risk-reward)
	-- PLAYER_DAMAGE_REDUCTION: 0.3-0.7 (-30% to -70% outgoing, affects team DPS balance)
	-- COOLDOWN_TIER1: 45-90 seconds (tune based on combat pacing in-game)
	-- ALLY_BUFF_VALUE: 0.15-0.40 (+15% to +40%, scales with difficulty & group size)
	-- STEALTH_DURATION: 1.0-3.0 seconds (1.0 = minimal escape, 3.0 = generous safety window)
	--
	-- Suggested Progression Curve (62-creature roster):
	--   T1 (1 manual): Basic ragebait, longest cooldown
	--   T2 (4 manuals): Ally buff unlocked, slightly reduced cooldown
	--   T3 (10 manuals): Stealth mode on interrupt, mid-range cooldown
	--   T4 (20 manuals): Multi-target (3 enemies), fast cooldown
	--   T5 (45 manuals): Shortest cooldown, full power (73% roster completion)
	--
	-- ============================================================================
}

-- Helper function to get tunable value with bounds checking
local function GetConstant(key)
	if RAGEBAIT_CONSTANTS[key] == nil then
		error("Ragebait constant '" .. key .. "' not found!")
	end
	return RAGEBAIT_CONSTANTS[key]
end

-- Helper function to get cooldown duration for a specific tier
local function GetCooldownForTier(tier)
	local cooldown_key = "COOLDOWN_TIER" .. tostring(tier)
	return GetConstant(cooldown_key)
end

-- Helper function to get sanity-scaled range multiplier
local function GetRangeMultiplier(sanity_fraction)
	-- sanity_fraction is between 0.0 and 1.0
	if sanity_fraction >= RAGEBAIT_CONSTANTS.SANITY_MEDIUM_THRESHOLD then
		return RAGEBAIT_CONSTANTS.RANGE_SANITY_HIGH
	elseif sanity_fraction >= RAGEBAIT_CONSTANTS.SANITY_LOW_THRESHOLD then
		return RAGEBAIT_CONSTANTS.RANGE_SANITY_MEDIUM
	else
		return RAGEBAIT_CONSTANTS.RANGE_SANITY_LOW
	end
end

-- Helper function to get effective activation range
local function GetEffectiveRange(sanity_fraction)
	return RAGEBAIT_CONSTANTS.BASE_RANGE * GetRangeMultiplier(sanity_fraction)
end

-- Helper function to list all tunable constants (useful for documentation/debugging)
local function ListConstants()
	local constants = {}
	for key, value in pairs(RAGEBAIT_CONSTANTS) do
		if type(value) ~= "string" or not value:find("RECOMMENDATION") then
			table.insert(constants, { key = key, value = value })
		end
	end
	table.sort(constants, function(a, b) return a.key < b.key end)
	return constants
end

-- Attach functions to the constants table and export
RAGEBAIT_CONSTANTS.GetConstant = GetConstant
RAGEBAIT_CONSTANTS.GetCooldownForTier = GetCooldownForTier
RAGEBAIT_CONSTANTS.GetRangeMultiplier = GetRangeMultiplier
RAGEBAIT_CONSTANTS.GetEffectiveRange = GetEffectiveRange
RAGEBAIT_CONSTANTS.ListConstants = ListConstants

return RAGEBAIT_CONSTANTS
