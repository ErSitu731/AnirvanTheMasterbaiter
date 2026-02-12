-- ============================================================================
-- Ragebait Creature Mapping System
-- ============================================================================
-- Maps vanilla DST creature prefab names to manual IDs, friendly names, required drops, and tier guidance
-- This table is the authoritative source for which creatures can have Ragebait manuals crafted for them
--
-- HOW TO ADD A NEW CREATURE:
-- ==========================
-- 1. Add a new entry to CREATURE_MAP using the creature's prefab name as the key
-- 2. Provide the following required fields:
--    - manual_id: Unique ID for this creature's manual (format: "ragebait_manual_<creature_name>")
--    - friendly_name: Display name shown in UI and inspect text
--    - required_drop: Prefab name of the item required to craft the manual (must be a valid DST item)
--    - tier_weight: Difficulty tier (1=early game, 2=mid game, 3=late game, 4=boss/rare)
--    - category: Type classification ("hostile", "neutral", "chesspiece", "shadow", "lunar", "boss")
--
-- EXAMPLE:
-- --------
-- new_creature = {
--     manual_id = "ragebait_manual_new_creature",
--     friendly_name = "New Creature",
--     required_drop = "new_creature_drop",
--     tier_weight = 2,
--     category = "hostile",
-- },
--
-- NOTES:
-- ------
-- - The creature prefab name (key) must match the exact prefab name from DST game files
-- - Required drop must be an item that the creature drops when killed
-- - Tier weights are for reference only; tier progression is based on distinct manual COUNT
-- - Total creature count affects tier thresholds (currently: 62 creatures, thresholds at 1/4/10/20/45)
-- - After adding a new creature, the manual prefab and recipe will be auto-generated on mod load
-- ============================================================================

