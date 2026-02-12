-- Ragebait Staff Prefab
-- A staff item that allows Anirvan to activate the Ragebait mechanic
-- Equippable in the tool slot, requires manuals to activate per-creature

local assets =
{
	Asset("ANIM", "anim/staffs.zip"),  -- Use vanilla staff animations
	Asset("ANIM", "anim/swap_staffs.zip"),
}

local function OnEquip(inst, owner)
	owner.AnimState:OverrideSymbol("swap_object", "swap_staffs", "swap_orangestaff")
	owner.AnimState:Show("ARM_carry")
	owner.AnimState:Hide("ARM_normal")
	owner:AddTag("ragebait_equipped")
end

local function OnUnequip(inst, owner)
	owner.AnimState:Hide("ARM_carry")
	owner.AnimState:Show("ARM_normal")
	owner:RemoveTag("ragebait_equipped")
	
	-- Cancel active ragebait if staff is unequipped while active
	if owner.components.ragebait_buff and owner.components.ragebait_buff:IsActive() then
		owner.components.ragebait_buff:DeactivateRagebait("STAFF_UNEQUIPPED")
	end
end

local function OnAttack(inst, attacker, target)
	print("[Ragebait Staff] OnAttack triggered!")
	-- Weapon component attack triggers ragebait activation
	if not attacker or not attacker:IsValid() then 
		print("[Ragebait Staff] Attacker invalid")
		return 
	end
	if not target or not target:IsValid() then 
		print("[Ragebait Staff] Target invalid")
		return 
	end
	
	print("[Ragebait Staff] Attacker: " .. tostring(attacker.prefab) .. ", Target: " .. tostring(target.prefab))
	
	-- Delegate to ragebait_activator component
	if attacker.components.ragebait_activator then
		print("[Ragebait Staff] Calling OnStaffAttack")
		local success, reason = attacker.components.ragebait_activator:OnStaffAttack(target)
		print("[Ragebait Staff] OnStaffAttack result: " .. tostring(success) .. ", reason: " .. tostring(reason))
	else
		print("[Ragebait Staff] ERROR: No ragebait_activator component on attacker!")
	end
end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)

	inst.AnimState:SetBank("staffs")
	inst.AnimState:SetBuild("staffs")
	inst.AnimState:PlayAnimation("orangestaff")

	inst:AddTag("ragebait_staff")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("inspectable")
	inst.components.inspectable:SetDescription(
		"A legendary staff that channels the Ragebait mechanic.\n" ..
		"Requires crafted manuals to activate against specific creatures.\n" ..
		"Forces a single enemy (or more at higher tiers) to attack exclusively you.\n" ..
		"WARNING: Taking any hit while active ends the effect and starts cooldown!"
	)

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.imagename = "orangestaff"
	inst.components.inventoryitem.atlasname = "images/inventoryimages.xml"

	inst:AddComponent("equippable")
	inst.components.equippable:SetOnEquip(OnEquip)
	inst.components.equippable:SetOnUnequip(OnUnequip)
	inst.components.equippable.equipslot = EQUIPSLOTS.HANDS

	-- Weapon component to handle staff attacks
	inst:AddComponent("weapon")
	inst.components.weapon:SetDamage(0)  -- Staff does not deal damage directly
	inst.components.weapon:SetOnAttack(OnAttack)

	-- Staff is indestructible (no finiteuses component)

	MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
	MakeSmallPropagator(inst)

	return inst
end

return Prefab("ragebait_staff", fn, assets)