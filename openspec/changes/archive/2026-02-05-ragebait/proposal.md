# Ragebait — Proposal

Summary
-------
Ragebait is a new core mechanic for Anirvan that turns them into a sacrificial controller: Anirvan can force an enemy to focus on them (drawing aggro) using a "Ragebait Staff" and per-enemy "Ragebait Manuals". It is a high-risk, high-reward playstyle: while ragebaiting Anirvan becomes more vulnerable but enables team-centric strategies. Progression through the mechanic is gated by crafting manuals for different enemy types; unlocking a growing set of manuals unlocks higher tier abilities for the staff.

Goals
-----
- Create a distinct control/tank fantasy for Anirvan with clear risk/reward.
- Encourage exploration and varied combat experiences (one manual per enemy type, including bosses).
- Provide a natural progression curve and late-game aspirational power (tiered unlocks by manual count).
- Make the mechanic readable and tunable for balance and playtesting.

Non-Goals
---------
- Permanent invulnerability or an "instant win" button.
- Replacing Anirvan's identity with a pure DPS build.

Acceptance Criteria
-------------------
- A documented, functioning Ragebait system exists in design docs.
- Manuals are craftable (monster drop + charcoal + paper) and persist in inventory.
- The staff is craftable once (base Tier 1), indestructible, and requires being held to activate Ragebait.
- Tiers unlock automatically when the player crafts the number of distinct manuals specified (1 → 4 → 10 → 30 → 70).
- Ragebait behavior: enemies target only Anirvan, Anirvan takes double damage, gains speed, loses damage output; ragebait cancels on one hit, enemy death, or manual cancel and triggers stealth + cooldown.
- Balance placeholders exist for tuning ally buffs, stealth burst damage, durations, and cooldowns.

Risks
-----
- The one-hit cancel mechanic could feel punishing without readable telegraphs or extra recovery windows (we mitigate via auto-stealth on cancel).
- Requiring many manuals for top tier may be grindy; however, this is an intentional aspirational goal.

Next steps
----------
- Create a detailed design doc (mechanics, states, formulas) and task list for implementation and testing.