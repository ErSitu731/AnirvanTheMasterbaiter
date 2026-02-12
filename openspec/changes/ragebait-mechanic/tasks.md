## 1. Data & Configuration Setup

- [x] 1.1 Create `anirvan/data/ragebait_creature_map.lua` with mapping of all hostile/neutral creatures to manual IDs, friendly names, required drops, and tier-weights
- [x] 1.2 Create `anirvan/data/ragebait_assets.lua` with placeholder asset path references (staff texture, manual texture, animations)
- [x] 1.3 Create `anirvan/data/ragebait_constants.lua` with tunable values (base range, tier thresholds, cooldown times, damage/movement multipliers)
- [x] 1.4 Document placeholder asset locations and add TODO comments for art team (which assets need replacement)

## 2. Item Prefabs (Staff & Manuals)

- [x] 2.1 Create `anirvan/scripts/prefabs/ragebait_staff.lua` with staff item definition (equipment slot, inspectable text, placeholder asset references)
- [x] 2.2 Create `anirvan/scripts/prefabs/ragebait_manual_base.lua` as a template for manual items with creature-specific variant generation
- [x] 2.3 Add staff and manual prefabs to `modmain.lua` registration
- [x] 2.4 Test that staff and manuals appear in inventory and are equippable/holdable

## 3. Recipe System Setup

- [x] 3.1 Create `anirvan/scripts/recipes_ragebait_manuals.lua` with recipe table entries for each creature in the creature map (name, ingredients, output)
- [x] 3.2 Register all manual recipes in `modmain.lua` with DST's recipe system
- [x] 3.3 Ensure recipes are discoverable/learnable and appear in the cookbook UI
- [ ] 3.4 Test that manual recipes can be crafted when ingredients are available

## 4. Creature Tracking & Crafting Callback

- [x] 4.1 Create `anirvan/scripts/components/ragebait_progress.lua` component to store player's crafted manuals set and current tier on the character
- [x] 4.2 Add callback system to detect when a ragebait manual recipe is completed (hook into recipe completion)
- [x] 4.3 Update `crafted_manuals` set when a manual is crafted and recalculate current tier
- [ ] 4.4 Test that crafting a manual correctly updates the crafted set and tier (no duplicates on re-craft)

## 5. Tier Progression & Ability Unlocks

- [x] 5.1 Implement tier threshold checking in `ragebait_progress.lua` (1/4/10/20/45 manual counts)
- [x] 5.2 Create tier unlock callbacks to notify the staff and buff system when a new tier is reached
- [x] 5.3 Store tier-dependent ability parameters (cooldown times, multi-target limit, stealth trigger) on the character
- [ ] 5.4 Test that tiers unlock automatically and grant correct parameters

## 6. Staff Activation Logic

- [x] 6.1 Create `anirvan/scripts/components/ragebait_activator.lua` component to handle staff use preconditions (manual crafted, on cooldown, in range, staff equipped)
- [x] 6.2 Implement manual gating check: verify player has crafted the target creature's manual
- [x] 6.3 Implement sanity-scaled range logic (1x/2x/4x based on sanity thresholds)
- [x] 6.4 Implement staff OnUse callback to initiate ragebait activation when preconditions pass
- [ ] 6.5 Test activation with and without manual, at different sanity levels, with enemies at various ranges

## 7. Ragebait Buff & State Management

- [x] 7.1 Create `anirvan/scripts/components/ragebait_buff.lua` buff component to manage active ragebait state
- [x] 7.2 Implement buff effects: apply damage multiplier (2x) and movement speed bonus (+30%) to player
- [x] 7.3 Implement taunted status on target enemy (override AI to target only the player)
- [x] 7.4 Implement damage reduction (-50%) on player's outgoing damage while ragebait is active
- [x] 7.5 Implement interruption detection: listen for player hit, target death, staff swap, manual cancel
- [x] 7.6 Implement one-hit-cancel mechanic: on any hit to player, immediately end ragebait and start cooldown
- [ ] 7.7 Test buff application, damage multipliers, AI taunt behavior, and interruption conditions

## 8. Cooldown System

- [x] 8.1 Create `anirvan/scripts/components/ragebait_cooldown.lua` component to manage post-activation cooldown
- [x] 8.2 Implement tier-dependent cooldown durations (Tier 1=60s, Tier 2=55s, Tier 3=45s, Tier 4=30s, Tier 5=20s)
- [x] 8.3 Implement cooldown countdown and state tracking (active, on cooldown, ready)
- [x] 8.4 Add callback to prevent staff activation when on cooldown
- [ ] 8.5 Test cooldown timing and prevention of activation mid-cooldown

## 9. Stealth Mode (Tier 3 Unlock)

- [x] 9.1 Create `anirvan/scripts/components/ragebait_stealth.lua` component for Tier 3+ stealth mode (stub implementation)
- [ ] 9.2 Implement stealth trigger on interrupt (when Tier >= 3): brief invisibility or movement speed boost
- [ ] 9.3 Define stealth duration (placeholder: 2 seconds) and visual/FX references
- [ ] 9.4 Test stealth triggering on hit interruption and manual cancel

