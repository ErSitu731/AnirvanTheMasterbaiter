-- Ragebait Buff Component
-- Manages active ragebait state, player buffs/debuffs, target taunt, and interruptions
-- Core mechanic: player gains speed/damage-taken buff but deals less damage; one hit cancels buff

local RAGEBAIT_CONSTANTS = require("data/ragebait_constants")

local RagebaitBuff = Class(function(self, inst)
	self.inst = inst
	self.is_active = false
	self.target = nil
	self.original_walkspeed = nil
	self.original_damage_mult = nil
	
	-- Listen for player removal (death, disconnect, etc.) to clean up active ragebait
	inst:ListenForEvent("onremove", function()
		if self.is_active then
			self:DeactivateRagebait("PLAYER_REMOVED")
		end
	end)
end)

-- Activate ragebait on target enemy
function RagebaitBuff:ActivateRagebait(target)
	if self.is_active then
		self:DeactivateRagebait("NEW_ACTIVATION")
	end
	
	self.is_active = true
	self.target = target
	
	-- Apply player buffs
	self:_ApplyPlayerBuffs()
	
	-- Apply target taunt
	self:_ApplyTargetTaunt(target)
	
	-- Setup interruption listeners
	self:_SetupInterruptionListeners()
	
	-- Broadcast activation event
	self.inst:PushEvent("ragebait_buff_active", { target = target })
end

-- Apply movement speed and damage-taken buffs to player
function RagebaitBuff:_ApplyPlayerBuffs()
	local locomotor = self.inst.components.locomotor
	if locomotor then
		self.original_walkspeed = locomotor.walkspeed
		local speed_bonus = RAGEBAIT_CONSTANTS.PLAYER_MOVEMENT_SPEED_BONUS
		locomotor:SetExternalSpeedMultiplier(self.inst, "ragebait_buff", 1.0 + speed_bonus)
	end
	
	-- Apply damage multiplier (player takes more damage from target)
	local combat = self.inst.components.combat
	if combat then
		self.original_damage_mult = combat.externaldamagemultipliers:Get()
		combat.externaldamagemultipliers:SetModifier(self.inst, RAGEBAIT_CONSTANTS.PLAYER_DAMAGE_MULTIPLIER, "ragebait_buff")
	end
end

-- Remove player buffs
function RagebaitBuff:_RemovePlayerBuffs()
	local locomotor = self.inst.components.locomotor
	if locomotor then
		locomotor:RemoveExternalSpeedMultiplier(self.inst, "ragebait_buff")
	end
	
	local combat = self.inst.components.combat
	if combat then
		combat.externaldamagemultipliers:RemoveModifier(self.inst, "ragebait_buff")
	end
end

-- Apply taunt to target enemy (force it to target only the player)
function RagebaitBuff:_ApplyTargetTaunt(target)
	if not target or not target:IsValid() then
		return
	end
	
	-- Mark target as taunted by ragebait for debugging/indicator purposes
	target:AddTag("ragebait_taunted")
	
	-- Override target's combat component to only attack the player
	-- This is the core AI override that makes the mechanic work
	local combat = target.components.combat
	if combat then
		-- Store the target's original target (might be another entity or nil)
		-- This allows restoration of original targeting when ragebait ends
		target._ragebait_original_target = combat.target
		
		-- CRITICAL: Force combat target to the player with maximum priority
		-- SetTarget directly changes who the entity is trying to attack
		combat:SetTarget(self.inst)
		
		-- ShareTarget adds this target with very high priority (999)
		-- The function returns false, preventing other entities from stealing focus
		-- This ensures the taunted enemy stays fixated on the player during ragebait
		combat:ShareTarget(self.inst, 999, function() return false end, 1)
	end
	
	-- Listen for target death event to trigger ragebait end
	-- We use inst:ListenForEvent to automatically clean up when ragebait is destroyed
	self.inst:ListenForEvent("death", function()
		self:DeactivateRagebait("TARGET_DIED")
	end, target)
end

-- Remove taunt from target
function RagebaitBuff:_RemoveTargetTaunt()
	if not self.target or not self.target:IsValid() then
		return
	end
	
	self.target:RemoveTag("ragebait_taunted")
	
	-- Restore original combat target (or clear if dead/invalid)
	local combat = self.target.components.combat
	if combat and self.target._ragebait_original_target then
		if self.target._ragebait_original_target:IsValid() then
			combat:SetTarget(self.target._ragebait_original_target)
		else
			combat:SetTarget(nil)
		end
		self.target._ragebait_original_target = nil
	end
end

-- Setup listeners for interruption conditions
function RagebaitBuff:_SetupInterruptionListeners()
	-- Listen for player taking damage (one-hit-cancel)
	self.inst:ListenForEvent("attacked", function(inst, data)
		if self.is_active then
			self:DeactivateRagebait("PLAYER_HIT")
			
			-- Trigger stealth mode if Tier >= 3
			local stealth = inst.components.ragebait_stealth
			if stealth then
				stealth:ActivateStealth("INTERRUPT")
			end
		end
	end)
	
	-- Listen for staff unequip
	self.inst:ListenForEvent("unequip", function(inst, data)
		if self.is_active and data and data.item and data.item:HasTag("ragebait_staff") then
			self:DeactivateRagebait("STAFF_UNEQUIPPED")
		end
	end)
end

-- Deactivate ragebait and clean up
function RagebaitBuff:DeactivateRagebait(reason)
	if not self.is_active then
		return
	end
	
	self.is_active = false
	
	-- Remove player buffs
	self:_RemovePlayerBuffs()
	
	-- Remove target taunt
	self:_RemoveTargetTaunt()
	
	-- Clear target reference
	self.target = nil
	
	-- Broadcast deactivation event
	self.inst:PushEvent("ragebait_buff_deactivated", { reason = reason })
end

-- Check if ragebait is currently active
function RagebaitBuff:IsActive()
	return self.is_active
end

-- Get current target
function RagebaitBuff:GetTarget()
	return self.target
end

-- Modify player's outgoing damage while ragebait is active
function RagebaitBuff:ModifyOutgoingDamage(target, original_damage)
	if not self.is_active then
		return original_damage
	end
	
	-- Player deals reduced damage while ragebait is active
	local damage_reduction = RAGEBAIT_CONSTANTS.PLAYER_DAMAGE_OUTPUT_REDUCTION
	return original_damage * (1.0 - damage_reduction)
end

function RagebaitBuff:OnSave()
	local data = {}
	data.is_active = self.is_active
	if self.target and self.target:IsValid() then
		data.target = self.target.GUID
	end
	return data
end

function RagebaitBuff:OnLoad(data)
	if data and data.is_active then
		-- Note: target will need to be re-resolved from GUID (advanced)
		-- For now, ragebait state doesn't persist across save/load
		self.is_active = false
	end
end

return RagebaitBuff
