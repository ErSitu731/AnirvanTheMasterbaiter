# Issue 12 — Playtest plan and telemetry hooks

Summary
-------
Create a structured playtest plan and add telemetry hooks to collect metrics (uptime, success/failure rates, manual crafting distribution, tier progression times).

Tasks
-----
- Add telemetry events in `ragebait_controller` (activation, cancel reason, manual crafted, tier changed).
- Design a playtest plan with focused scenarios: early-game, mid-game, boss fights, and swarm fights.
- Run initial internal playtests and gather metrics for tuning.

Acceptance criteria
-------------------
- Telemetry events are emitted and collected during playtests.
- Playtest report includes the metrics specified and actionable tuning recommendations.

Estimate: 1–2 days
Labels: analytics, testing, small
