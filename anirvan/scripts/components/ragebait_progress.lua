-- Ragebait Progress Component
-- Tracks player's crafted manuals, tier progression, and sends callbacks on unlock

local CREATURE_MAP = require("data/ragebait_creature_map")
local RAGEBAIT_CONSTANTS = require("data/ragebait_constants")

local RagebaitProgress = Class(function(self, inst)
	self.inst = inst
	self.crafted_manuals = {}  -- Set of creature IDs the player has crafted
	self.current_tier = 0
	self.tier_unlocked = {}  -- Track which tiers have been unlocked this session
end)

function RagebaitProgress:GetTier()
	return self.current_tier
end

function RagebaitProgress:GetDistinctManualsCount()
	local count = 0
	for _, _ in pairs(self.crafted_manuals) do
		count = count + 1
	end
	return count
end

function RagebaitProgress:HasCraftedManual(creature_id)
	return self.crafted_manuals[creature_id] ~= nil
end

function RagebaitProgress:MarkManualCrafted(creature_id)
	if not self:HasCraftedManual(creature_id) then
		self.crafted_manuals[creature_id] = true
		self:_UpdateTier()
		self.inst:PushEvent("ragebait_manual_crafted", { creature_id = creature_id })
		return true  -- First craft
	end
	return false  -- Already crafted
end

function RagebaitProgress:_UpdateTier()
	-- Get the current count of distinct creature manuals crafted
	local count = self:GetDistinctManualsCount()
	
	-- Calculate what tier this count should be (1/4/10/20/45 thresholds)
	-- This function walks through tiers in descending order to find the highest tier achieved
	-- Example: If count=15, it exceeds T3(10) but not T4(20), returns 3
	local new_tier = CREATURE_MAP.CalculateTierFromCount(count)
	
	-- IMPORTANT: Only unlock tiers that are higher than current tier
	-- This prevents downgrades and ensures "tier unlocked" events only fire on genuine progression
	if new_tier > self.current_tier then
		self.current_tier = new_tier
		self.tier_unlocked[new_tier] = true
		
		-- Broadcast tier unlock event to all listeners
		-- Components listen for this to update their tier-dependent behavior
		self.inst:PushEvent("ragebait_tier_unlocked", { tier = new_tier })
		
		-- Notify connected components about tier unlock
		-- Each component updates its tier-specific behavior independently
		if self.inst.components.ragebait_activator then
			self.inst.components.ragebait_activator:OnTierUnlock(new_tier)
		end
		if self.inst.components.ragebait_cooldown then
			self.inst.components.ragebait_cooldown:OnTierUnlock(new_tier)
		end
	end
end

function RagebaitProgress:GetTierThreshold(tier)
	return CREATURE_MAP.GetTierThreshold(tier)
end

function RagebaitProgress:GetProgressToNextTier()
	local current_count = self:GetDistinctManualsCount()
	local next_tier = self.current_tier + 1
	
	if next_tier > 5 then
		return nil  -- No next tier
	end
	
	local next_threshold = self:GetTierThreshold(next_tier)
	return {
		current = current_count,
		needed = next_threshold,
		remaining = next_threshold - current_count,
		percentage = (current_count / next_threshold) * 100,
	}
end

function RagebaitProgress:OnSave()
	local data = {}
	data.crafted_manuals = {}
	for creature_id, _ in pairs(self.crafted_manuals) do
		table.insert(data.crafted_manuals, creature_id)
	end
	data.current_tier = self.current_tier
	return data
end

function RagebaitProgress:OnLoad(data)
	if data and data.crafted_manuals then
		for _, creature_id in ipairs(data.crafted_manuals) do
			self.crafted_manuals[creature_id] = true
		end
		self.current_tier = data.current_tier or 0
	end
end

return RagebaitProgress