local CREATURE_MAP = {
	-- EARLY GAME CREATURES (Tier 1-2)
	hound = {
		manual_id = "ragebait_manual_hound",
		friendly_name = "Hound",
		required_drop = "houndstooth",
		tier_weight = 1,
		category = "hostile",
	},
	spider = {
		manual_id = "ragebait_manual_spider",
		friendly_name = "Spider",
		required_drop = "spider_gland",
		tier_weight = 1,
		category = "hostile",
	},
	spider_warrior = {
		manual_id = "ragebait_manual_spider_warrior",
		friendly_name = "Warrior Spider",
		required_drop = "spider_gland",
		tier_weight = 1,
		category = "hostile",
	},
	spider_hider = {
		manual_id = "ragebait_manual_spider_hider",
		friendly_name = "Hider Spider",
		required_drop = "spider_gland",
		tier_weight = 1,
		category = "hostile",
	},
	spider_spitter = {
		manual_id = "ragebait_manual_spider_spitter",
		friendly_name = "Spitter Spider",
		required_drop = "spider_gland",
		tier_weight = 1,
		category = "hostile",
	},
	spider_dropper = {
		manual_id = "ragebait_manual_spider_dropper",
		friendly_name = "Dropper Spider",
		required_drop = "spider_gland",
		tier_weight = 1,
		category = "hostile",
	},
	tentacle = {
		manual_id = "ragebait_manual_tentacle",
		friendly_name = "Tentacle",
		required_drop = "tentacle_spike",
		tier_weight = 2,
		category = "hostile",
	},
	tentacle_garden = {
		manual_id = "ragebait_manual_tentacle_garden",
		friendly_name = "Garden Tentacle",
		required_drop = "tentacle_spike",
		tier_weight = 2,
		category = "hostile",
	},

	-- MID GAME CREATURES (Tier 2-3)
	pigman = {
		manual_id = "ragebait_manual_pigman",
		friendly_name = "Pigman",
		required_drop = "pigskin",
		tier_weight = 2,
		category = "neutral",
	},
	knight = {
		manual_id = "ragebait_manual_knight",
		friendly_name = "Knight",
		required_drop = "bishop_key",
		tier_weight = 2,
		category = "chesspiece",
	},
	bishop = {
		manual_id = "ragebait_manual_bishop",
		friendly_name = "Bishop",
		required_drop = "bishop_key",
		tier_weight = 2,
		category = "chesspiece",
	},
	rook = {
		manual_id = "ragebait_manual_rook",
		friendly_name = "Rook",
		required_drop = "bishop_key",
		tier_weight = 2,
		category = "chesspiece",
	},
	lureplant = {
		manual_id = "ragebait_manual_lureplant",
		friendly_name = "Lureplant",
		required_drop = "lureplant_spike",
		tier_weight = 2,
		category = "hostile",
	},
	rabbit = {
		manual_id = "ragebait_manual_rabbit",
		friendly_name = "Rabbit",
		required_drop = "rabbit_hide",
		tier_weight = 1,
		category = "neutral",
	},
	moleworm = {
		manual_id = "ragebait_manual_moleworm",
		friendly_name = "Moleworm",
		required_drop = "moleworm_hide",
		tier_weight = 1,
		category = "neutral",
	},
	batilisk = {
		manual_id = "ragebait_manual_batilisk",
		friendly_name = "Batilisk",
		required_drop = "batilisk_wing",
		tier_weight = 2,
		category = "hostile",
	},
	fly = {
		manual_id = "ragebait_manual_fly",
		friendly_name = "Fly",
		required_drop = "stinger",
		tier_weight = 1,
		category = "hostile",
	},
	mosquito = {
		manual_id = "ragebait_manual_mosquito",
		friendly_name = "Mosquito",
		required_drop = "mosquito_sack",
		tier_weight = 1,
		category = "hostile",
	},

	-- MID-LATE GAME CREATURES (Tier 3-4)
	beefalalo = {
		manual_id = "ragebait_manual_beefalalo",
		friendly_name = "Beefalo",
		required_drop = "beefalo_horn",
		tier_weight = 3,
		category = "aggressive",
	},
	wildbore = {
		manual_id = "ragebait_manual_wildbore",
		friendly_name = "Wildbore",
		required_drop = "pigskin",
		tier_weight = 2,
		category = "hostile",
	},
	penguin = {
		manual_id = "ragebait_manual_penguin",
		friendly_name = "Penguin",
		required_drop = "penguin_feather",
		tier_weight = 2,
		category = "hostile",
	},
	perd = {
		manual_id = "ragebait_manual_perd",
		friendly_name = "Perd",
		required_drop = "perd_feather",
		tier_weight = 1,
		category = "neutral",
	},
	tallbird = {
		manual_id = "ragebait_manual_tallbird",
		friendly_name = "Tallbird",
		required_drop = "tallbird_feather",
		tier_weight = 2,
		category = "aggressive",
	},
	monkey = {
		manual_id = "ragebait_manual_monkey",
		friendly_name = "Monkey",
		required_drop = "banana",
		tier_weight = 2,
		category = "hostile",
	},
	frog = {
		manual_id = "ragebait_manual_frog",
		friendly_name = "Frog",
		required_drop = "frog_leg",
		tier_weight = 1,
		category = "neutral",
	},
	toad = {
		manual_id = "ragebait_manual_toad",
		friendly_name = "Toad",
		required_drop = "toad_stool",
		tier_weight = 1,
		category = "hostile",
	},
	leif = {
		manual_id = "ragebait_manual_leif",
		friendly_name = "Leif",
		required_drop = "leif_bark",
		tier_weight = 3,
		category = "hostile",
	},
	leif_sparse = {
		manual_id = "ragebait_manual_leif_sparse",
		friendly_name = "Leif (Sparse)",
		required_drop = "leif_bark",
		tier_weight = 3,
		category = "hostile",
	},

	-- LATE GAME & BOSS CREATURES (Tier 4-5)
	deerclops = {
		manual_id = "ragebait_manual_deerclops",
		friendly_name = "Deerclops",
		required_drop = "deerclops_eyeball",
		tier_weight = 4,
		category = "boss",
	},
	bearger = {
		manual_id = "ragebait_manual_bearger",
		friendly_name = "Bearger",
		required_drop = "bearger_fur",
		tier_weight = 4,
		category = "boss",
	},
	dragonfly = {
		manual_id = "ragebait_manual_dragonfly",
		friendly_name = "Dragonfly",
		required_drop = "dragonfly_scale",
		tier_weight = 4,
		category = "boss",
	},
	goose = {
		manual_id = "ragebait_manual_goose",
		friendly_name = "Goose",
		required_drop = "goose_feather",
		tier_weight = 3,
		category = "aggressive",
	},
	moosegoose = {
		manual_id = "ragebait_manual_moosegoose",
		friendly_name = "Moose/Goose",
		required_drop = "moosegoose_horn",
		tier_weight = 4,
		category = "boss",
	},
	antlion = {
		manual_id = "ragebait_manual_antlion",
		friendly_name = "Antlion",
		required_drop = "antlion_mandible",
		tier_weight = 3,
		category = "hostile",
	},
	warg = {
		manual_id = "ragebait_manual_warg",
		friendly_name = "Warg",
		required_drop = "warg_fur",
		tier_weight = 3,
		category = "hostile",
	},
	walrus = {
		manual_id = "ragebait_manual_walrus",
		friendly_name = "Walrus",
		required_drop = "walrus_tusk",
		tier_weight = 4,
		category = "boss",
	},
	minotaur = {
		manual_id = "ragebait_manual_minotaur",
		friendly_name = "Minotaur",
		required_drop = "minotaur_horn",
		tier_weight = 4,
		category = "boss",
	},
	toadstool = {
		manual_id = "ragebait_manual_toadstool",
		friendly_name = "Toadstool",
		required_drop = "toadstool_cap",
		tier_weight = 4,
		category = "boss",
	},
	shadow_bishop = {
		manual_id = "ragebait_manual_shadow_bishop",
		friendly_name = "Shadow Bishop",
		required_drop = "shadow_piece",
		tier_weight = 4,
		category = "hostile",
	},
	shadow_knight = {
		manual_id = "ragebait_manual_shadow_knight",
		friendly_name = "Shadow Knight",
		required_drop = "shadow_piece",
		tier_weight = 4,
		category = "hostile",
	},
	shadow_rook = {
		manual_id = "ragebait_manual_shadow_rook",
		friendly_name = "Shadow Rook",
		required_drop = "shadow_piece",
		tier_weight = 4,
		category = "hostile",
	},
	glommer = {
		manual_id = "ragebait_manual_glommer",
		friendly_name = "Glommer",
		required_drop = "glommer_flower",
		tier_weight = 3,
		category = "aggressive",
	},
	klaus = {
		manual_id = "ragebait_manual_klaus",
		friendly_name = "Klaus",
		required_drop = "klaus_sack",
		tier_weight = 5,
		category = "boss",
	},
	bearger_yule = {
		manual_id = "ragebait_manual_bearger_yule",
		friendly_name = "Bearger (Yule)",
		required_drop = "bearger_fur",
		tier_weight = 4,
		category = "boss",
	},
	deerclops_yule = {
		manual_id = "ragebait_manual_deerclops_yule",
		friendly_name = "Deerclops (Yule)",
		required_drop = "deerclops_eyeball",
		tier_weight = 4,
		category = "boss",
	},
	warglet = {
		manual_id = "ragebait_manual_warglet",
		friendly_name = "Warglet",
		required_drop = "warg_fur",
		tier_weight = 3,
		category = "hostile",
	},

	-- SPECIAL CREATURES (dont forget about raft world)
	merm_guard = {
		manual_id = "ragebait_manual_merm_guard",
		friendly_name = "Merm Guard",
		required_drop = "coral_brain",
		tier_weight = 2,
		category = "hostile",
	},
	merm_warrior = {
		manual_id = "ragebait_manual_merm_warrior",
		friendly_name = "Merm Warrior",
		required_drop = "coral_brain",
		tier_weight = 2,
		category = "hostile",
	},
	crab = {
		manual_id = "ragebait_manual_crab",
		friendly_name = "Crab",
		required_drop = "purple_gem",
		tier_weight = 1,
		category = "hostile",
	},
	hermitcrab = {
		manual_id = "ragebait_manual_hermitcrab",
		friendly_name = "Hermit Crab",
		required_drop = "purple_gem",
		tier_weight = 1,
		category = "aggressive",
	},
	crawling_horror = {
		manual_id = "ragebait_manual_crawling_horror",
		friendly_name = "Crawling Horror",
		required_drop = "horror_spike",
		tier_weight = 4,
		category = "hostile",
	},
	carrat = {
		manual_id = "ragebait_manual_carrat",
		friendly_name = "Carrat",
		required_drop = "purple_gem",
		tier_weight = 1,
		category = "hostile",
	},
	snapper = {
		manual_id = "ragebait_manual_snapper",
		friendly_name = "Snapper",
		required_drop = "purple_gem",
		tier_weight = 2,
		category = "hostile",
	},
	sting_ray = {
		manual_id = "ragebait_manual_sting_ray",
		friendly_name = "Stingray",
		required_drop = "purple_gem",
		tier_weight = 2,
		category = "hostile",
	},
	whale_shark = {
		manual_id = "ragebait_manual_whale_shark",
		friendly_name = "Whale Shark",
		required_drop = "whale_tooth",
		tier_weight = 4,
		category = "boss",
	},
	
	-- SEASONAL / RARE CREATURES
	lava_arena_tree = {
		manual_id = "ragebait_manual_lava_arena_tree",
		friendly_name = "Lava Tree",
		required_drop = "volcanic_ash",
		tier_weight = 3,
		category = "hostile",
	},
	magma_golem = {
		manual_id = "ragebait_manual_magma_golem",
		friendly_name = "Magma Golem",
		required_drop = "magma_golem_head",
		tier_weight = 4,
		category = "boss",
	},
	stalker = {
		manual_id = "ragebait_manual_stalker",
		friendly_name = "Stalker",
		required_drop = "stalker_spike",
		tier_weight = 3,
		category = "hostile",
	},
	wove = {
		manual_id = "ragebait_manual_wove",
		friendly_name = "Wove",
		required_drop = "wove_shell",
		tier_weight = 3,
		category = "hostile",
	},
	gargoyle = {
		manual_id = "ragebait_manual_gargoyle",
		friendly_name = "Gargoyle",
		required_drop = "gargoyle_stone",
		tier_weight = 3,
		category = "hostile",
	},
}

