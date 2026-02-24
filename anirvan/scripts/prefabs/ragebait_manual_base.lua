-- Ragebait Manual Item Prefab Generator
-- Generates all manual prefabs for creatures in the creature map

local CREATURE_MAP = require("data/ragebait_creature_map")

local assets = {
	Asset("ANIM", "anim/ragebait_manual.zip"),
}

local prefabs = {}

local function MakeManualPrefab(creature_id, manual_id)
	local function fn()
		local inst = CreateEntity()

		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		inst.entity:AddNetwork()

		MakeInventoryPhysics(inst)

		inst.AnimState:SetBank("ragebait_manual")
		inst.AnimState:SetBuild("ragebait_manual")
		inst.AnimState:PlayAnimation("idle")

		inst:AddTag("ragebait_manual")
		inst:AddTag("book")

		inst.entity:SetPristine()

		if not TheWorld.ismastersim then
			return inst
		end

		-- Store creature ID for this manual instance
		inst.creature_id = creature_id
		inst.crafted_by_player = false
		print("[Ragebait Manual] Created manual for creature: " .. tostring(creature_id) .. " (prefab: " .. manual_id .. ")")

		inst:AddComponent("inspectable")

		inst:AddComponent("inventoryitem")
		inst.components.inventoryitem.imagename = "ragebait_manual"
		inst.components.inventoryitem.atlasname = "images/inventoryimages/ragebait_manual.xml"

		MakeHauntableLaunch(inst)

		inst.OnSave = function(inst, data)
			data.creature_id = inst.creature_id
			data.crafted_by_player = inst.crafted_by_player
		end

		inst.OnLoad = function(inst, data)
			if data then
				inst.creature_id = data.creature_id
				inst.crafted_by_player = data.crafted_by_player or false
			end
		end

		return inst
	end

	return Prefab(manual_id, fn, assets, prefabs)
end

-- Generate all manual prefabs
local generated_prefabs = {}
local creature_list = CREATURE_MAP.GetAllCreatures()

if creature_list then
	for _, creature_id in ipairs(creature_list) do
		local creature_data = CREATURE_MAP.GetCreatureMapping(creature_id)
		if creature_data and creature_data.manual_id then
			local prefab = MakeManualPrefab(creature_id, creature_data.manual_id)
			table.insert(generated_prefabs, prefab)
		end
	end
end

print("[Ragebait] Generated " .. #generated_prefabs .. " manual prefabs")

-- Return all generated prefabs
if #generated_prefabs > 0 then
	return unpack(generated_prefabs)
else
	-- Return a dummy prefab if none were generated (prevents nil return)
	print("[Ragebait] WARNING: No manual prefabs generated!")
	return Prefab("ragebait_manual_dummy", function()
		local inst = CreateEntity()
		inst.entity:AddTransform()
		inst.entity:AddNetwork()
		inst.entity:SetPristine()
		if not TheWorld.ismastersim then return inst end
		inst:Remove()
		return inst
	end, {}, {})
end
