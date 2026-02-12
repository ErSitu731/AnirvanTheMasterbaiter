local assets = {
    Asset("ANIM", "anim/ragebait_stealth_fx.zip"),
}

local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()

    inst.AnimState:SetBank("ragebait_stealth_fx")
    inst.AnimState:SetBuild("ragebait_stealth_fx")
    inst.AnimState:PlayAnimation("idle", true)
    inst.persists = false
    inst:AddTag("FX")

    return inst
end

return Prefab("ragebait_stealth_fx", fn, assets)