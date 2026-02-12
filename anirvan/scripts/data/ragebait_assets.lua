-- Ragebait Assets Configuration
-- Stores placeholder asset paths for staff, manuals, animations, and FX
-- All asset paths reference vanilla DST assets; TODO entries indicate art team replacements needed

local RAGEBAIT_ASSETS = {
	-- STAFF ITEM ASSETS
	staff = {
		atlas = "images/inventoryimages/ragebait_staff.xml",
		image = "ragebait_staff.tex",
		-- TODO: Replace with custom staff icon (512x512 PNG -> TEX via TexCreator)
		fallback_atlas = "images/inventoryimages/staff.xml",
		fallback_image = "staff.tex",
	},

	-- MANUAL ITEM ASSETS (generic template, per-creature variants use same base with creature-specific icon)
	manual = {
		atlas = "images/inventoryimages/ragebait_manual.xml",
		image = "ragebait_manual.tex",
		-- TODO: Replace with custom manual/book icon (512x512 PNG -> TEX via TexCreator)
		fallback_atlas = "images/inventoryimages/papyrus.xml",
		fallback_image = "papyrus.tex",
	},

	-- HUD & UI ASSETS
	hud = {
		cooldown_ring = "images/hud/ragebait_cooldown.xml",
		-- TODO: Create cooldown ring/bar texture (circular progress ring, ~256x256)
		fallback = "images/hud/cookpot_meter.xml",

		active_indicator = "images/hud/ragebait_active.xml",
		-- TODO: Create "RAGEBAIT ACTIVE" indicator texture
		
		stealth_indicator = "images/hud/ragebait_stealth.xml",
		-- TODO: Create stealth mode indicator (when Tier >= 3)
	},

	-- WORLD INDICATORS (displayed above enemies/allies)
	world_indicators = {
		ragebait_target = "images/fxatlas/ragebait_target.xml",
		-- TODO: Create taunt icon/aura for ragebaited enemies
		fallback = "images/fxatlas/target_ring_indicator.xml",

		ally_buff = "images/fxatlas/ragebait_buff.xml",
		-- TODO: Create ally buff aura/icon (for Tier 2+ teammates)
		fallback = "images/fxatlas/buff_indicator.xml",
	},

	-- ANIMATIONS
	animations = {
		staff_idle = "anim/ragebait_staff.zip",
		-- TODO: Create staff idle animation (loop, simple float/spin)
		fallback_idle = "anim/staff.zip",

		staff_attack = "anim/ragebait_staff_attack.zip",
		-- TODO: Create staff attack animation (swing motion)
		fallback_attack = "anim/staff.zip",

		manual_open = "anim/ragebait_manual.zip",
		-- TODO: Create manual open/flip animation
		fallback_open = "anim/papyrus.zip",

		taunt_burst = "anim/ragebait_taunt_fx.zip",
		-- TODO: Create visual effect for taunt activation (burst/aura animation)
		fallback_burst = "anim/sanctum_burst.zip",

		stealth_shimmer = "anim/ragebait_stealth.zip",
		-- TODO: Create stealth activation shimmer/invisibility effect
		fallback_shimmer = "anim/sanctum_transmute_fx.zip",
	},

	-- PARTICLE/FX EFFECTS
	effects = {
		taunt_aura = "ragebait_taunt_aura",
		-- TODO: Create particle effect for taunted enemy (aura/glow)
		-- Fallback: use vanilla taunt effect if available

		activation_burst = "ragebait_activation_burst",
		-- TODO: Create burst effect when ragebait activates
		-- Fallback: use staff swing FX

		cooldown_tick = "ragebait_cooldown_tick",
		-- TODO: Create subtle tick/pulse effect for cooldown HUD

		stealth_shimmer_fx = "ragebait_stealth_shimmer",
		-- TODO: Create shimmer effect when stealth activates (Tier 3+)
	},

	-- SOUNDS (placeholder references, actual audio TBD by sound team)
	sounds = {
		staff_activate = "dontstarve/quagmire/mutate.fsb",
		-- TODO: Replace with ragebait activation sound (taunt/roar burst)
		
		staff_cancel = "dontstarve/common/sfx/cave/cave_dig.fsb",
		-- TODO: Replace with ragebait cancel sound (whiff/drop)
		
		cooldown_complete = "dontstarve/common/sfx/crafting.fsb",
		-- TODO: Replace with cooldown ready/ding sound
		
		tier_unlock = "dontstarve/common/sfx/explosion.fsb",
		-- TODO: Replace with tier progression sound (power-up chime)
		
		stealth_activate = "dontstarve/common/sfx/shadows.fsb",
		-- TODO: Replace with stealth activation sound (shimmer/shimmer)
	},
}

-- Helper function to get asset path (with fallback)
local function GetAssetPath(category, subcategory)
	local asset = RAGEBAIT_ASSETS[category]
	if not asset then
		return nil
	end
	
	if subcategory then
		return asset[subcategory]
	end
	return asset
end

-- Helper function to build atlas/texture pairs with fallback support
local function GetAtlasTexturePair(category, use_fallback)
	local asset = RAGEBAIT_ASSETS[category]
	if not asset then
		return nil, nil
	end
	
	if use_fallback or not asset.atlas then
		return asset.fallback_atlas, asset.fallback_image
	end
	return asset.atlas, asset.image
end

-- Helper function to get animation path with fallback
local function GetAnimationPath(anim_type, use_fallback)
	local anim = RAGEBAIT_ASSETS.animations[anim_type]
	if not anim then
		return nil
	end
	
	if use_fallback or not anim then
		return anim.fallback_idle or anim.fallback_attack or anim.fallback_open
	end
	return anim[anim_type] or nil
end

-- Helper function for listing all asset TODO items
local function ListAssetTODOs()
	local todos = {}
	
	-- Walk through RAGEBAIT_ASSETS and collect TODO comments
	for category, assets in pairs(RAGEBAIT_ASSETS) do
		if type(assets) == "table" then
			for key, value in pairs(assets) do
				if key:find("TODO") or (type(value) == "string" and value:find("TODO")) then
					table.insert(todos, category .. "." .. key)
				end
			end
		end
	end
	
	return todos
end

return {
	RAGEBAIT_ASSETS = RAGEBAIT_ASSETS,
	GetAssetPath = GetAssetPath,
	GetAtlasTexturePair = GetAtlasTexturePair,
	GetAnimationPath = GetAnimationPath,
	ListAssetTODOs = ListAssetTODOs,
}
