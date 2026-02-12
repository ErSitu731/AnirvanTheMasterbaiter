# Issue 05 — Implement Tier 2 Ally Buffs

Summary
-------
Implement the ally buff system that applies during active Ragebait when the player's tier is ≥ 2. Buffs include damage increase and damage reduction for nearby allies.

Tasks
-----
- [x] Add buff application to nearby allies while Ragebait is active. (+15% damage multiplicative)
- [ ] Decide and implement damage reduction (-10% damage taken) as tunable (deferred).
- [x] Add buff FX on allies when buff is active (placeholder FX prefab used).
- [x] Ensure buffs are removed immediately when Ragebait ends or allies exit radius.

Acceptance criteria
-------------------
- Allies within radius receive the damage buff and visuals while Ragebait is active.
- Buff effects stack multiplicatively with other buffs and do not cause invulnerability.

Notes:
- Implemented +15% damage buff applied multiplicatively via direct adjustment of `components.combat.damagemultiplier`. Damage reduction was deferred for safer implementation.

Estimate: 2–3 days
Labels: gameplay, medium
