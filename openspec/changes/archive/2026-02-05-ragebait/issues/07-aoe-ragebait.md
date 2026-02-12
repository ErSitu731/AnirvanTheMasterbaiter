# Issue 07 — Implement Tier 4 AoE Ragebait targeting

Summary
-------
Implement AoE mode for the staff when Tier ≥ 4: select up to N targets in radius and apply Ragebaited state to each.

Tasks
-----
- Add AoE selection to `ragebait_controller:Activate` when tier >= 4.
- Implement selection heuristic (closest N targets) and configurable max targets (suggest default 4).
- Ensure sanity range scaling applies and performance is considered for large groups.
- Add FX to indicate AoE activation and multiple taunt icons.

Acceptance criteria
-------------------
- AoE activation reliably taunts up to N enemies and does not exceed performance budgets.
- Behaviour follows selection heuristics consistently.

Estimate: 2–4 days
Labels: gameplay, medium