-- TIER UNLOCK THRESHOLDS (number of distinct manuals needed)
-- Adjusted for 62-creature roster (early: 1-4, mid: 10, late-mid: 20, late: 45)
local TIER_THRESHOLDS = {
	[1] = 1,   -- 1.6% of roster - immediate unlock
	[2] = 4,   -- 6.5% of roster - early game
	[3] = 10,  -- 16% of roster - mid game
	[4] = 20,  -- 32% of roster - late mid game
	[5] = 45,  -- 73% of roster - late game (aspirational but achievable)
}

-- Helper function to get a creature's mapping by prefab name
local function GetCreatureMapping(prefab_name)
	return CREATURE_MAP[prefab_name]
end

-- Helper function to get all creatures (returns a list of prefab names)
local function GetAllCreatures()
	local creatures = {}
	for prefab_name, _ in pairs(CREATURE_MAP) do
		table.insert(creatures, prefab_name)
	end
	table.sort(creatures)
	return creatures
end

-- Helper function to count total creatures
local function GetTotalCreatureCount()
	local count = 0
	for _, _ in pairs(CREATURE_MAP) do
		count = count + 1
	end
	return count
end

-- Helper function to get tier threshold
local function GetTierThreshold(tier)
	return TIER_THRESHOLDS[tier]
end

-- Helper function to get current tier from distinct manual count
local function CalculateTierFromCount(distinct_count)
	if distinct_count >= TIER_THRESHOLDS[5] then
		return 5
	elseif distinct_count >= TIER_THRESHOLDS[4] then
		return 4
	elseif distinct_count >= TIER_THRESHOLDS[3] then
		return 3
	elseif distinct_count >= TIER_THRESHOLDS[2] then
		return 2
	elseif distinct_count >= TIER_THRESHOLDS[1] then
		return 1
	else
		return 0
	end
end

return {
	CREATURE_MAP = CREATURE_MAP,
	TIER_THRESHOLDS = TIER_THRESHOLDS,
	GetCreatureMapping = GetCreatureMapping,
	GetAllCreatures = GetAllCreatures,
	GetTotalCreatureCount = GetTotalCreatureCount,
	GetTierThreshold = GetTierThreshold,
	CalculateTierFromCount = CalculateTierFromCount,
}
