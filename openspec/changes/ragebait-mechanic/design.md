## Context

The mod adds a Ragebait mechanic to Anirvan: a staff-based ability that taunts a single enemy (or multiple at higher tiers) to exclusively target the player. The ability is gated per-creature by requiring the player to craft a manual for that creature first. Manuals are crafted using vanilla-style recipes (enemy drop + paper + charcoal) and tier progression unlocks new staff capabilities as the player collects distinct manuals.

The implementation builds entirely on vanilla DST data and patterns (recipes, items, buffs, AI overrides, prefabs) to minimize custom asset production and use placeholder art/anim/fx from the vanilla game.

## Goals / Non-Goals

**Goals:**
- Define the modular structure for staff prefab, manual prefabs, and ragebait activation
- Establish the creature-to-manual mapping system using vanilla data
- Specify how recipes integrate with DST's cookbook/tech system
- Clarify tier unlock logic tied to the distinct-manuals count
- Design placeholder asset references and fallback behaviors
- Ensure all four new/modified specs can be implemented independently from the design

**Non-Goals:**
- Create custom art, animations, FX, or sounds
- Design the Bestiary UI in detail (deferred to ui-bestiary spec)
- Implement balance tuning constants in this document (live tuning via config)
- Handle save-game migration or backward compatibility
- Design multiplayer-specific edge cases (assume DST standard behavior)

## Decisions

### 1. Creature-to-Manual Mapping System

**Decision**: Use a centralized Lua table that maps each enemy's prefab name to a manual ID, category, tier-weight, and required drop. Source this from vanilla's `prefablist.lua` and `creatures.lua`.

**Rationale**: Avoids hardcoding and allows future expansion. Vanilla data is authoritative and reduces maintenance.

**Alternatives Considered**:
- Dynamically scan creature files at runtime (too slow; mapping table is simpler and more reliable)
- Store mapping in separate data files (increases file count; single table is cleaner for a mod)

**Implementation Approach**:
- Create `anirvan/data/ragebait_creature_map.lua` with the mapping table
- Include hostile/neutral creature types only (exclude friendly NPCs, harmless critters, and players)
- For each creature, store: `prefab_name`, `manual_id`, `friendly_name`, `required_drop_item`, `crafting_tier` (rough guide for progression balance)

### 2. Staff and Manual Item Prefabs

**Decision**: Create two prefab files—`ragebait_staff.lua` and a template for manuals (e.g., `ragebait_manual_generic.lua` using variable substitution at creation time).

**Rationale**: DST's prefab system allows us to define items with minimal overhead. Placeholder assets (vanilla icons or simple textures) keep development lightweight.

**Alternatives Considered**:
- Single prefab with parametrization (more complex inheritance; two separate prefabs is clearer)
- Dynamically create prefabs at runtime (harder to debug; static prefabs are preferred)

**Implementation Approach**:
- **ragebait_staff.lua**: Defines the staff item with equipment slot, inspectable text, and placeholder asset references (use a vanilla staff or generic icon as fallback)
- **ragebait_manual_template.lua**: Base template that accepts creature name and manual ID as parameters; inherits common behavior (inspectable tooltip, stackable, tradeable)
- In the recipe data, indicate which manual prefab to create by passing creature-specific data through the recipe system

### 3. Recipe and Crafting Integration

**Decision**: Use DST's vanilla recipe module. Each manual recipe will be defined as a table in a recipes file. Recipes require a creature-specific drop (from the mapping table), paper, and charcoal, and it is crafted without a tech table or cooking pot.

**Rationale**: Integrates seamlessly with DST's tech/cookbook system; players learn recipes naturally and can see ingredients in the cookbook UI.

**Alternatives Considered**:
- Custom crafting system (reinvents the wheel; vanilla recipes are proven)
- Hardcoded recipe strings (inflexible; data-driven recipes are better for tuning)

**Implementation Approach**:
- Create `anirvan/scripts/recipes_ragebait_manuals.lua` with recipe tables for all creatures
- Each recipe:
  - Name: `ragebait_manual_<creature_id>`
  - Ingredients: `required_drop_item` (1), `papyrus` (1), `charcoal` (1)
  - Output: manual prefab of the appropriate type
  - Tech requirement: just the ingredients
- Register recipes in `modmain.lua` during initialization

### 4. Ragebait Activation as a Buff/Ability

**Decision**: Implement ragebait activation using DST's built-in buff/debuff system for state tracking and AI override (taunt FX). Store activation state on the player and target entities.

**Rationale**: DST already has buffs, AI taunt mechanics, and damage-multiplier systems; leveraging these reduces custom code.

**Alternatives Considered**:
- Custom state machine (more control but more code; buffs handle most cases)
- Simple component with event listeners (works but buffs provide UI/sync benefits in multiplayer)

**Implementation Approach**:
- Create a buff component (`ragebait_buff.lua`) that:
  - Tracks active state (active, cooldown, stealth)
  - Applies damage multipliers and movement speed to the player
  - Applies a "taunted" status to the target enemy
  - Listens for interruption conditions (player hit, target death, staff swaped)
  - On interrupt, triggers cooldown and (if Tier ≥ 3) stealth mode
