# Ragebait Mechanic: Balance & Tuning Guide

This guide documents all tunable constants in the Ragebait mechanic system and provides recommendations for playtesting adjustments.

## Quick Reference: Current Values

| Category | Constant | Current Value | Recommended Range |
|----------|----------|---------------|-------------------|
| **Activation** | Base Range | 15 units | 10–25 units |
| | Sanity High | 1.0x | 0.8x–1.2x |
| | Sanity Medium | 2.0x | 1.5x–2.5x |
| | Sanity Low | 4.0x | 3.0x–5.0x |
| **Vulnerability** | Damage Taken | 2.0x | 1.5x–3.0x |
| | Damage Output | -50% | -25% to -75% |
| | Move Speed | +30% | +20% to +50% |
| **Cooldown** | Tier 1 | 60s | 45–90s |
| | Tier 2 | 55s | 40–85s |
| | Tier 3 | 45s | 30–70s |
| | Tier 4 | 30s | 20–50s |
| | Tier 5 | 20s | 10–40s |
| **Stealth (T3+)** | Duration | 2.0s | 1.0–3.0s |
| **Ally Buff (T2+)** | Range | 20 units | 15–30 units |
| | Value | +25% | +15% to +50% |
| **Multi-Target (T4+)** | Max Targets | 3 enemies | 2–5 enemies |
| **Tier Thresholds** | T1 | 1 manual | — |
| | T2 | 4 manuals | — |
| | T3 | 10 manuals | — |
| | T4 | 20 manuals | — |
| | T5 | 45 manuals | — |

---

## Detailed Tuning Parameters

### 1. ACTIVATION & RANGE

**BASE_RANGE** (default: 15 units)
- The activation distance when sanity is above 50% (normal condition)
- Controls how far away you can be from a target to activate ragebait
- **Tuning Tips:**
  - Decrease to 10–12 for more tactical, close-range combat
  - Increase to 20–25 for ranged activation without risk
  - Test with high-tier enemies to ensure viable engagement range

**RANGE_SANITY_HIGH / MEDIUM / LOW** (defaults: 1.0x / 2.0x / 4.0x)
- Sanity-scaled multipliers that increase range as sanity drops
- Encourages risky behavior (low sanity = more desperate/aggressive ability)
- **Tuning Tips:**
  - Reduce multiplier progression if low-sanity activation feels too powerful
  - Increase if players avoid using ragebait at normal sanity levels
  - Consider: At 25% sanity, range becomes 15 × 4.0 = 60 units; adjust numbers accordingly

**SANITY_MEDIUM_THRESHOLD / SANITY_LOW_THRESHOLD** (defaults: 0.50 / 0.25)
- Sanity percentage thresholds for range multiplier transitions
- Determines when you get 2x and 4x range bonuses
- **Tuning Tips:**
  - Increase thresholds (e.g., 0.70 / 0.40) to make bonuses apply sooner
  - Decrease for later bonus application
  - Balance against player insanity mechanics

---

### 2. VULNERABILITY & RISK

**PLAYER_DAMAGE_MULTIPLIER** (default: 2.0x)
- Incoming damage multiplier while ragebait is active
- Makes the player more vulnerable during the buff
- **Tuning Tips:**
  - Lower to 1.5x if ragebait feels too risky (easier gameplay)
  - Increase to 2.5–3.0x if ragebait feels too safe (harder challenge)
  - Combined with one-hit-cancel, even 1.5x creates significant risk
  - Test against high-damage enemies (bosses, hound packs)

**PLAYER_DAMAGE_OUTPUT_REDUCTION** (default: 0.5 / 50%)
- Percentage reduction in outgoing damage during ragebait
- Prevents the player from using ragebait as an offensive power-up
- **Tuning Tips:**
  - Reduce to 25–30% for more offensive builds
  - Increase to 60–75% for pure taunt/defensive playstyle
  - Watch for trivializing enemy encounters with high damage characters

