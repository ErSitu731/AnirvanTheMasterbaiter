# Issue 11 — Multiplayer and networking tests

Summary
-------
Add tests and manual play scenarios to validate Ragebait behavior in multiplayer: taunt propagation, HUD visibility per player, and stability across networked events.

Tasks
-----
- Create test scenarios with multiple players and verify only the owner sees cooldown/stealth HUD elements.
- Verify that applied target overrides replicate properly to server and other clients.
- Test swapping staff mid-ragebait and ensure consistent state across clients.

Acceptance criteria
-------------------
- Multiplayer sessions remain stable and state is consistent across clients.

Estimate: 2–3 days
Labels: testing, multiplayer, medium
