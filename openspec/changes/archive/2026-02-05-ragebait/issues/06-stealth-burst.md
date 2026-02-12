# Issue 06 — Implement Tier 3 Stealth & Burst

Summary
-------
Add the Stealth Mode triggered by Ragebait interruptions when Tier ≥ 3: enter brief stealth, allow first attack to be a burst, then exit stealth.

Tasks
-----
- [x] Implement stealth state transitions in `ragebait_controller` and client HUD hooks. (controller-side implemented; HUD hooks emit events)
- [x] Implement burst logic for the first attack during stealth and remove stealth on first offensive action. (2x burst implemented)
- [x] Tune default stealth duration and burst multiplier (default: 6s, 2x damage).
- [x] Add placeholder FX for entering stealth and burst attack (placeholder prefab added)

Acceptance criteria
-------------------
- Stealth reliably triggers on Ragebait break by hit or manual cancel when Tier ≥ 3.
- Burst attack deals amplified damage and ends stealth.

Notes:
- Stealth adds tags `ragebait_stealth` and `notarget` and emits `enter_ragebait_stealth`/`exit_ragebait_stealth` events for HUD and FX to listen to.
- Burst uses a temporary damage multiplier and restores previous value immediately after the attack.

Estimate: 2–3 days
Labels: gameplay, medium
