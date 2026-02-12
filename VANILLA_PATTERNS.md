# Vanilla Game Code Patterns Reference

## 1. Edible Component Implementation & oneat_fn Callback Pattern

### Edible Component Structure
Located in: [data_vanilla/databundles/scripts/components/edible.lua](data_vanilla/databundles/scripts/components/edible.lua)

The Edible component tracks food properties and handles eating mechanics:

```lua
local Edible = Class(function(self, inst)
    self.inst = inst
    self.healthvalue = 10
    self.hungervalue = 10
    self.sanityvalue = 0
    self.foodtype = FOODTYPE.GENERIC
    self.secondaryfoodtype = nil
    self.oneaten = nil  -- Callback function storage
    self.degrades_with_spoilage = true
    self.gethealthfn = nil
    self.getsanityfn = nil
    self.temperaturedelta = 0
    self.temperatureduration = 0
    self.chill = 0
    self.spice = nil
end)
```

### Setting the oneat_fn Callback
There are TWO ways to set the eat callback:

**Method 1: Using SetOnEatenFn() (Recommended - Vanilla Standard)**
```lua
function Edible:SetOnEatenFn(fn)
    self.oneaten = fn
end
```

Usage in prefabs:
```lua
inst:AddComponent("edible")
inst.components.edible:SetOnEatenFn(OnEaten)
inst.components.edible.healthvalue = TUNING.HEALING_TINY
inst.components.edible.hungervalue = 0
inst.components.edible.sanityvalue = 0
```

**Method 2: Direct Assignment (Alternative)**
```lua
inst.components.edible.oneat_fn = OnEaten
```

### Callback Function Pattern
The callback receives two parameters: the item being eaten and the eater:

```lua
local function OnEaten(inst, eater)
    if eater and eater.components and eater.components.ragebait_controller then
        eater.components.ragebait_controller:CraftManual("ragebait_manual_spider")
        if eater.components.talker then
            eater.components.talker:Say("I have learned to rouse the spider's anger!")
        end
    end
end

inst.components.edible:SetOnEatenFn(OnEaten)
```

### OnEaten Execution Flow
The edible component calls the callback in its `OnEaten()` method:

```lua
function Edible:OnEaten(eater)
    if self.oneaten ~= nil then
        self.oneaten(self.inst, eater)  -- Calls the callback
    end
    
    -- Then handles temperature, sounds, and emits "oneaten" event
    local delta_multiplier = 1
    local duration_multiplier = 1
    
    if self.temperaturedelta ~= 0 and self.temperatureduration ~= 0 and self.chill < 1 and
        eater ~= nil and eater.components.temperature ~= nil then
        eater.components.temperature:SetTemperatureInBelly(...)
    end
    
    self.inst:PushEvent("oneaten", { eater = eater })
end
```

### Examples Using SetOnEatenFn
- [firenettles.lua](data_vanilla/databundles/scripts/prefabs/firenettles.lua) - fire damage debuff
- [moon_mushroom.lua](data_vanilla/databundles/scripts/prefabs/moon_mushroom.lua) - grogginess reset
- [ancienttree_fruits.lua](data_vanilla/databundles/scripts/prefabs/ancienttree_fruits.lua) - night vision effect
- [hermitcrabtea.lua](data_vanilla/databundles/scripts/prefabs/hermitcrabtea.lua) - buff application
- [preparedfoods.lua](data_vanilla/databundles/scripts/prefabs/preparedfoods.lua) - generic food with custom effects

---

## 2. Display Name for Items in Inventory

### Approach 1: Using displaynamefn
In [preparedfoods.lua](data_vanilla/databundles/scripts/prefabs/preparedfoods.lua):

```lua
local function DisplayNameFn(inst)
    return subfmt(STRINGS.NAMES[data.spice.."_FOOD"], { 
        food = STRINGS.NAMES[string.upper(data.basename)] 
    })
end

local function fn()
    local inst = CreateEntity()
    -- ... setup code ...
    
    if data.basename ~= nil then
        inst:SetPrefabNameOverride(data.basename)
        if data.spice ~= nil then
            inst.displaynamefn = DisplayNameFn
        end
    end
    
    inst:AddComponent("inventoryitem")
    -- ... rest of setup ...
end
```

### Approach 2: Using inventoryitem:ChangeImageName()
Changes the visual representation in inventory:

```lua
inst:AddComponent("inventoryitem")
inst.components.inventoryitem:ChangeImageName("custom_name")
```

