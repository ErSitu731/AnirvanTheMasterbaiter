local assets = {
    Asset("ANIM", "anim/ragebait_ally_buff.zip"),
}

local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()

    inst.AnimState:SetBank("ragebait_ally_buff")
    inst.AnimState:SetBuild("ragebait_ally_buff")
    inst.AnimState:PlayAnimation("idle", true)
    inst.persists = false
    inst:AddTag("FX")

    return inst
end

return Prefab("ragebait_ally_buff_fx", fn, assets)