**PLAYER_MOVE_SPEED_BONUS** (default: 0.30 / 30%)
- Movement speed increase while ragebait is active
- Helps the player kite/evade while maintaining taunt
- **Tuning Tips:**
  - Reduce to 15–20% if movement buff is too powerful
  - Increase to 40–50% if you want more "escape pressure" gameplay
  - Note: Interacts with other speed mods (consider cumulative effects)

---

### 3. COOLDOWN SYSTEM

**COOLDOWN_TIER[1-5]** (defaults: 60s / 55s / 45s / 30s / 20s)
- Cooldown duration after ragebait ends (per tier)
- Tier progression rewards frequent play
- **Tuning Tips:**
  - Tune as a group: maintain progression curve (each tier ~15% faster)
  - For aggressive playstyle: reduce all by 20–30% globally
  - For cautious playstyle: increase all by 20–30% globally
  - Ensure Tier 5 isn't so short that cooldown is irrelevant (minimum ~15–20s)

**Recommended Progression Curves:**
```
Conservative (longer cooldowns):
  T1: 90s, T2: 75s, T3: 60s, T4: 45s, T5: 30s

Balanced (current):
  T1: 60s, T2: 55s, T3: 45s, T4: 30s, T5: 20s

Aggressive (shorter cooldowns):
  T1: 45s, T2: 40s, T3: 30s, T4: 20s, T5: 10s
```

---

### 4. TIER-SPECIFIC FEATURES

**STEALTH_DURATION** (default: 2.0 seconds, Tier 3+)
- How long the stealth effect lasts when ragebait is interrupted
- Gives the player a brief escape window
- **Tuning Tips:**
  - Reduce to 1.0–1.5s for quicker recovery of threats
  - Increase to 2.5–3.0s if you want more "escape relief"
  - Balance with danger of the triggering hit

**ALLY_BUFF_RANGE** (default: 20 units, Tier 2+)
- How far away allies must be to receive the buff when ragebait is active
- Encourages group play
- **Tuning Tips:**
  - Reduce to 10–15 for tighter group coordination
  - Increase to 25–30 for more passive support with looser formation

**ALLY_BUFF_VALUE** (default: 0.25 / 25% damage bonus, Tier 2+)
- Strength of buff applied to nearby allies
- **Tuning Tips:**
  - Reduce to 10–15% if allies feel overpowered
  - Increase to 30–50% to make ally buff more meaningful
  - Consider healing alternative if damage is too powerful

**MAX_SIMULTANEOUS_TARGETS** (default: 3 enemies, Tier 4+)
- How many enemies can be taunted at once
- **Tuning Tips:**
  - Reduce to 2 for challenging multi-enemy control
  - Increase to 4–5 if ragebait groups feel manageable
  - Remember: each target gets full damage/speed/stealth buffs

---

### 5. TIER PROGRESSION THRESHOLDS

**TIER_THRESHOLD_[1-5]** (defaults: 1 / 4 / 10 / 20 / 45 distinct manuals)
- How many different creatures' manuals must be crafted to unlock each tier
- Currently tuned for 62-creature roster
- **Tuning Tips (ADVANCED):**
  - Keep thresholds fixed for consistent progression curve
  - Each tier should represent meaningful effort increase
  - Current distribution: 1.6% / 6.5% / 16% / 32% / 73% of roster
  - If roster grows (e.g., 80 creatures), consider adjusting:
    - T1: 1 (unchanged)
    - T2: 5 (was 4)
    - T3: 15 (was 10)
    - T4: 25 (was 20)
    - T5: 60 (was 45)

---

### 6. BOSS & SPECIAL CREATURE HANDLING

**IMMUNE_TAGS** (Tags: "epic", "shadowcreature", etc.)
- Creatures with these tags cannot be taunted
- Prevents trivialization of hard encounters
- **Tuning Tips:**
  - Add tags for creatures that feel too weak when taunted
  - Remove tags for creatures that should be vulnerable
  - Consider adding "deer" (Deerclops) if overpowered when taunted

**BYPASS_COOLDOWN_ON_IMMUNE** (default: true)
- If true, cooldown does NOT start when attacking an immune creature
- Allows players to "test" if a creature is immune without penalty
- **Tuning Tips:**
  - Set to false if you want to punish incorrect targeting choices
  - Keep true for beginner-friendly difficulty