Or with spiced food:
```lua
if spicename ~= nil then
    inst.components.inventoryitem:ChangeImageName(spicename.."_over")
elseif data.basename ~= nil then
    inst.components.inventoryitem:ChangeImageName(data.basename)
end
```

### Approach 3: DisplayName Component (Custom Mod Component)
Located in: [anirvan/scripts/components/displayname.lua](anirvan/scripts/components/displayname.lua)

```lua
local DisplayName = Class(function(self, inst)
    self.inst = inst
    self.name = ""
end)

function DisplayName:SetDefault(name)
    self.name = name
end

function DisplayName:GetName()
    return self.name
end

return DisplayName
```

Usage example:
```lua
inst:AddComponent("displayname")
inst.components.displayname:SetDefault("Custom Item Name")
```

---

## 3. Books and Readable Items Implementation

### Book Component
Located in: [data_vanilla/databundles/scripts/components/book.lua](data_vanilla/databundles/scripts/components/book.lua)

Books have a `book` component with callbacks:

```lua
inst:AddComponent("book")
inst.components.book:SetOnRead(def.fn)        -- Main effect when read
inst.components.book:SetOnPeruse(def.perusefn) -- Alternative effect
inst.components.book:SetReadSanity(def.read_sanity)
inst.components.book:SetPeruseSanity(def.peruse_sanity)
inst.components.book:SetFx(def.fx, def.fxmount)
```

### SimpleBook Component (Simple Readable)
Located in: [data_vanilla/databundles/scripts/components/simplebook.lua](data_vanilla/databundles/scripts/components/simplebook.lua)

For simpler readable items:

```lua
local SimpleBook = Class(function(self, inst)
    self.inst = inst
    self.inst:AddTag("simplebook")
end)

function SimpleBook:Read(doer)
    if not CanEntitySeeTarget(doer, self.inst) then
        return false
    end
    if self.onreadfn then
        self.onreadfn(self.inst, doer)
    end
end

return SimpleBook
```

### Readable Component (Custom Mod)
Located in: [anirvan/scripts/components/readable.lua](anirvan/scripts/components/readable.lua)

Simple custom readable component:

```lua
local Readable = Class(function(self, inst)
    self.inst = inst
    self.OnRead = nil
end)

function Readable:Read(reader)
    if self.OnRead then
        self.OnRead(self.inst, reader)
    end
end

return Readable
```

### Full Book Prefab Example
From [books.lua](data_vanilla/databundles/scripts/prefabs/books.lua) - Wickerbottom's books:

```lua
local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("books")
    inst.AnimState:SetBuild("books")
    inst.AnimState:PlayAnimation(def.name)
    inst.scrapbook_anim = def.name

    MakeInventoryFloatable(inst, "med", nil, 0.75)

    inst:AddTag("book")
    inst:AddTag("bookcabinet_item")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.def = def
    inst.swap_build = "swap_books"
    inst.swap_prefix = def.name

    inst:AddComponent("inspectable")
    
    -- Book component with read callback
    inst:AddComponent("book")
    inst.components.book:SetOnRead(def.fn)
    inst.components.book:SetOnPeruse(def.perusefn)
    inst.components.book:SetReadSanity(def.read_sanity)
    inst.components.book:SetPeruseSanity(def.peruse_sanity)
    inst.components.book:SetFx(def.fx, def.fxmount)

    inst:AddComponent("inventoryitem")

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(def.uses)
    inst.components.finiteuses:SetUses(def.uses)
    inst.components.finiteuses:SetOnFinished(inst.Remove)

    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.MED_FUEL

    MakeSmallBurnable(inst, TUNING.MED_BURNTIME)
    MakeSmallPropagator(inst)
    MakeHauntableLaunch(inst)

    return inst
end
```

### Book Definition Structure
Books are created from a definition table:

```lua
{
    name = "book_gardening",
    uses = TUNING.BOOK_USES_LARGE,
    read_sanity = -TUNING.SANITY_LARGE,
    peruse_sanity = -TUNING.SANITY_LARGE,
    fx_under = "plants_small",
    fn = function(inst, reader)
        -- Effect when reading
        local x, y, z = reader.Transform:GetWorldPosition()
        -- ... perform magic effect ...
        return true
    end,
    perusefn = function(inst, reader)
        -- Alternative preview effect
        if reader.peruse_gardening then
            reader.peruse_gardening(reader)
        end
        reader.components.talker:Say(GetString(reader, "ANNOUNCE_READ_BOOK","BOOK_GARDENING"))
        return true
    end,
}
```

---

## 4. Example Prefabs Using Edible Component

### Simple Food Examples

