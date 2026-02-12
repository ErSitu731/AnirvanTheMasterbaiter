# Ragebait — Design

Overview
--------
Ragebait is a held-item-based control mechanic (Ragebait Staff). To ragebait a specific enemy type, the player must first craft that enemy's Ragebait Manual (one manual per enemy/boss). The base staff is crafted normally; additional tiered abilities unlock automatically as the total number of distinct manuals the player has crafted reaches thresholds.

Key Concepts
------------
- Manual: Craftable item that unlocks Ragebait for a single enemy type. Recipe: Monster-specific drop + Charcoal + Paper (example; exact recipe can be tuned).
- Staff: Indestructible item. Must be held to use Ragebait. Swapping the staff cancels ragebait and triggers stealth + cooldown.
- Tier Unlocks: Unlocked automatically based on # of distinct manuals crafted.

Tier Progression (manual-count gating)
--------------------------------------
- Tier 1: 1 manual total — Basic Ragebait (single enemy) — Cooldown: 60s
- Tier 2: 4 manuals total — Allies receive a buff while ragebait active — Cooldown: 55s
- Tier 3: 10 manuals total — Stealth mode unlocked (activated on ragebait break; provides burst damage opportunity) — Cooldown: 45s
- Tier 4: 30 manuals total — AoE Ragebait (can affect multiple enemies in radius) — Cooldown: 30s
- Tier 5: 70 manuals total — Enemy vs Enemy: Ragebaited enemies will fight one another — Cooldown: 20s

Ragebait Behavior & State Machine
---------------------------------
- Preconditions: Player is holding the Ragebait Staff and has crafted the target enemy's manual.
- Activation: Player uses the staff on an enemy in range.
- During Ragebait:
  - Target enemy(s) exclusively target Anirvan and ignore other players (even when hit).
  - Anirvan takes 2x damage (damage multiplier), movement speed increases (suggested +30%), personal damage output reduces (suggested -50%).
  - Target range for ragebait scales with Anirvan's sanity:
    - >50% sanity: base range (1x)
    - ≤50% sanity: 2x base range
    - ≤25% sanity: 4x base range
- Interruption: Ragebait ends if it is manually canceled, the enemy dies, or Anirvan is hit (any damage). On interruption by hit, Anirvan automatically enters Stealth Mode (if Tier ≥ 3) and the cooldown starts.

Stealth Mode (Tier 3)
---------------------
- Triggered on ragebait break by hit or manual cancel (or staff swap).
- Provides a brief invisibility/untargetability window and a "burst" damage opportunity (first attack during stealth deals amplified damage).
- Parameters: stealth duration, burst multiplier and cooldowns are tunable (suggest starting values in tasks).

Ally Buffs (Tier 2)
-------------------
- While ragebait is active, allies within a radius gain buffs (examples: +15% damage, +10% damage reduction). Exact numbers to be tuned.

AoE Ragebait (Tier 4)
---------------------
- Staff can affect multiple enemies in a radius. Implementation detail: choose between "cone" or "radius" targeting. Needs careful testing vs swarms.

Enemy vs Enemy (Tier 5)
-----------------------
- Ragebaited enemies will be forced to attack any available enemy targets (including other ragebaited enemies) where viable, causing chaotic fights.
- Needs careful constraints to avoid permanent non-combat situations (e.g., two neutral passive creatures fighting forever).

Cooldowns
---------
- Tier 1: 60s
- Tier 2: 55s
- Tier 3: 45s
- Tier 4: 30s
- Tier 5: 20s

UI & Player Feedback
--------------------
- Manual: Tooltip showing which enemy it unlocks; count tracked in a "Bestiary" UI or similar.
- Ragebait active: clear visual indicator on enemy (target icon + heart/taunt FX) and status on Anirvan (vulnerable aura).
- Stealth active: visual and audio cues for entering and exiting stealth, and for the burst attack.

Edge Cases & Rules
------------------
- Manuals are distinct per enemy type and persist in inventory; they are not consumed on use.
- Crafting a manual counts once towards global manual total (distinct types only).
- Boss manuals: bosses are eligible and require a boss drop to craft.
- If Anirvan swaps away from the staff mid-ragebait, the effect ends and triggers stealth + cooldown (prevents easy escape via swapping).

Balance Notes (for tuning)
--------------------------
- Ally buff values, stealth duration, and burst multipliers should start conservative and be tuned via playtesting.
- One-hit cancel is high-risk; ensure telegraphing and reasonable cooldown so it is powerful but not oppressive.

Implementation Considerations
-----------------------------
- New items: `ragebait_staff` (base), `ragebait_manual_<enemy>` for each enemy type.
- New component: `ragebaitable` (on enemies) or implement as a universal behavior with tag checks.
- Player component: `ragebait_controller` to manage activation, current state, cooldowns, and counting crafted manuals.
- UI: bestiary / manual progress tracker, ragebait HUD indicators.
- Tests: unit tests for state transitions and combat interactions; integration tests in typical combat scenarios.

Open Questions
--------------
- Exact numbers for speed/damage multipliers and ally buffs.
- Should bosses count extra (weighted) towards manual thresholds? Current plan: all types count equally.
- Stealth specifics: duration and whether allies or enemies can detect Anirvan via AoE attacks.

Assets
------
- FX prefabs for taunt/aggro, stealth enter/exit, and ally buff.
- SFX for ragebait activation, cancel, and burst.

References
----------
- Player discussion notes and earlier design decisions (see repository TODOs and forums linked in initial notes).