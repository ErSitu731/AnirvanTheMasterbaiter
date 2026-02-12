-- Simple unit tests for ragebait_controller component

local RagebaitController = require("components/ragebait_controller")

local function make_mock_inst()
    local inst = {}
    inst.components = {}
    inst.events = {}
    function inst:PushEvent(name, data)
        self.events[name] = data or true
    end
    inst.ListenForEvent = function(self, evt, fn) self._listener = fn end
    -- mock inventory and sanity components
    inst.components.inventory = {
        equipped = nil,
        GetEquippedItem = function(self, slot) return self.equipped end,
        GiveItem = function() end,
    }
    inst.components.sanity = {
        _percent = 1,
        GetPercent = function(self) return self._percent end,
        SetPercent = function(self, p) self._percent = p end,
    }
    -- Pushtimer helper
    return inst
end

local function run_tests()
    print("Running RagebaitController tests...")

    -- Test CraftManual and event
    do
        local inst = make_mock_inst()
        local comp = RagebaitController(inst)
        comp:CraftManual("ragebait_manual_hound")
        assert(comp:HasCraftedManual("ragebait_manual_hound") == true, "CraftManual should set flag")
        assert(inst.events.ragebait_manualcrafted, "Should push ragebait_manualcrafted event")
    end

    -- Test GetTier thresholds
    do
        local inst = make_mock_inst()
        local comp = RagebaitController(inst)
        assert(comp:GetTier() == 0, "No manuals -> tier 0")
        comp.crafted_manuals = { a=true }
        assert(comp:GetTier() == 1, "1 manual -> tier 1")
        comp.crafted_manuals = { a=true, b=true, c=true, d=true }
        assert(comp:GetTier() == 2, "4 manuals -> tier 2")
        comp.crafted_manuals = {}
        for i=1,10 do comp.crafted_manuals[tostring(i)] = true end
        assert(comp:GetTier() >= 3, "10+ manuals -> tier >=3")
    end

    -- Test CanActivate: missing staff
    do
        local inst = make_mock_inst()
        local comp = RagebaitController(inst)
        local ok, reason = comp:CanActivate({prefab = "hound"})
        assert(ok == false and reason == "no_staff", "Should fail without staff")
    end

    -- Test CanActivate: manual not crafted
    do
        local inst = make_mock_inst()
        local comp = RagebaitController(inst)
        inst.components.inventory.equipped = { prefab = "ragebait_staff" }
        local ok, reason = comp:CanActivate({prefab = "hound"})
        assert(ok == false and reason == "no_manual", "Should fail without manual crafted")
    end

    -- Test sanity range scaling (out_of_range case)
    do
        local inst = make_mock_inst()
        local comp = RagebaitController(inst)
        inst.components.inventory.equipped = { prefab = "ragebait_staff" }
        comp:CraftManual("ragebait_manual_hound")
        -- create a fake target at distance by mocking GetDistanceSqToInst
        local target = { prefab = "hound", IsValid = function() return true end }
        inst.GetDistanceSqToInst = function(self, t) return 10000 end -- very far
        local ok, reason = comp:CanActivate(target, 6)
        assert(ok == false and reason == "out_of_range", "Should be out_of_range when distance is large")
        -- now set sanity low to expand range
        inst.components.sanity._percent = 0.2
        inst.GetDistanceSqToInst = function(self, t) return 9 end -- distance 3
        local ok2, reason2 = comp:CanActivate(target, 1)
        assert(ok2 == true, "Low sanity should expand range and allow activation")
    end

    -- Test Cancel on hit triggers stealth when tier >=3
    do
        local inst = make_mock_inst()
        local comp = RagebaitController(inst)
        for i=1,10 do comp.crafted_manuals[tostring(i)] = true end -- tier >=3
        comp.active_targets = { { IsValid = function() return true end } }
        comp.current_state = "active"
        comp:OnHit()
        assert(comp.current_state == "cooldown" or comp.current_state == "stealth" , "OnHit should cancel and set cooldown and possibly stealth")
    end

    -- Test save/load persistence
    do
        local inst = make_mock_inst()
        local comp = RagebaitController(inst)
        comp:CraftManual("ragebait_manual_hound")
        local data = comp:OnSave()
        local comp2 = RagebaitController(inst)
        comp2:OnLoad(data)
        assert(comp2:HasCraftedManual("ragebait_manual_hound"), "Saved manuals should be loaded")
    end

    print("All RagebaitController tests passed")
end

return { run = run_tests }