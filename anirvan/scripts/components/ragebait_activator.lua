-- Ragebait Activator Component
-- Handles ragebait activation preconditions and range calculations
-- Integrates with staff to trigger ragebait on target enemies

local RAGEBAIT_CONSTANTS = require("data/ragebait_constants")
local CREATURE_MAP = require("data/ragebait_creature_map")

local RagebaitActivator = Class(function(self, inst)
	self.inst = inst
	self.current_tier = 1
end)

-- Called when tier is unlocked (from ragebait_progress)
function RagebaitActivator:OnTierUnlock(tier)
	self.current_tier = tier
end

-- Calculate effective range based on player's sanity
-- Low sanity = longer range (more desperate/aggressive)
function RagebaitActivator:GetEffectiveRange()
	local sanity = self.inst.components.sanity
	if not sanity then
		return RAGEBAIT_CONSTANTS.BASE_RANGE
	end
	
	local sanity_percent = sanity:GetPercent()
	local range_multiplier = RAGEBAIT_CONSTANTS.GetRangeMultiplier(sanity_percent)
	
	return RAGEBAIT_CONSTANTS.BASE_RANGE * range_multiplier
end

-- Check if player has crafted the manual for the target creature
function RagebaitActivator:HasManualForTarget(target)
	if not target or not target.prefab then
		return false
	end
	
	local creature_map = CREATURE_MAP.GetCreatureMapping(target.prefab)
	if not creature_map then
		print("[Ragebait] No creature mapping for prefab: " .. tostring(target.prefab))
		return false, "NO_MANUAL_EXISTS"  -- Creature not in ragebait system
	end
	
	local progress = self.inst.components.ragebait_progress
	if not progress then
		print("[Ragebait] No progress component on player")
		return false, "NO_PROGRESS_COMPONENT"
	end
	
	if not progress:HasCraftedManual(target.prefab) then
		print("[Ragebait] Manual not crafted for: " .. tostring(target.prefab))
		return false, "MANUAL_NOT_CRAFTED"
	end
	
	return true
end

-- Check if ragebait can be activated on target
function RagebaitActivator:CanActivateRagebait(target)
	-- Check if staff is equipped
	local inventory = self.inst.components.inventory
	if not inventory then
		print("[Ragebait] No inventory component")
		return false, "NO_INVENTORY"
	end
	
	local equipped_item = inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
	if not equipped_item or not equipped_item:HasTag("ragebait_staff") then
		print("[Ragebait] Staff not equipped")
		return false, "STAFF_NOT_EQUIPPED"
	end
	
	-- Check if on cooldown
	local cooldown = self.inst.components.ragebait_cooldown
	if cooldown and cooldown:IsOnCooldown() then
		print("[Ragebait] On cooldown")
		return false, "ON_COOLDOWN"
	end
	
	-- Check if target is valid
	if not target or not target:IsValid() then
		print("[Ragebait] Invalid target")
		return false, "INVALID_TARGET"
	end
	
	-- Check if target is immune (boss, special creature)
	local immune_tags = RAGEBAIT_CONSTANTS.IMMUNE_TAGS
	for _, tag in ipairs(immune_tags) do
		if target:HasTag(tag) then
			print("[Ragebait] Target immune due to tag: " .. tag)
			return false, "TARGET_IMMUNE"
		end
	end
	
	-- Check if target can fight (has combat component or is in our creature map)
	-- We allow neutral creatures like pigmen since they're in the creature map
	local creature_map = CREATURE_MAP.GetCreatureMapping(target.prefab)
	if not creature_map then
		-- Not in creature map - only allow if hostile/monster
		if not (target:HasTag("monster") or target:HasTag("hostile")) then
			print("[Ragebait] Target not in creature map and not hostile: " .. tostring(target.prefab))
			return false, "TARGET_NOT_HOSTILE"
		end
	end
	
	-- Check if target can be attacked (has health and combat)
	if not target.components.health or not target.components.combat then
		print("[Ragebait] Target has no health or combat component")
		return false, "TARGET_CANNOT_FIGHT"
	end
	
	-- Check if target is already dead
	if target:HasTag("dead") or target.components.health:IsDead() then
		print("[Ragebait] Target is dead")
		return false, "TARGET_DEAD"
	end
	
	-- Check if player has crafted manual for this creature
	local has_manual, reason = self:HasManualForTarget(target)
	if not has_manual then
		return false, reason
	end
	
	-- Check if target is in range
	local effective_range = self:GetEffectiveRange()
	local distance = self.inst:GetDistanceSqToInst(target)
	print("[Ragebait] Distance check: " .. math.sqrt(distance) .. " vs range " .. effective_range)
	if distance > (effective_range * effective_range) then
		return false, "OUT_OF_RANGE"
	end
	
	-- All preconditions passed
	print("[Ragebait] All preconditions passed!")
	return true
end

-- Activate ragebait on target enemy
function RagebaitActivator:ActivateRagebait(target)
	local can_activate, reason = self:CanActivateRagebait(target)
	
	if not can_activate then
		-- Check if target is immune - don't start cooldown if configured to bypass
		local should_bypass_cooldown = (reason == "TARGET_IMMUNE" and RAGEBAIT_CONSTANTS.BYPASS_COOLDOWN_ON_IMMUNE)
		
		-- Send feedback to player about why activation failed
		self.inst:PushEvent("ragebait_activation_failed", { 
			reason = reason,
			target = target,
			bypassed_cooldown = should_bypass_cooldown,
		})
		
		-- If not bypassing cooldown for immune targets, start cooldown anyway as penalty
		if not should_bypass_cooldown and reason ~= "ON_COOLDOWN" and reason ~= "STAFF_NOT_EQUIPPED" then
			-- Start cooldown for failed activation (except for basic precondition failures)
			local cooldown = self.inst.components.ragebait_cooldown
			if cooldown then
				cooldown:StartCooldown()
			end
		end
		
		return false, reason
	end
	
	-- Apply ragebait buff to player and target
	local buff = self.inst.components.ragebait_buff
	if buff then
		buff:ActivateRagebait(target)
	end
	
	-- Start cooldown
	local cooldown = self.inst.components.ragebait_cooldown
	if cooldown then
		cooldown:StartCooldown()
	end
	
	-- Broadcast activation event
	self.inst:PushEvent("ragebait_activated", {
		target = target,
		range = self:GetEffectiveRange(),
	})
	
	return true
end

-- Handle staff attack action (when player attacks with ragebait staff)
function RagebaitActivator:OnStaffAttack(target)
	if not target then
		return false
	end
	
	return self:ActivateRagebait(target)
end

-- Get debugging info for UI display
function RagebaitActivator:GetActivationStatus()
	local cooldown = self.inst.components.ragebait_cooldown
	local progress = self.inst.components.ragebait_progress
	
	return {
		tier = progress and progress:GetTier() or 0,
		on_cooldown = cooldown and cooldown:IsOnCooldown() or false,
		cooldown_remaining = cooldown and cooldown:GetRemainingCooldown() or 0,
		effective_range = self:GetEffectiveRange(),
		manuals_crafted = progress and progress:GetDistinctManualsCount() or 0,
	}
end

return RagebaitActivator
