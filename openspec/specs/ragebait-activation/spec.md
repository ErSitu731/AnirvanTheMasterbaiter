# Spec: Ragebait Activation & Behavior

Capability overview
-------------------
Allow Anirvan to use the Ragebait Staff to force one or more enemies to target them, creating a controllable aggro state. This capability defines the activation rules, active behavior, interruption conditions, sanity-based range scaling, and cooldown interactions.

Motivation
----------
This capability is the core of the Ragebait mechanic: it creates the risk-reward loop (Anirvan draws aggro and becomes vulnerable while enabling teammates to deal damage safely).

Functional requirements
-----------------------
- Preconditions:
  - Player must be holding the `ragebait_staff`.
  - Player must have crafted that enemy's `ragebait_manual_<enemy>`.
  - Activation ability must be off cooldown.
- Activation:
  - Player uses the staff on a valid enemy entity within effective range.
  - If valid, that enemy enters the *Ragebaited* state (see State Machine).
- Active effects while Ragebaited:
  - Target(s) exclusively target Anirvan (ignore other players even when hit).
  - Anirvan receives a damage multiplier of x2 (subject to tuning).
  - Anirvan receives a movement speed bonus (suggested +30%).
  - Anirvan's personal damage output is reduced (suggested -50%).
  - The base ragebait range is configurable; effective range scales with Anirvan's sanity:
    - Above 50% sanity: 1x base range
    - 50% or below: 2x base range
    - 25% or below: 4x base range
- Interruptions and cancellation:
  - Ragebait ends when any of the following occur:
    - The player manually cancels the effect.
    - The target enemy dies.
    - Anirvan takes any damage while Ragebait is active (one-hit cancel).
  - On interruption by hit (or manual cancel/staff swap), the Ragebait cooldown begins and (if Tier ≥ 3) Stealth Mode is triggered.
- Cooldown:
  - The cooldown value is tier-dependent: Tier 1=60s, Tier 2=55s, Tier 3=45s, Tier 4=30s, Tier 5=20s.

State Machine (summary)
------------------------
- Idle -> Activate (player uses staff) -> Ragebait Active
- Ragebait Active -> [Target dies | Manual cancel | Player hit] -> End Ragebait -> Enter Cooldown & optionally enter Stealth

Acceptance criteria
-------------------
- Activation only succeeds when preconditions are met.
- While Ragebait is active, the target's ai target is overridden and it only attacks Anirvan.
- A single hit to Anirvan while Ragebait is active immediately ends the effect and starts the cooldown; Stealth Mode is triggered if unlocked.
- Effective range responds to sanity thresholds accurately in playtests.

Edge cases & rules
------------------
- If multiple enemies are targeted (Tier ≥ 4), ensure each keeps targeting Anirvan and does not retarget other players.
- If the target is immune to taunt/aggro (e.g., special boss phases), Ragebait should fail gracefully and return the staff cooldown without allowing the state.
- Staff swapping mid-Ragebait triggers the same end behavior as a manual cancel (cooldown + stealth).

Metrics & telemetry
-------------------
Collect these during playtests for tuning:
- Usage count per run and per phase
- Success vs failure rate (how often Ragebait ends by hit vs manual cancel vs enemy death)
- Average uptime and average time from activation to interruption
- Number of times Ragebait prevented teammate damage

Test cases
----------
- Activation with/without manual crafted: verifies precondition gating.
- Activation at different sanity levels: verifies range scaling.
- Single-hit interruption: verify immediate end and cooldown start, and Stealth Mode trigger (when Tier ≥ 3).
- Staff swap during active Ragebait: verify cancellation semantics.
- Activation on boss with special ai: ensure graceful failure and no stuck states.

Notes
-----
Precise numeric tuning (movement %, damage %, base range) are defined in a separate balance doc and set as tunable constants for live testing.