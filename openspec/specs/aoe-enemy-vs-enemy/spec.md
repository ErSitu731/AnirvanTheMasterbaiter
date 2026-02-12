# Spec: AoE Ragebait & Enemy-vs-Enemy (Tier 4 & 5)

Capability overview
-------------------
Define the Area-of-Effect (AoE) Ragebait behavior enabled at Tier 4 and the Enemy-vs-Enemy behavior enabled at Tier 5. This spec clarifies how AoE targeting selects multiple enemies, how ragebaited enemies switch their target to other enemies, constraints to prevent stuck or broken combat, and performance considerations for large swarms.

Motivation
----------
AoE Ragebait and Enemy-vs-Enemy transform the mechanic from single-target control into a powerful crowd-control / chaos tool. These capabilities expand the ways players can shape fights and create emergent interactions (e.g., monsters turning on each other), but require careful rules to avoid broken states.

Functional requirements
-----------------------
- AoE Ragebait (Tier 4):
  - Activation: When Tier 4 is unlocked, the Ragebait Staff can target multiple enemies within a configurable radius.
  - Target selection:
    - By default, choose up to N enemies within radius, where N is configurable; suggested starting value = 4.
    - Prioritize hostile enemies (monsters and bosses) and ignore passive fauna unless explicitly tagged as "ragebaitable".
    - The radius should be configurable (suggest default = 6 tiles) and scale with sanity thresholds like single-target ragebait.
  - Active effects:
    - Each selected enemy enters the Ragebaited state and will target Anirvan exclusively.
    - All other Ragebait properties (Anirvan x2 damage taken, speed increase, damage reduction to player, ally buffs) apply unchanged.
  - Performance & safety:
    - Limit the number of targets per activation to avoid large-scale AI churn (e.g., cap at 8 max even if many enemies are in range).
    - For very large groups, apply selection heuristics (closest, highest threat, or random) to keep behavior predictable.

- Enemy-vs-Enemy (Tier 5):
  - Activation: When Tier 5 is unlocked, Ragebait can include a mode where targeted enemies are compelled to attack other nearby enemies (including other ragebaited enemies) instead of focusing solely on Anirvan.
  - Behavior:
    - For each ragebaited enemy E, attempt to find a valid enemy target T within a specified secondary radius R2 (suggest default = 8 tiles).
    - Valid targets are entities that are hostile toward E (non-friendly) and are not Anirvan or other players (unless intended by design).
    - When a valid T is found, E's targeting system should be overridden to target T for the duration of Ragebait. If T dies or becomes invalid, E will try to find another T or revert to focusing Anirvan as fallback.
  - Interaction with AoE and single-target modes:
    - Enemy-vs-Enemy works well in tandem with AoE ragebait: some enemies will be taunted to Anirvan, but Tier 5 behavior can cause them to aggro each other for chaotic fights.
  - Safety & constraints:
    - Prevent permanent non-combat loops (e.g., two neutral creatures fighting forever) by imposing timeouts or state transitions that revert to normal AI after X seconds without progress.
    - Ensure boss encounters with special phases or immunities are handled gracefully: if a boss is immune to switching targets, skip enemy-vs-enemy behavior for that entity and fall back to standard ragebait mechanics.

Edge cases & rules
------------------
- Non-ragebaitable entities: Some creatures (e.g., peaceable fauna, scripted NPCs) should be explicitly tagged as non-ragebaitable. The AoE selection logic must skip those.
- Boss immunities: Bosses with special mechanics may be immune to target switching; log a graceful failure and do not apply enemy-vs-enemy to those bosses.
- Persistent aggression loops: If two creatures repeatedly switch targets and result in no progress (no HP lost over a window), force a cooldown or revert them to normal AI to avoid infinite loops.
- Friendly-fire & environment: If enemy-vs-enemy causes environmental destruction (e.g., fire spread), ensure it is balanced and does not create soft locks.

Acceptance criteria
-------------------
- Tier 4 enabling AoE targeting works reliably and does not cause performance spikes in large fights.
- Tier 5 causes meaningful enemy-vs-enemy interactions in appropriate contexts while avoiding infinite loops and boss-breaking behavior.
- The system logs or reports gracefully when it cannot apply the enemy-vs-enemy effect (e.g., immune entity) and fails without causing state corruption.

Metrics & telemetry
-------------------
- Track number of AoE targets per activation and average enemy count in radius.
- Track instances where enemy-vs-enemy triggers and whether it leads to reduced friendly damage or faster kill times.
- Track failures due to immunities or special phases to identify needed exceptions.

Test cases
----------
- AoE activation with exactly N enemies in radius: all N become Ragebaited.
- AoE activation with >N enemies in radius: selection heuristic chooses appropriate N and behaves consistently.
- Enemy-vs-enemy activation in a mixed group: verify some enemies switch to attack nearby enemies and fights progress.
- Boss immunity: attempt to apply enemy-vs-enemy to an immune boss and verify fallback behavior.
- Loop prevention: create a scenario where two passive creatures might loop and verify the system breaks the loop after a timeout.

Implementation considerations
---------------------------
- Implement target selection in the player `ragebait_controller` component and support modes for single-target vs. AoE.
- For enemy-vs-enemy, implement a temporary target override component or AI message that can be safely applied and removed without breaking AI state.
- Add configurable constants for max_targets, AoE radius, enemy-vs-enemy radius, and loop timeout.

Notes
-----
Balancing these behaviors requires careful playtesting with swarms and boss fights. Start conservatively: small AoE, low max targets, clear immunities for bosses, and longer loop-detection timeouts to prevent unintended interactions.