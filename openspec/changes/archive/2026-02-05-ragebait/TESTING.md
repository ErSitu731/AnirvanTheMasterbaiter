# Ragebait — In-Game Testing Instructions

Status: This build includes Tier 1/Tier 2/Tier 3 features (staff activation, manuals, ally buff, stealth & burst). Follow this guide to install and test locally.

Prerequisites
-------------
- Don't Starve Together (Windows) installed.
- Close the game before installing local mods.

Install the mod locally
----------------------
1. Locate your DST local mods folder: %USERPROFILE%\Documents\Klei\DoNotStarveTogether\mods
2. Copy the folder `anirvan` from this repository into the `mods` folder. The resulting path should be something like:
   Documents\Klei\DoNotStarveTogether\mods\anirvan\modinfo.lua
3. Start Don't Starve Together and enable the mod from the **Mods → Local Mods** menu (enable for both client & server if testing multiplayer or hosting a local server).
4. Start a hosted game or dedicated server and make sure the mod loads.

Quick spawn commands (Developer Console)
---------------------------------------
Open the console (~) or enable it in the options if not available.
- Spawn items:
  - Ragebait Staff: c_spawn("ragebait_staff")
  - Hound Manual: c_spawn("ragebait_manual_hound")
  - Pig Manual: c_spawn("ragebait_manual_pig")
  - Spider Manual: c_spawn("ragebait_manual_spider")
  - Tallbird Manual: c_spawn("ragebait_manual_tallbird")
- Spawn enemies:
  - Hound: c_spawn("hound")
  - Pigman: c_spawn("pigman")
  - Spider: c_spawn("spider")
  - Tallbird: c_spawn("tallbird")
- Spawn ingredient drops for crafting (if you want to craft manuals naturally):
  - houndstooth: c_spawn("houndstooth")
  - pigskin: c_spawn("pigskin")
  - silk: c_spawn("silk")
  - tallbirdegg: c_spawn("tallbirdegg")
  - charcoal: c_spawn("charcoal")
  - papyrus: c_spawn("papyrus")

Basic test scenarios
--------------------
1. Basic activation test
   - Spawn and equip `ragebait_staff` or craft it (SCIENCE_ONE).
   - Spawn a `hound` and ensure you have the `hound` manual (craft or spawn `ragebait_manual_hound`).
   - Equip the staff, approach the hound, and attack it (left-click with staff in hand). If prerequisites are satisfied, the hound will become taunted (taunt tag) and target you exclusively.
   - Confirm: hound ignores other players; Anirvan takes increased damage (careful) and allies in range if Tier ≥ 2 get buff.

2. One-hit cancel + Stealth (Tier ≥ 3 test)
   - To test stealth, either craft 10 distinct manuals to reach Tier 3 or simulate by calling `inst.components.ragebait_controller:CraftManual(<manual>)` from the console for 10 manuals.
   - Ragebait a hound, then take a single hit (have an enemy or trap hit you). Confirm Ragebait cancels, you enter stealth (visual FX), and the first attack while stealth deals burst damage and ends stealth.

3. Ally Buff test (Tier 2)
   - With at least 4 manuals (Tier 2), ragebait a target and have an ally (another player or spawned friendly entity) near you.
   - Confirm the ally receives a visible buff FX and increased damage while in radius (8 tiles).

Notes & Troubleshooting
-----------------------
- If the staff attack prints "Ragebait unavailable: no_manual", you need to craft the manual for that enemy type first.
- If the staff attack prints "Ragebait unavailable: out_of_range", try moving closer (sanity affects range: ≤50% → 2x range, ≤25% → 4x range).
- If stealth does not seem to make enemies ignore you, remember stealth level uses the `notarget` tag; some scripted bosses may ignore this tag (we've added `ragebait_immunity` checks for boss phases).
- If you find a behavior bug (e.g., ragebait doesn't cancel on hit or buffs persist), report the exact steps, anything you spawned via console, and the in-game timestamp, and I'll iterate.

Where to report feedback
------------------------
- Add notes as comments in the issue `openspec/changes/ragebait/issues/12-playtest-plan.md` or open a new issue under `openspec/changes/ragebait/issues/` with a descriptive title (e.g., "Bug: Buff doesn't remove on cancel").

Ready-for-test checklist (developer)
------------------------------------
- [x] Staff activation implemented via weapon onattack (no damage, triggers ragebait).
- [x] Manuals & recipes added for early set (hound/pig/spider/tallbird).
- [x] Tier 2 ally buff (+15% damage) implemented and visualized with placeholder FX.
- [x] Tier 3 stealth & burst implemented (6s stealth, 2x burst, placeholder FX).

Happy testing — tell me what you encounter and I'll iterate quickly.