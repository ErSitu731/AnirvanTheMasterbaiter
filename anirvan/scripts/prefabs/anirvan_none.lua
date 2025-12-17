local assets =
{
	Asset( "ANIM", "anim/anirvan.zip" ),
	Asset( "ANIM", "anim/ghost_anirvan_build.zip" ),
}

local skins =
{
	normal_skin = "anirvan",
	ghost_skin = "ghost_anirvan_build",
}

return CreatePrefabSkin("anirvan_none",
{
	base_prefab = "anirvan",
	type = "base",
	assets = assets,
	skins = skins, 
	skin_tags = {"ANIRVAN", "CHARACTER", "BASE"},
	build_name_override = "anirvan",
	rarity = "Character",
})