- Staff's `OnUse` method checks preconditions (manual crafted, staff off cooldown, target in range), applies the buff, and handles state transitions

### 5. Tier Unlock System

**Decision**: Store a "distinct_manuals_crafted" set on the player character (persisted in save data). On each manual craft, check if it's new and increment the set; then check the count against the tier thresholds.

**Rationale**: Simple, reliable, and avoids remote tally or shared state issues. Per-player tracking naturally supports co-op without requiring consensus.

**Alternatives Considered**:
- Track crafted count on the staff item itself (doesn't generalize; staff can be lost/dropped)
- Scan player inventory for manuals each time (inefficient and error-prone if items are dropped elsewhere)

**Implementation Approach**:
- Add a `.lua` component to the character that maintains:
  - `crafted_manuals` (set of creature IDs the player has crafted for)
  - `current_tier` (calculated from crafted_manuals size against thresholds: 1/4/10/20/45)
- On recipe completion, update the set and broadcast tier change
- Tier upgrades unlock new abilities on the staff (multi-target, enhanced cooldown, stealth trigger)

### 6. Placeholder Assets and Asset References

**Decision**: Use vanilla DST textures, animations, and FX as placeholders. Store asset paths as string references in the item/prefab definitions so they can be easily swapped later.

**Rationale**: Allows functional testing and gameplay validation without waiting for art production. References are searchable and easy to replace.

**Alternatives Considered**:
- Simple colored squares (too minimal; vanilla assets are more usable for testing)
- Custom placeholder art (delays testing; vanilla assets are sufficient)

**Implementation Approach**:
- Staff texture: use `images/inventoryimages/staff.tex` or similar vanilla staff
- Staff animation: reference `anim/player_actions.zip` or a simple idle animation
- Manual texture: use `images/inventoryimages/book.tex` or similar vanilla book
- All asset strings are stored in a central `anirvan/data/ragebait_assets.lua` config file for easy swapping

### 7. Cooldown and State UI

**Decision**: Use a simple HUD overlay (similar to vanilla ability cooldowns) that shows cooldown timer and stealth duration. Integrate with the player's buff/debuff display.

**Rationale**: Minimal UI code; leverages existing DST display patterns. Players expect ability cooldowns to show in the HUD.

**Alternatives Considered**:
- Custom screen widget (more flexible but much more code)
- Text-only console messages (poor UX; visual feedback is important for one-hit cancel mechanic)

**Implementation Approach**:
- Create a custom HUD widget in `anirvan/scripts/widgets/ragebait_hud.lua` that:
  - Listens to buff/cooldown events from the player's ragebait buff component
  - Displays a cooldown ring/bar with numeric seconds
  - Shows stealth duration when active
  - Updates in real-time

## Risks / Trade-offs

**Risk**: Vanilla creature data changes in future DST updates may break manual mapping.
- *Mitigation*: Version-lock the creature list in data; if new creatures are added, add them to the mapping table. The system is designed to be additive.

**Risk**: Performance if the creature-to-manual mapping table is very large (100+ creatures).
- *Mitigation*: The table is a lookup; performance impact is negligible. Pre-filter the list to hostile/neutral only to keep it manageable.

**Risk**: Buff system overhead for real-time state updates (if many players are ragebait-active simultaneously).
- *Mitigation*: DST's buff system is already used extensively; this is not a new concern. Test with multiple concurrent activations if needed.

**Risk**: Placeholder assets may feel incomplete during testing and discourage playtesting feedback.
- *Mitigation*: Clearly communicate that assets are placeholders. Focus playtesting feedback on mechanics, not visuals.

**Risk**: Tier unlock thresholds (1/4/10/20/45) may not match the final creature roster size.
- *Mitigation*: Thresholds are stored as constants in `ragebait_creature_map.lua` and can be adjusted live based on playtesting. Document the intended progression curve. Currently tuned for 62-creature roster.

## Open Questions

1. **Stealth Mode specifics** (Tier 3 unlock): The spec mentions Stealth Mode is triggered on interrupt but doesn't define its behavior. Should it be a short invisible buff, a brief movement-speed boost, or something else? *Resolution: Defer to design refinement after Tier 1 playtesting.*

2. **Multi-target per-creature limit** (Tier 4 unlock): Can the player ragebait the same enemy twice to keep them taunted? Or can only one instance per enemy type be active? *Resolution: Spec says "one or more enemies"; assume multiple distinct enemies can be taunted simultaneously if the player's tier allows.*

3. **Ally buff implementation** (Tier 2 unlock): The Tier 2 spec mentions teammates gain a buff. Should this be automatic (all nearby allies) or restricted (line-of-sight, max range)? *Resolution: Defer to ui-bestiary spec; propose simple AoE buff for now.*

4. **Save game compatibility**: If the player has a ragebait staff and crafted manuals from a prior version, how should old save data be migrated? *Resolution: Assume clean save for initial release; document upgrade path for future updates.*
