local RagebaitController = Class(function(self, inst)
    self.inst = inst
    self.cooldown_end = 0
    self.current_state = "idle" -- idle, active, cooldown, stealth
    self.active_targets = {}
    self.crafted_manuals = {}
    -- Listen for being attacked so a single hit cancels Ragebait
    self.inst:ListenForEvent("attacked", function(inst, data) self:OnHit(data) end)
    -- Listen for player's own attacks to consume stealth burst
    self.inst:ListenForEvent("onattack", function(inst, data) self:OnAttack(data) end)
    self.inst:ListenForEvent("onattackother", function(inst, data) self:OnAttack(data) end)
end)

function RagebaitController:HasCraftedManual(manual_id)
    return self.crafted_manuals[manual_id] == true
end

function RagebaitController:CraftManual(manual_id)
    if not manual_id then return end
    if not self.crafted_manuals[manual_id] then
        self.crafted_manuals[manual_id] = true
        self.inst:PushEvent("ragebait_manualcrafted", {manual = manual_id})
    end
end

function RagebaitController:GetTier()
    local count = 0
    for k,v in pairs(self.crafted_manuals) do
        if v then count = count + 1 end
    end
    if count >= 70 then return 5 end
    if count >= 30 then return 4 end
    if count >= 10 then return 3 end
    if count >= 4 then return 2 end
    if count >= 1 then return 1 end
    return 0
end

function RagebaitController:CanActivate(target, base_range)
    if not target or not target:IsValid() then return false, "invalid target" end
    if GetTime() < (self.cooldown_end or 0) then return false, "cooldown" end
    -- check holding staff
    local eq = self.inst.components.inventory and self.inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
    if not eq or eq.prefab ~= "ragebait_staff" then return false, "no_staff" end
    -- check for immunity tags
    if target:HasTag("non-ragebaitable") or target:HasTag("ragebait_immunity") then return false, "immune" end
    -- check crafted manual exists for the target type
    local manual_id = "ragebait_manual_"..(target.prefab or "")
    if not self:HasCraftedManual(manual_id) then return false, "no_manual" end
    -- check distance with sanity scaling
    local base = base_range or 6
    local sanity = (self.inst.components.sanity and self.inst.components.sanity:GetPercent()) or 1
    local mult = 1
    if sanity <= 0.25 then
        mult = 4
    elseif sanity <= 0.5 then
        mult = 2
    end
    local eff_range = base * mult
    local dx = self.inst:GetDistanceSqToInst(target)
    if dx and dx > (eff_range*eff_range) then return false, "out_of_range" end
    return true
end

function RagebaitController:Activate(target)
    if not target or not target:IsValid() then return end
    
    -- Add tag to mark target as ragebaited
    target:AddTag("ragebaited")
    
    -- Use SuggestTarget instead of SetTarget (vanilla pattern)
    -- This allows the creature's AI to decide whether to accept the suggestion
    if target.components.combat and self.inst then
        target.components.combat:SuggestTarget(self.inst)
    end
    
    -- Success confirmation phrase
    if self.inst.components.talker then
        local creature_name = target:GetDisplayName() or "creature"
        self.inst.components.talker:Say("Ragebait successful! The "..creature_name.." is enraged!")
    end
    
    table.insert(self.active_targets, target)
    self.current_state = "active"

    -- Tier 2 Ally Buffs: start periodic update to apply buffs to nearby allies
    if self:GetTier() >= 2 then
        self.buff_targets = self.buff_targets or {}
        if self.buff_task then
            self.buff_task:Cancel()
            self.buff_task = nil
        end
        self.buff_task = self.inst:DoPeriodicTask(1, function() self:UpdateAllyBuffs() end)
        -- immediate apply
        self:UpdateAllyBuffs()
    end
end

function RagebaitController:CancelRagebait(reason)
    for i, t in ipairs(self.active_targets) do
        if t and t:IsValid() then
            t:RemoveTag("ragebaited")
            -- Only drop target if they're still targeting us
            if t.components.combat and t.components.combat.target == self.inst then
                t.components.combat:DropTarget()
            end
        end
    end
    self.active_targets = {}

    -- remove ally buffs if any
    if self.buff_task then
        self.buff_task:Cancel()
        self.buff_task = nil
    end
    if self.buff_targets then
        for ally, _ in pairs(self.buff_targets) do
            self:RemoveBuffFromAlly(ally)
        end
        self.buff_targets = {}
    end

    self.current_state = "cooldown"
    local tier = self:GetTier()
    local cd = 60
    if tier == 2 then cd = 55
    elseif tier == 3 then cd = 45
    elseif tier == 4 then cd = 30
    elseif tier == 5 then cd = 20 end
    self.cooldown_end = GetTime() + cd
    if reason == "hit" and tier >= 3 then
        self:EnterStealth()
    end
