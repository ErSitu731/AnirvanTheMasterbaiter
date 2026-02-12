local assets = {}

local function OnRead(inst, reader)
    if reader and reader.components and reader.components.ragebait_controller then
        reader.components.ragebait_controller:CraftManual("ragebait_manual_pigman")
        if reader.components.talker then
            reader.components.talker:Say("I have learned to rouse the pig's anger!")
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

    inst:AddTag("ragebait_manual")
    inst:AddTag("simplebook")

    if not TheWorld.ismastersim then
        return inst
    end

    inst.entity:SetPristine()

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "book_brimstone"
    inst.components.inventoryitem.atlasname = "images/inventoryimages.xml"

    inst:AddComponent("simplebook")
    inst.components.simplebook.onreadfn = OnRead

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(1)
    inst.components.finiteuses:SetUses(1)
    inst.components.finiteuses:SetOnFinished(inst.Remove)

    return inst
end

return Prefab("ragebait_manual_pigman", fn, assets)