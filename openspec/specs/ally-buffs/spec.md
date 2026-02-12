# Spec: Ally Buffs (Tier 2)

Capability overview
-------------------
Define the ally buff behavior unlocked at Tier 2: while Ragebait is active, nearby allies receive combat buffs to encourage team-play and make Anirvan's control meaningful. This spec covers what gets buffed, radius rules, stacking behavior, and interactions with other buffs and allies.

Motivation
----------
The ally buff gives teammates a tangible benefit for letting Anirvan play the control role. It rewards coordination, reduces the feeling of "freezing" when Anirvan draws aggro, and helps allies kill targets before Anirvan gets overwhelmed.

Functional requirements
-----------------------
- Unlock condition: Available once the player's manual count meets Tier 2 (4 distinct manuals crafted).
- Buff types (suggested defaults, tunable):
  - Damage dealt: +15% (multiplicative)
  - Damage reduction: +10% (multiplicative)
  - Optional: small healing-over-time (HoT) while in range (+1 HP per 5s) — consider for balance tests
- Buff radius and application:
  - Radius: configurable; suggested starting value = 8 tiles (~6–10 units depending on animation scale).
  - Buff applies to allied players and friendly NPCs (e.g., friendly companions or tamed entities), not to enemy summons.
  - Buff is applied as long as Ragebait remains active and the ally is within radius; effects refresh while in radius.
- Stacking & conflicts:
  - Multiple allies receiving the buff do not double-stack each other's buffs; each ally independently receives the buff while in range.
  - If multiple sources of the same buff exist (other items or traits), buffs stack multiplicatively unless explicitly flagged as non-stackable.
  - Buffs should not grant instant or capped invulnerability—maintain the risk for Anirvan.
- Duration & removal:
  - Buffs are removed immediately when Ragebait ends for any reason (manual cancel, player hit, target death) or when an ally leaves the radius.
  - Buff refresh interval should be short (e.g., buff applied every second) to minimize perceived latency.

Acceptance criteria
-------------------
- Allies within the specified radius receive the damage and damage-reduction buffs and see clear FX/UI indicating the buff.
- Buffs do not stack beyond intended multiplicative composition and are removed immediately when the Ragebait ends.
- The buff applies to allies and friendly NPCs only.

Edge cases & rules
------------------
- Allies performing ranged attacks from outside radius should not benefit.
- Allies that enter the radius mid-Ragebait receive the buff immediately (no global cooldown).
- If an ally applies a buff that would conflict (e.g., a stronger damage multiplier), ensure multiplicative stacking or set precedence rules.
- If Ragebait affects multiple enemies (Tier 4 AoE), ally buffs remain unchanged and operate independently.

Metrics & telemetry
-------------------
- Track how often allied buffs are active and their average uptime per Ragebait activation.
- Track contribution to kill rate when buffs are active vs inactive.

Test cases
----------
- Ally enters radius while Ragebait active: verify buff applies and FX shows.
- Ally leaves radius: verify buff is removed immediately.
- Ragebait breaks: verify buffs are removed from all allies immediately.
- Two allied buff sources present: verify stacking/multiplicative behavior matches spec.

Open questions
--------------
- Should allied HoT be included initially or reserved for tuning after playtests? Default: start without HoT; add if needed.
- Visual design for the ally buff FX and whether it should be globally visible to indicate the buff origin.