end

function RagebaitController:EnterStealth()
    if self.current_state == "stealth" then return end
    self.current_state = "stealth"
    self.stealth_duration = 6 -- tunable
    self.stealth_end_time = GetTime() + self.stealth_duration
    self.stealth_burst_used = false

    -- Make player less targetable by AI; add readable tag
    self.inst:AddTag("ragebait_stealth")
    self.inst:AddTag("notarget")

    -- spawn stealth FX if available
    if self.inst and self.inst.Transform then
        local fx = SpawnPrefab("ragebait_stealth_fx")
        if fx then
            fx.entity:SetParent(self.inst.entity)
            fx.Transform:SetPosition(0,0,0)
            self._stealth_fx = fx
        end
    end

    -- schedule exit
    if self.stealth_task then
        self.stealth_task:Cancel()
        self.stealth_task = nil
    end
    self.stealth_task = self.inst:DoTaskInTime(self.stealth_duration, function() self:ExitStealth() end)

    self.inst:PushEvent("enter_ragebait_stealth")
end

function RagebaitController:ExitStealth()
    if self.current_state ~= "stealth" then return end
    self.current_state = "cooldown"
    if self.stealth_task then
        self.stealth_task:Cancel()
        self.stealth_task = nil
    end
    if self._stealth_fx then
        self._stealth_fx:Remove()
        self._stealth_fx = nil
    end
    self.inst:RemoveTag("ragebait_stealth")
    self.inst:RemoveTag("notarget")
    self.inst:PushEvent("exit_ragebait_stealth")
end

function RagebaitController:OnAttack(data)
    -- data may contain target; respond only if we're in stealth
    if self.current_state ~= "stealth" then return end
    if self.stealth_burst_used then return end
    self.stealth_burst_used = true

    -- Apply burst: temporarily amplify player's damage multiplier for this attack
    if self.inst.components and self.inst.components.combat then
        local prev = self.inst.components.combat.damagemultiplier or 1
        local burst_mult = 2.0 -- tunable
        self.inst.components.combat.damagemultiplier = prev * burst_mult
        -- Restore on next tick to avoid lingering multiplier
        self.inst:DoTaskInTime(0, function()
            if self.inst and self.inst.components and self.inst.components.combat then
                self.inst.components.combat.damagemultiplier = prev
            end
        end)
    end

    -- End stealth immediately after burst attack
    self:ExitStealth()
end

function RagebaitController:OnHit(data)
    -- When player is hit, cancel active ragebait
    if self.current_state == "active" then
        self:CancelRagebait("hit")
    end
end

-- Ally buff routines
function RagebaitController:ApplyBuffToAlly(ally)
    if not ally or not ally:IsValid() or ally == self.inst then return end
    self.buff_targets = self.buff_targets or {}
    if self.buff_targets[ally] then return end -- already buffed

    -- store previous value and apply damage multiplier buff
    if ally.components and ally.components.combat then
        local prev = ally.components.combat.damagemultiplier or 1
        self.buff_targets[ally] = prev
        ally.components.combat.damagemultiplier = prev * 1.15 -- +15% damage
        -- visual FX
        if ally.Transform then
            local fx = SpawnPrefab("ragebait_ally_buff_fx")
            if fx then
                fx.entity:SetParent(ally.entity)
                fx.Transform:SetPosition(0,0,0)
                ally._ragebait_buff_fx = fx
            end
        end
    end
end

function RagebaitController:RemoveBuffFromAlly(ally)
    if not ally or not ally:IsValid() then return end
    if not self.buff_targets or not self.buff_targets[ally] then return end
    local prev = self.buff_targets[ally]
    if ally.components and ally.components.combat then
        ally.components.combat.damagemultiplier = prev
    end
    if ally._ragebait_buff_fx then
        ally._ragebait_buff_fx:Remove()
        ally._ragebait_buff_fx = nil
    end
    self.buff_targets[ally] = nil
end

function RagebaitController:UpdateAllyBuffs()
    if self.current_state ~= "active" then return end
    local radius = 8
    local x,y,z = self.inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x,y,z, radius, {"player"},{"playerghost"})
    local current = {}
    for _, ally in ipairs(ents) do
        if ally ~= self.inst then
            current[ally] = true
            if not (self.buff_targets and self.buff_targets[ally]) then
                self:ApplyBuffToAlly(ally)
            end
        end
    end
    -- remove buffs from allies who left the radius
    if self.buff_targets then
        for ally, _ in pairs(self.buff_targets) do
            if not current[ally] then
                self:RemoveBuffFromAlly(ally)
            end
        end
    end
end

function RagebaitController:OnSave()
    return { crafted = self.crafted_manuals }
end

function RagebaitController:OnLoad(data)
    if data and data.crafted then
        self.crafted_manuals = data.crafted
    end
end

return RagebaitController