---

## Playtesting Checklist

### Week 1: Core Mechanics
- [ ] Test activation with and without manual (should fail gracefully)
- [ ] Test one-hit-cancel (should interrupt immediately)
- [ ] Test cooldown countdown (verify tier-dependent durations)
- [ ] Test staff swap during active ragebait (should cancel + start cooldown)

### Week 2: Tier Progression
- [ ] Craft 1 manual → Tier 1 should unlock
- [ ] Craft 4 distinct manuals → Tier 2 should unlock
- [ ] Verify cooldown shortens (60s → 55s, etc.)
- [ ] Test that re-crafting same manual doesn't increase tier

### Week 3: Balance Testing
- [ ] Test ragebait against early-game creatures (spider, hound)
- [ ] Test against mid-game creatures (tentacle, knight)
- [ ] Test against bosses (should fail with immune message, no cooldown)
- [ ] Verify damage multiplier makes ragebait risky (2.0x incoming feels significant)
- [ ] Verify damage reduction (-50%) prevents offensive abuse

### Week 4: Edge Cases
- [ ] Test staff swap mid-ragebait (should end buff + cooldown)
- [ ] Test target death mid-ragebait (should end buff + cooldown)
- [ ] Test on low sanity (range multiplier should increase)
- [ ] Test in multiplayer (verify per-player tier tracking)

### Week 5: Tier Features (if implemented)
- [ ] Tier 2+: Verify ally buff applies to nearby teammates
- [ ] Tier 3+: Verify stealth triggers on hit interrupt
- [ ] Tier 4+: Verify multiple targets can be taunted simultaneously
- [ ] Tier 5: Verify shortest cooldown applies

---

## Configuration via modinfo.lua

Players can override defaults through mod configuration in-game:

```lua
-- modinfo.lua options shown in mod menu
configuration_options = {
    {
        name = "base_range",
        label = "Ragebait Base Range",
        options = {
            {description = "10 units", data = 10},
            {description = "15 units (Default)", data = 15},
            {description = "20 units", data = 20},
            {description = "25 units", data = 25},
        },
        default = 15,
    },
    -- ... more options
}
```

Modify `modinfo.lua` to add additional tuning options (e.g., custom cooldown multipliers).

---

## Balance Philosophy

The Ragebait mechanic is designed as a **high-risk, high-reward** system:

- **Risk**: One-hit-cancel forces precision; 2x damage vulnerability is severe
- **Reward**: Forced enemy focus frees allies; speed boost enables kiting
- **Progression**: Tier unlocks take time (1–45 manuals), encouraging extended play
- **Customization**: Mod config allows servers to adjust difficulty on-the-fly

When tuning, ask:
1. Does the mechanic feel like it has a clear risk/reward tradeoff?
2. Are early tiers (1–2) accessible to new players?
3. Are late tiers (4–5) achievable after reasonable effort?
4. Can skilled players mitigate risk through positioning/kiting?

---

## Known Limitations & Future Tuning

- **Stealth Mode (Tier 3+)**: Currently stub; tuning will depend on final implementation
- **Ally Buff (Tier 2+)**: Currently stub; damage vs. healing choice not finalized
- **Multi-Target (Tier 4+)**: Currently stub; priority system may need tuning to prevent target thrashing
- **HUD Display**: Cooldown timer implementation may affect UX perceived difficulty

---

## Debugging & Monitoring

To check current tuning values in-game or via console:

```lua
-- Get all constants
local constants = require("data/ragebait_constants").ListConstants()
for _, c in ipairs(constants) do
    print(c.key .. " = " .. tostring(c.value))
end
```

---

## Change Log

**Version 0.1.0 (Initial Release):**
- Base range: 15 units
- Cooldowns: 60s → 20s (T1 → T5)
- Damage multiplier: 2.0x
- Damage reduction: 50%
- Tier thresholds: 1/4/10/20/45 (62-creature roster)