**petals.lua** - Flower petals (basic edible):
```lua
local edible = inst:AddComponent("edible")
edible.healthvalue = TUNING.HEALING_TINY
edible.hungervalue = 0
edible.foodtype = FOODTYPE.VEGGIE
```

**pondfish.lua** - Fish with edible component:
```lua
inst:AddComponent("edible")
inst.components.edible.ismeat = true
inst.components.edible.healthvalue = data.healthvalue
inst.components.edible.hungervalue = data.hungervalue
inst.components.edible.sanityvalue = 0
inst.components.edible.foodtype = FOODTYPE.MEAT
```

### Complex Food Examples

**moon_mushroom.lua** - Mushroom with custom eat callback:
```lua
inst:AddComponent("edible")
inst.components.edible.healthvalue = 0
inst.components.edible.hungervalue = TUNING.CALORIES_SMALL
inst.components.edible.sanityvalue = TUNING.SANITY_SMALL
inst.components.edible.foodtype = FOODTYPE.VEGGIE
inst.components.edible:SetOnEatenFn(mooncap_oneaten)

local function mooncap_oneaten(inst, eater)
    if eater:IsValid() and eater.components.grogginess ~= nil then
        eater.components.grogginess:ResetGrogginess()
    end
end
```

**firenettles.lua** - With damage debuff on eat:
```lua
inst:AddComponent("edible")
inst.components.edible.healthvalue = -TUNING.HEALING_SMALL
inst.components.edible.hungervalue = 0
inst.components.edible.sanityvalue = -TUNING.SANITY_TINY
inst.components.edible.foodtype = FOODTYPE.VEGGIE
inst.components.edible:SetOnEatenFn(oneaten)

local function oneaten(inst, eater)
    -- Apply damage or buff on eating
end
```

**hermitcrabtea.lua** - Tea with multiple edible callbacks:
```lua
inst:AddComponent("edible")
inst.components.edible:SetOnEatenFn(OnEaten)
inst.components.edible:SetHandleRemoveFn(HandleEdibleRemove)
inst.components.edible:SetOverrideStackMultiplierFn(GetWholeStackEatMultiplier)
inst.components.edible.sanityvalue = sanityvalue
inst.components.edible.healthvalue = healthvalue
inst.components.edible.hungervalue = hungervalue
inst.components.edible.foodtype = foodtype
inst.components.edible.temperaturedelta = temperaturedelta
inst.components.edible.temperatureduration = temperatureduration
```

### Prepared Foods

**preparedfoods.lua** - Generic cooked food factory:
```lua
inst:AddComponent("edible")
inst.components.edible.healthvalue = data.health
inst.components.edible.hungervalue = data.hunger
inst.components.edible.foodtype = data.foodtype or FOODTYPE.GENERIC
inst.components.edible.secondaryfoodtype = data.secondaryfoodtype or nil
inst.components.edible.sanityvalue = data.sanity or 0
inst.components.edible.temperaturedelta = data.temperature or 0
inst.components.edible.temperatureduration = data.temperatureduration or 0
inst.components.edible.nochill = data.nochill or nil
inst.components.edible.spice = data.spice
inst.components.edible:SetOnEatenFn(data.oneatenfn)
```

### Ragebait Manuals (Custom Mod Example)

From the workspace, ragebait manuals use edible + custom callback:

```lua
inst:AddComponent("edible")
inst.components.edible.healthvalue = 0
inst.components.edible.hungervalue = 0
inst.components.edible.sanityvalue = 0

local function OnEaten(inst, eater)
    if eater and eater.components and eater.components.ragebait_controller then
        eater.components.ragebait_controller:CraftManual("ragebait_manual_spider")
        if eater.components.talker then
            eater.components.talker:Say("I have learned to rouse the spider's anger!")
        end
    end
end

inst.components.edible:SetOnEatenFn(OnEaten)
```

---

## Summary

### Key Patterns:

1. **Edible Component**: Always added with `inst:AddComponent("edible")`, then properties are set directly on the component
2. **Eat Callbacks**: Use `SetOnEatenFn()` method to register a function that fires when eaten
3. **Display Names**: Either use `displaynamefn` property on the entity or `inventoryitem:ChangeImageName()` for visual changes
4. **Books**: Use `book` component with `SetOnRead()` and `SetOnPeruse()` callbacks, wrapped in `finiteuses` for durability
5. **Simple Readables**: Use `simplebook` component for simpler readable items without the full book system
6. **Custom Components**: Can create custom components like `readable` or `displayname` for specialized behavior

