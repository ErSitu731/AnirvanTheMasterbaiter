# Issue 08 — Implement Tier 5 Enemy-vs-Enemy behavior

Summary
-------
Implement logic to make ragebaited enemies attempt to target nearby enemies (enemy-vs-enemy) when Tier ≥ 5, with loop prevention and boss immunities.

Tasks
-----
- Add target selection for enemy-vs-enemy and a temporary target override component.
- Implement loop detection/time-based fallback to normal AI to prevent infinite fight loops.
- Add immunities/exceptions for bosses and scripted entities.
- Add FX to indicate enemy-vs-enemy behavior.

Acceptance criteria
-------------------
- Enemy-vs-enemy behavior triggers in expected scenarios and resolves when targets die or become invalid.
- System prevents infinite loops and handles boss immunities gracefully.

Estimate: 3–5 days
Labels: gameplay, complex
