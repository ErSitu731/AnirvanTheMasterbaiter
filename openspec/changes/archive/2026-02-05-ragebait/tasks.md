# Ragebait — Implementation Tasks

Summary: broken down actionable tasks to implement Ragebait in the mod.

Design & Documentation
- [ ] Review and finalize numbers for damage multipliers, speed increase, ally buffs, stealth duration, and burst multiplier.
- [ ] Confirm manual recipe (monster drop + charcoal + paper) and staff base recipe.

Game Data & Items (Priority: High)
- [x] Add item prefab: `ragebait_staff` (base behavior + visuals).
- [x] Add item prefabs: `ragebait_manual_<enemy>` for common early game types (hound, pig, spider, tallbird). (hound/pig/spider/tallbird manuals implemented)
- [x] Add recipe definitions for base staff and sample manuals (hound manual recipe requires hound tooth + charcoal + paper)
- [x] Create `data/manuals.lua` table enumerating enemy types and manual metadata.

Components & Logic (Priority: High)
- [x] Implement `ragebait_controller` on player (activation, cooldowns, state machine, manual count tracking).
- [x] Implement `CraftManual(manual_id)` and persistent `crafted_manuals` storage.
- [x] Add `ApplyRagebait` and `RemoveRagebait` hooks on enemy AI to override and restore targeting behavior. (basic implementations applied)
- [ ] Add immunity/tag check for bosses and entities, and basic loop prevention for enemy-vs-enemy transitions.
- [x] Implement basic sanity-based range scaling and single-target ragebait behavior.

UI & UX (Priority: Medium)
- [ ] Add Bestiary / Manuals tracker UI skeleton showing which manuals are crafted and global count.
- [ ] Add HUD indicators for Ragebait active and cooldown.

FX & SFX (Priority: Medium)
- [ ] Add placeholder visual FX for taunt/aggro and basic sound cues for activation/cancel.
- [ ] Add placeholder buff FX for allies and stealth enter/exit FX.

Tiers & Advanced Mechanics (Priority: Low → Medium)
- [ ] Implement Tiered unlocks (1,4,10,30,70) based on distinct crafted manuals.
- [x] Implement Tier 2 Ally Buffs logic and radius checks. (+15% damage, 8 tile radius, periodic updates)

- [x] Implement Tier 3 Stealth & Burst mechanics (stealth state, burst multiplier, stealth break by attack). (default: 6s stealth, 2x burst)
- [ ] Implement Tier 4 AoE target selection with max target cap and selection heuristics.
- [ ] Implement Tier 5 Enemy-vs-Enemy target switching with loop prevention and immunities.

Balance & Playtesting (Priority: Low)
- [ ] Internal playtest: 5 runs focusing on early-, mid-, and late-game progression.
- [ ] Gather metrics: uptime, number of ragebait uses, success vs failure rate, and player perception.
- [ ] Adjust numbers and cooldowns based on feedback.

QA (Priority: Medium)
- [x] Unit tests: basic `ragebait_controller` unit/integration tests added under `tests/`.
- [ ] Edge-case tests: boss fights, multiple players, swapping staff mid-ragebait, and networked multiplayer behavior.
- [ ] Regression tests to ensure the mechanic doesn't break existing character systems.

Optional / Future (Backlog)
- [ ] Add achievements/titles for reaching high manual counts.
- [ ] Consider 'manual sharing' or co-op mechanics (whether other players can craft manuals that count for Anirvan).

Notes: Map these tasks to issues and estimate points/time per task during the implementation phase.