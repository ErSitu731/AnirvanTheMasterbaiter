PrefabFiles = {
	"anirvan",
	"anirvan_none",
}

Assets = {
    Asset( "IMAGE", "images/saveslot_portraits/anirvan.tex" ),
    Asset( "ATLAS", "images/saveslot_portraits/anirvan.xml" ),

    Asset( "IMAGE", "images/selectscreen_portraits/anirvan.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/anirvan.xml" ),
	
    Asset( "IMAGE", "images/selectscreen_portraits/anirvan_silho.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/anirvan_silho.xml" ),

    Asset( "IMAGE", "bigportraits/anirvan.tex" ),
    Asset( "ATLAS", "bigportraits/anirvan.xml" ),
	
	Asset( "IMAGE", "images/map_icons/anirvan.tex" ),
	Asset( "ATLAS", "images/map_icons/anirvan.xml" ),
	
	Asset( "IMAGE", "images/avatars/avatar_anirvan.tex" ),
    Asset( "ATLAS", "images/avatars/avatar_anirvan.xml" ),
	
	Asset( "IMAGE", "images/avatars/avatar_ghost_anirvan.tex" ),
    Asset( "ATLAS", "images/avatars/avatar_ghost_anirvan.xml" ),
	
	Asset( "IMAGE", "images/avatars/self_inspect_anirvan.tex" ),
    Asset( "ATLAS", "images/avatars/self_inspect_anirvan.xml" ),
	
	Asset( "IMAGE", "images/names_anirvan.tex" ),
    Asset( "ATLAS", "images/names_anirvan.xml" ),
	
	Asset( "IMAGE", "images/names_gold_anirvan.tex" ),
    Asset( "ATLAS", "images/names_gold_anirvan.xml" ),
}

AddMinimapAtlas("images/map_icons/anirvan.xml")

local require = GLOBAL.require
local STRINGS = GLOBAL.STRINGS

-- The character select screen lines
STRINGS.CHARACTER_TITLES.anirvan = "The MasterBaiter"
STRINGS.CHARACTER_NAMES.anirvan = "Anirvan"
STRINGS.CHARACTER_DESCRIPTIONS.anirvan = "*He ragebaits\n*Jew maybe?\n*Racist"
STRINGS.CHARACTER_QUOTES.anirvan = "\"I am a dwarf and I'm digging a hole\""
STRINGS.CHARACTER_SURVIVABILITY.anirvan = "Slim"

-- Custom speech strings
STRINGS.CHARACTERS.ANIRVAN = require "speech_anirvan"

-- The character's name as appears in-game 
STRINGS.NAMES.ANIRVAN = "Anirvan"
STRINGS.SKIN_NAMES.anirvan_none = "Anirvan"

-- The skins shown in the cycle view window on the character select screen.
-- A good place to see what you can put in here is in skinutils.lua, in the function GetSkinModes
local skin_modes = {
    { 
        type = "ghost_skin",
        anim_bank = "ghost",
        idle_anim = "idle", 
        scale = 0.75, 
        offset = { 0, -25 } 
    },
}

-- Add mod character to mod character list. Also specify a gender. Possible genders are MALE, FEMALE, ROBOT, NEUTRAL, and PLURAL.
AddModCharacter("anirvan", "FEMALE", skin_modes)
