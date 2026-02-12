-- Ragebait Manual Recipes
-- Auto-generates recipe entries for all manuals in the creature map
-- Each manual requires: papyrus (1x), charcoal (1x), creature-specific drop (1x)

local CREATURE_MAP = require("data/ragebait_creature_map")

-- Recipe templates for ragebait manuals
local function GenerateManualRecipes(Ingredient, TECH)
	local recipes = {}
	
	-- Get all creature prefab names
	local creature_list = CREATURE_MAP.GetAllCreatures()
	
	for _, creature_prefab in ipairs(creature_list) do
		local creature_data = CREATURE_MAP.GetCreatureMapping(creature_prefab)
		
		if creature_data then
			local manual_id = creature_data.manual_id
			local required_drop = creature_data.required_drop
			local friendly_name = creature_data.friendly_name
			
			-- Each manual requires: 1 papyrus, 1 charcoal, 1 creature-specific drop
			local ingredients = {
				Ingredient("papyrus", 1),
				Ingredient("charcoal", 1),
				Ingredient(required_drop, 1),
			}
			
			-- Recipe config: craftable at Science Machine (SCIENCE_ONE)
			-- Character-specific (only Anirvan can craft)
			local recipe_config = {
				description = "Manual for " .. friendly_name,
				-- TODO: Add custom atlas/image when assets are ready
				-- atlas = "images/inventoryimages/ragebait_manual_atlas.xml",
				-- image = "ragebait_manual_base.tex",
				builder_tag = "anirvan", -- Only Anirvan can craft ragebait manuals
			}
			
			table.insert(recipes, {
				name = manual_id,
				ingredients = ingredients,
				tech = TECH.SCIENCE_ONE, -- Requires Science Machine
				config = recipe_config,
			})
		end
	end
	
	return recipes
end

-- Register all ragebait manual recipes with DST's recipe system
-- env contains Ingredient, TECH, AddRecipe2 from modmain.lua
local function RegisterRagebaitManualRecipes(env)
	local Ingredient = env.Ingredient
	local TECH = env.TECH
	local AddRecipe2 = env.AddRecipe2
	local recipes = GenerateManualRecipes(Ingredient, TECH)
	
	for _, recipe_data in ipairs(recipes) do
		AddRecipe2(
			recipe_data.name,
			recipe_data.ingredients,
			recipe_data.tech,
			recipe_data.config,
			{"CHARACTER"} -- Add to CHARACTER filter (character-specific recipes)
		)
	end
	
	print(string.format("[Ragebait] Registered %d manual recipes", #recipes))
end

-- Export the registration function
return {
	RegisterAll = RegisterRagebaitManualRecipes,
}
