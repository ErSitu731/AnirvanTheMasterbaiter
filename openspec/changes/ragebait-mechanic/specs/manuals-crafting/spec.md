# Spec: Manuals & Crafting (Delta)

This spec refines the existing Manuals & Crafting capability with details specific to the ragebait-mechanic change, focusing on creature roster coverage and vanilla data sourcing.

## MODIFIED Requirements

### Requirement: Manual recipes derived from vanilla creature roster
The system SHALL create manual recipes for all hostile and neutral creature types found in vanilla Don't Starve Together, using creature-specific ingredient drops as required items.

#### Scenario: Hostile creature manuals exist
- **WHEN** the game initializes
- **THEN** manual recipes exist for all hostile creatures (hounds, spiders, tentacles, bosses, etc.)

#### Scenario: Neutral creature manuals exist
- **WHEN** the game initializes
- **THEN** manual recipes exist for neutral/aggressive creatures (pigs with aggro, lureplants, moleworms when hostile, etc.)

#### Scenario: Recipe requires creature-specific drop
- **WHEN** a player views a manual recipe
- **THEN** it specifies a creature-specific ingredient (e.g., `spider_gland` for spider manuals, `houndstooth` for hound manuals)

#### Scenario: Standard ingredients are shared
- **WHEN** a player views any manual recipe
- **THEN** it requires papyrus (1x) and charcoal (1x) in addition to the creature-specific drop

## ADDED Requirements

### Requirement: Distinct manual tracking reflects full creature roster
The system SHALL enumerate all possible creature manuals and display the player's progress as "X distinct manuals crafted / Y total available", where Y grows if new creatures are added.

#### Scenario: Total possible manuals updates
- **WHEN** new hostile creatures are added to the game (via updates or mods)
- **THEN** the total possible manual count increases and the Bestiary UI reflects the change

#### Scenario: Player progress is preserved
- **WHEN** the creature roster changes
- **THEN** previously crafted manual flags remain set and are recognized by the tier system

#### Scenario: Crafted distinct count is accurate
- **WHEN** a player has crafted manuals for 4 different creature types
- **THEN** the system correctly reports "4 distinct manuals crafted"

### Requirement: Manual recipes integrate with DST cookbook
The system SHALL use DST's native recipe and tech system to gate manual knowledge, allowing players to discover recipes through gameplay or unlock them via tech progression.

#### Scenario: Manuals require recipe tech
- **WHEN** a player does not know a manual recipe
- **THEN** the manual cannot be crafted until the recipe is learned or the tech is unlocked

#### Scenario: Recipes are discoverable
- **WHEN** a player explores and encounters creatures
- **THEN** they may discover or learn manual recipes through normal DST progression mechanics

Notes
-----
The creature roster is sourced from vanilla DST data (prefabs, creatures list). As the game expands, manual recipes can be added to the mod's recipe table without code restructuring. Manual crafting uses vanilla ingredient patterns (creature drops + basic materials like paper/charcoal) to fit the established aesthetic.
