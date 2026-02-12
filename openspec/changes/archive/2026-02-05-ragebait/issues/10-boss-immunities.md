# Issue 10 — Boss immunities and non-ragebaitable tag

Summary
-------
Add support for `ragebait_immunity` and `non-ragebaitable` tags and ensure the controller handles these gracefully (activation should fail or skip immune entities).

Tasks
-----
- Define tags `non-ragebaitable` and `ragebait_immunity` that can be applied to prefabs or temporarily set during boss phases.
- Update `CanActivate` and AoE selection to skip these entities and report graceful failure.
- Add tests covering boss immunity cases.

Acceptance criteria
-------------------
- Activation does not apply to immuned entities and does not leave the system in a broken state.

Estimate: 1 day
Labels: gameplay, small