## 10. Ally Buff System (Tier 2 Unlock)

- [x] 10.1 Create `anirvan/scripts/components/ragebait_ally_buff.lua` component for Tier 2+ ally assistance (stub implementation)
- [ ] 10.2 Implement automatic buff application to nearby allies when ragebait is active (when Tier >= 2)
- [ ] 10.3 Define buff type: damage bonus or healing (placeholder decision)
- [ ] 10.4 Implement buff range and cleanup on ragebait end
- [ ] 10.5 Test ally buff application and removal

## 11. Multi-Target Ragebait (Tier 4 Unlock)

- [x] 11.1 Create `anirvan/scripts/components/ragebait_multitarget.lua` component for Tier 4+ features (stub implementation)
- [ ] 11.2 Implement multi-target activation: allow ragebait on up to N enemies (Tier 4+ only)
- [ ] 11.3 Ensure each taunted target exclusively targets the player and does not retarget
- [ ] 11.4 Test multi-target activation and AI behavior for multiple concurrent ragebait targets

## 12. HUD & UI for Ragebait State

- [ ] 12.1 Create `anirvan/scripts/widgets/ragebait_hud.lua` widget to display ragebait status on HUD
- [ ] 12.2 Implement cooldown display: timer ring/bar and numeric seconds countdown
- [ ] 12.3 Implement active ragebait indicator when ragebait is running (e.g., "RAGEBAIT ACTIVE")
- [ ] 12.4 Implement stealth duration indicator (when Tier >= 3 and stealth is active)
- [ ] 12.5 Add HUD widget to player's display screen and integrate with buff event system
- [ ] 12.6 Test HUD visibility, updates, and accurate timer display

## 13. Bestiary / Manuals Tracker UI

- [ ] 13.1 Create `anirvan/scripts/screens/ragebait_bestiary_screen.lua` for Bestiary/manual tracker
- [ ] 13.2 Implement bestiary grid/list showing all creatures with crafted/uncrafted state
- [ ] 13.3 Implement progress display: "X distinct manuals crafted / Y total"
- [ ] 13.4 Implement tier progress bar and current tier indicator
- [ ] 13.5 Implement recipe quick-link for uncrafted manuals (show required ingredients)
- [ ] 13.6 Add keybind or screen activation from main menu (e.g., character menu)
- [ ] 13.7 Test bestiary updates on manual craft, filter/sort options

## 14. Bestiary World Indicators

- [ ] 14.1 Implement visual indicator on ragebaited enemies (taunt icon or aura above enemy)
- [ ] 14.2 Implement visual indicator on allies with active ally buff (buff icon)
- [ ] 14.3 Add world rendering integration to show indicators to all players
- [ ] 14.4 Test indicator visibility and persistence during ragebait

## 15. modmain.lua Integration

- [x] 15.1 Register all item prefabs (staff, manuals) in `modmain.lua`
- [x] 15.2 Register all recipes in `modmain.lua`
- [x] 15.3 Register all components (progress, activator, buff, cooldown, stealth, ally buff, multitarget) with the forge system
- [x] 15.4 Add initialization hooks for character setup (add ragebait_progress component on spawn)
- [x] 15.5 Add mod configuration options (tunable constants: range, cooldowns, damage multipliers, tier thresholds)

## 16. Edge Cases & Error Handling

- [x] 16.1 Handle boss/special creatures immune to taunt: graceful failure and cooldown bypass
- [x] 16.2 Handle staff swap during active ragebait: cancel ragebait and start cooldown
- [x] 16.3 Handle target death during active ragebait: end ragebait and start cooldown
- [x] 16.4 Handle player disconnects with active ragebait: clean up buff and state
- [ ] 16.5 Test edge cases in multiplayer scenarios

## 17. Testing & Validation

- [ ] 17.1 Create a list of placeholder assets still needed (document for art team: which textures/anims to replace)
- [ ] 17.2 Verify all manual recipes exist and are craftable
- [ ] 17.3 Verify tier progression works correctly as distinct manuals are crafted
- [ ] 17.4 Verify ragebait activation and interruption mechanics work as specified
- [ ] 17.5 Verify cooldown system prevents double-activation and tracks time correctly
- [ ] 17.6 Verify all tier-dependent features (stealth, ally buff, multi-target) unlock at correct thresholds
- [ ] 17.7 Verify HUD displays accurately and updates in real-time
- [ ] 17.8 Verify Bestiary UI shows correct progress and creature states
- [ ] 17.9 Test in multiplayer: verify per-player tier tracking and buff visibility
- [ ] 17.10 Test in gameplay: ensure mechanics do not break with existing mod features or vanilla interactions

## 18. Documentation & Polish

- [x] 18.1 Document creature mapping table format and how to add new creatures
- [x] 18.2 Document asset placeholder locations and list which assets need replacement
- [x] 18.3 Create a "Ragebait Mechanic Summary" comment block in main files explaining the system flow
- [x] 18.4 Add inline comments for complex logic (AI override, buff lifecycle, tier calculation)
- [x] 18.5 Document tunable constants and recommended balance ranges for playtesting
