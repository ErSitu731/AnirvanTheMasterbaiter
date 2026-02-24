local assets = {
	Asset("ANIM", "anim/ragebait_manual.zip"),
}

local function OnRead(inst, reader)
    if reader and reader.components and reader.components.ragebait_controller then
        reader.components.ragebait_controller:CraftManual("ragebait_manual_spider")
        if reader.components.talker then
            reader.components.talker:Say("I have learned to rouse the spider's anger!")
        end
        -- Consume the manual after reading
        if inst.components.finiteuses then
            inst.components.finiteuses:Use(1)
        end
    end
end

local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

	inst.AnimState:SetBank("ragebait_manual")
	inst.AnimState:SetBuild("ragebait_manual")
	inst.AnimState:PlayAnimation("idle")

    inst:AddTag("ragebait_manual")
    inst:AddTag("simplebook")

    if not TheWorld.ismastersim then
        return inst
    end

    inst.entity:SetPristine()

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "ragebait_manual"
	inst.components.inventoryitem.atlasname = "images/inventoryimages/ragebait_manual.xml"

    inst:AddComponent("simplebook")
    inst.components.simplebook.onreadfn = OnRead

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(1)
    inst.components.finiteuses:SetUses(1)
    inst.components.finiteuses:SetOnFinished(inst.Remove)

    return inst
end

return Prefab("ragebait_manual_spider", fn, assets)