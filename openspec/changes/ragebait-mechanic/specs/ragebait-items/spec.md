# Spec: Ragebait Items (Staff & Manuals)

Capability overview
-------------------
Define the Ragebait Staff item and Ragebait Manual items (one per creature type), including prefab structure, data mapping from vanilla creatures, placeholder assets, and integration with DST's item/recipe systems.

Motivation
----------
The staff is the player's primary activation tool for Ragebait, and manuals gate per-creature activation while serving as progression markers. Defining their item types, data structures, and asset references ensures consistent implementation and enables placeholder-based testing before art production.

## ADDED Requirements

### Requirement: Ragebait Staff prefab definition
The system SHALL define a Ragebait Staff item with equipment slot, inspectable text, and configurable asset references. The staff SHALL have a tool/weapon-type classification and be equippable by the character.

#### Scenario: Staff is equippable
- **WHEN** the player picks up the staff
- **THEN** the staff appears in inventory and can be equipped to the tool slot

#### Scenario: Staff displays flavor text
- **WHEN** the player inspects the staff
- **THEN** the item displays a description explaining it taunts enemies and requires manuals to activate

#### Scenario: Staff uses placeholder assets
- **WHEN** the game loads the staff item
- **THEN** asset paths reference vanilla DST textures (e.g., staff icons or generic weapon art)

### Requirement: Manual item prefabs (generic template)
The system SHALL define a Ragebait Manual item template with creature-specific variants. Each manual SHALL be named `ragebait_manual_<creature_id>` and be consumable (disappear on use).

#### Scenario: Manual is not consumed
- **WHEN** a player uses/holds a manual
- **THEN** the manual item doesnt remains in inventory

#### Scenario: Manual displays creature-specific metadata
- **WHEN** a player inspects a manual
- **THEN** the tooltip shows the creature name/enemy type, crafting recipe, and whether the player has crafted it

#### Scenario: Multiple manual types exist
- **WHEN** the game enumerates hostile/neutral creatures
- **THEN** a corresponding manual item type exists for each creature (e.g., `ragebait_manual_spider`, `ragebait_manual_hound`)

### Requirement: Creature-to-manual mapping system
The system SHALL maintain a centralized data table mapping vanilla hostile/neutral creature prefab names to manual IDs, friendly names, required ingredient drops, and optional tier-weights.

#### Scenario: Mapping covers hostile creatures
- **WHEN** the system initializes the creature map
- **THEN** the map includes all hostile creature types (hounds, spiders, tentacles, bosses, etc.)

#### Scenario: Mapping covers neutral creatures
- **WHEN** the system initializes the creature map
- **THEN** the map includes all neutral/aggressive creatures (pigs with aggro, lureplants, etc.)

#### Scenario: Mapping excludes friendly entities
- **WHEN** checking creature map
- **THEN** friendly NPCs, harmless critters, and players are not included

#### Scenario: Each creature has required drop
- **WHEN** a creature is in the map
- **THEN** it specifies a required ingredient drop item (e.g., `spider_gland` for spiders, `houndstooth` for hounds)

### Requirement: Placeholder asset references
The system SHALL store item and animation asset paths as configurable string references derived from vanilla textures, allowing easy swapping without code changes.

#### Scenario: Staff uses vanilla texture fallback
- **WHEN** the staff prefab is created, the system requires a texture file
- **THEN** the default texture is sourced from vanilla DST art (e.g., existing staff or weapon icons)

#### Scenario: Manuals use vanilla book texture fallback
- **WHEN** a manual prefab is created
- **THEN** the default texture is a vanilla book icon (e.g., from `papyrus` or existing book items)

#### Scenario: Assets are centralized in config
- **WHEN** the mod loads
- **THEN** all asset paths are defined in a single config file (e.g., `ragebait_assets.lua`), allowing batch replacement

### Requirement: Staff and manual items integrate with recipes
The system SHALL allow staff and manual items to be created via the cookbook/recipe system and crafted with standard DST recipe mechanics.

#### Scenario: Staff recipe exists
- **WHEN** the player opens the cookbook
- **THEN** a Ragebait Staff recipe is visible and craftable if the player has learned the tech

#### Scenario: Manual recipes list ingredients
- **WHEN** a manual recipe is viewed
- **THEN** it lists required ingredients: creature-specific drop (1x), papyrus (1x), charcoal (1x)

#### Scenario: Crafting produces correct item type
- **WHEN** the player completes a manual recipe
- **THEN** the result is the corresponding `ragebait_manual_<creature_id>` item

### Requirement: Manual state tracking for tier progression
The system SHALL track which manuals each player has crafted (per-player crafted flag) to enable tier unlock calculations.

#### Scenario: First manual craft sets flag
- **WHEN** a player crafts their first manual of a given creature type
- **THEN** the player's character data records that creature as "crafted" in a persistent set

#### Scenario: Duplicate crafts do not increment unique count
- **WHEN** a player crafts a second manual of a creature type they have previously crafted
- **THEN** the crafted flag remains set but the unique manual count does not increase

#### Scenario: Crafted flag persists across sessions
- **WHEN** a player logs out and back in
- **THEN** previously crafted manuals still show as crafted in the player's manual tracking

### Requirement: Manuals are tradeable and transferable
The system SHALL allow manuals to be dropped, traded, and given to other players as regular inventory items.

#### Scenario: Manual can be dropped
- **WHEN** a player drops a manual
- **THEN** it appears as a ground item and can be picked up by any player

#### Scenario: Manual can be given to another player
- **WHEN** a player gives a manual to a teammate
- **THEN** the manual appears in the receiving player's inventory and remains persistent

#### Scenario: Receiving manual does not grant crafted flag
- **WHEN** a player receives a manual from another player (not by crafting it themselves)
- **THEN** the receiving player's crafted flag for that creature does NOT automatically set; they must craft it themselves to count toward their tier

Notes
-----
Asset references should be easy to replace; document a list of "TODO: Replace placeholder asset" comments in the prefab code for the art team. The creature mapping is derived from vanilla data; maintain updates as new creatures are added to DST.
