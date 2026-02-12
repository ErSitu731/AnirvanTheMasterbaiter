# Issue 02 — Implement manual recipes for early set and data table expansion

Summary
-------
Add recipes and prefab assets for a practical early set of manuals (hound, pig, spider, tallbird) and expand `data/manuals.lua` to include their metadata.

Tasks
-----
- Create `ragebait_manual_<enemy>` prefabs for pig, spider, tallbird with basic inventory data. (Implemented)
- Define recipes (drop + charcoal + papyrus/paper) and add to `modmain.lua`. (Implemented)
- Update `data/manuals.lua` to include new entries and include icons/strings. (Implemented)
- Add small inventory icons and placeholder build assets (or use existing icons).

Acceptance criteria
-------------------
- Manuals craft successfully when required drop items are present.
- Manuals appear in inventory with correct tooltips and are tracked by the Bestiary.

Estimate: 1 day
Labels: data, assets, small

Notes:
- Implemented initial prefabs and recipes for pig, spider, and tallbird manuals. Placeholder assets used; icons/build assets should be added in assets sprint.
