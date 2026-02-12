-- Ragebait Multi-Target Component (Stub)
-- Tier 4+ feature: Activate ragebait on multiple enemies simultaneously
-- TODO: Implement multi-target tracking and concurrent buff management

local RagebaitMultiTarget = Class(function(self, inst)
	self.inst = inst
	self.active_targets = {}
	self.max_targets = 1  -- Tier 1-3: single target
end)

function RagebaitMultiTarget:OnTierUnlock(tier)
	-- Update max targets based on tier
	if tier >= 4 then
		self.max_targets = 3  -- Tier 4+: 3 simultaneous targets
	else
		self.max_targets = 1
	end
end

function RagebaitMultiTarget:CanAddTarget()
	return #self.active_targets < self.max_targets
end

function RagebaitMultiTarget:AddTarget(target)
	-- TODO: Implement multi-target tracking
	-- - Validate target
	-- - Apply ragebait to target
	-- - Track in active_targets list
	print("[Ragebait Multi-Target] Target added (stub): " .. tostring(target))
end

function RagebaitMultiTarget:RemoveTarget(target)
	-- TODO: Implement target removal
	-- - Remove from active_targets
	-- - Clean up buffs/taunts
	print("[Ragebait Multi-Target] Target removed (stub): " .. tostring(target))
end

return RagebaitMultiTarget
