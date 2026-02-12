# Issue 01 — Add unit/integration tests for `ragebait_controller`

Summary
-------
Add focused tests that verify `ragebait_controller` state transitions, manual crafting persistence, save/load behavior, and the one-hit cancel flow.

Tasks
-----
- [x] Add unit tests for:
  - `CraftManual` sets crafted flag and triggers `ragebait_manualcrafted` event.
  - `GetTier` computes correct tier for small collections (0/1/4/10/30/70 thresholds).
  - `CanActivate` checks staff held, manual crafted, and sanity range scaling.
- [x] Add integration tests that simulate:
  - Activation and cancellation by hit; ensure `CancelRagebait` triggers cooldown and Stealth Mode if Tier ≥ 3.
  - Save/Load: crafted manuals persist and tier recomputes on load.

Notes:
- Tests implemented under `tests/test_ragebait_controller.lua` with a basic runner `tests/run_tests.lua`. Consider integrating with `busted` or CI harness for automated runs.
- To run locally, see `tests/README.md`. If Lua is not available on PATH, install Lua 5.1+ or use a packaged runtime; CI integration with `busted` is recommended for automated reporting.

Acceptance criteria
-------------------
- Tests run in CI locally and pass consistently.
- Tests cover edge cases (invalid targets, cooldown states).

Estimate: 1–2 days
Labels: testing, core, medium
