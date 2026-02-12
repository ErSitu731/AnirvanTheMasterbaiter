-- Ragebait Cooldown Component
-- Manages activation cooldown state and tier-dependent durations

local RAGEBAIT_CONSTANTS = require("data/ragebait_constants")

local RagebaitCooldown = Class(function(self, inst)
	self.inst = inst
	self.cooldown_time = 0  -- Remaining cooldown in seconds
	self.total_cooldown = 0  -- Total cooldown duration
	self.is_on_cooldown = false
	self.tier = 1
	
	-- Start periodic update task for cooldown countdown
	self.inst:DoPeriodicTask(0.1, function() self:_UpdateTick(0.1) end)
end)

function RagebaitCooldown:StartCooldown()
	local tier = self.inst.components.ragebait_progress:GetTier()
	self.tier = math.max(1, tier)  -- Enforce minimum tier
	
	-- Get cooldown duration for current tier
	self.total_cooldown = RAGEBAIT_CONSTANTS.GetCooldownForTier(self.tier)
	self.cooldown_time = self.total_cooldown
	self.is_on_cooldown = true
	
	self.inst:PushEvent("ragebait_cooldown_start", { duration = self.total_cooldown })
end

function RagebaitCooldown:IsOnCooldown()
	return self.is_on_cooldown and self.cooldown_time > 0
end

function RagebaitCooldown:GetRemainingCooldown()
	return math.max(0, self.cooldown_time)
end

function RagebaitCooldown:GetCooldownProgress()
	if self.total_cooldown <= 0 then return 1.0 end
	return 1.0 - (self.cooldown_time / self.total_cooldown)
end

function RagebaitCooldown:OnTierUnlock(tier)
	-- When tier increases, recalculate cooldown if currently on cooldown
	self.tier = tier
	if self.is_on_cooldown and self.cooldown_time > 0 then
		-- Optionally reduce remaining cooldown on tier up (can be removed if unwanted)
		local new_max = RAGEBAIT_CONSTANTS.GetCooldownForTier(tier)
		local old_max = RAGEBAIT_CONSTANTS.GetCooldownForTier(tier - 1) or new_max
		self.total_cooldown = new_max
		-- Scale remaining cooldown proportionally
		self.cooldown_time = math.max(0.1, self.cooldown_time * (new_max / old_max))
	end
end

function RagebaitCooldown:_UpdateTick(dt)
	if self.is_on_cooldown then
		self.cooldown_time = math.max(0, self.cooldown_time - dt)
		if self.cooldown_time <= 0 then
			self.is_on_cooldown = false
			self.inst:PushEvent("ragebait_cooldown_complete")
		end
	end
end

function RagebaitCooldown:OnSave()
	local data = {}
	data.cooldown_time = self.cooldown_time
	data.is_on_cooldown = self.is_on_cooldown
	data.tier = self.tier
	return data
end

function RagebaitCooldown:OnLoad(data)
	if data then
		self.cooldown_time = data.cooldown_time or 0
		self.is_on_cooldown = data.is_on_cooldown or false
		self.tier = data.tier or 1
	end
end

return RagebaitCooldown
