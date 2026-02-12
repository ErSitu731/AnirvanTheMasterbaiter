# Spec: Stealth & Burst

Capability overview
-------------------
Define the Stealth Mode behavior unlocked at Tier 3: when Ragebait ends by hit, manual cancel, or staff swap (and Tier ≥ 3), Anirvan enters a brief stealth state that grants untargetability and enables a single high-damage "burst" attack. This spec defines triggers, durations, burst mechanics, detection rules, and interactions with cooldowns and other systems.

Motivation
----------
Stealth Mode converts the punitive one-hit cancel into a tactical recovery mechanic that rewards execution. It keeps Ragebait high-risk but gives Anirvan a chance to retaliate and survive, enhancing player satisfaction and counterplay.

Functional requirements
-----------------------
- Unlock condition: Stealth Mode is only available if the player has reached Tier 3 (10 distinct manuals crafted).
- Triggers: Stealth is entered immediately when Ragebait ends due to any of the following:
  - Anirvan takes any damage while Ragebait is active (one-hit cancel)
  - Player manually cancels Ragebait
  - Player swaps away from the staff mid-Ragebait
  - (Optional) Ragebait times out (if a timed duration is later added)
- Stealth properties:
  - Duration: default starting value = 6 seconds (tunable).
  - While stealth is active:
    - Anirvan is untargetable by enemies (they will not start new attacks targeting Anirvan).
    - Visual + audio cue indicates stealth state to both Anirvan and nearby players.
    - Anirvan may move freely; collision and physics remain normal.
    - Stealth is broken on any offensive action (melee/ranged attack or use of an active combat item).
  - Burst attack:
    - The first attack performed while in stealth deals amplified damage.
    - Default burst multiplier = 2.0× (tunable); consider health-scaling or weapon-scaling interactions.
    - After the burst attack, stealth ends immediately.
- Cooldown interaction:
  - The Ragebait cooldown begins as soon as Ragebait is interrupted (hit or manual cancel) and is independent of the stealth duration. Stealth does not pause or alter the cooldown.
- Detection & AoE interactions:
  - Area-of-effect enemy attacks (e.g., ground-pound, explosion) do not necessarily break stealth unless they directly damage Anirvan.
  - Enemies with special detection mechanics (e.g., sensing through walls) may need explicit rules; default: damage breaks stealth but detection alone does not.

Acceptance criteria
-------------------
- Tier 3 players consistently enter Stealth Mode when Ragebait ends for the specified reasons.
- Stealth duration and burst mechanics function reliably in single-player and multiplayer.