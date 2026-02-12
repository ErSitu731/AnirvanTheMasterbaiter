# Spec: Manuals & Crafting

Capability overview
-------------------
Define how Ragebait Manuals are crafted, what items they require, how they persist, and how they contribute to tier unlocking. This spec covers the recipe, persistence, counting rules, boss/manual interactions, and UI affordances for tracking progress.

Motivation
----------
Manuals are the primary progression currency for Ragebait. By tying progression to crafting manuals for different enemy types, the mechanic rewards exploration and kills across the game's bestiary.

Functional requirements
-----------------------
- Manual crafting requirements:
  - Each `ragebait_manual_<enemy>` requires a monster-specific drop (from the enemy type) plus charcoal and paper. Exact ingredient counts are tunable but must include at least one monster drop token.
  - Boss manuals require a boss-specific drop and should be accordingly rare.
- Crafting behavior:
  - Crafting a manual consumes the recipe ingredients and creates a persistent manual item in the player's inventory.
  - Crafting the same manual multiple times is allowed but should not increment the "distinct manuals crafted" counter more than once.
  - The game should track whether the player has crafted a manual for a given enemy type (boolean per enemy type) for unlocking tiers.
- Manual persistence:
  - Manuals are inventory items that persist across player death and are not consumed on use.
  - Manuals are transferable between players via regular item transfer mechanics; for tier counting purposes, the player's own crafted manuals count toward their personal count. (See open question below regarding sharing mechanics.)

Unlock rules & counting
-----------------------
- Tier unlocks are based on the total number of distinct manual types the player has crafted:
  - T1: 1 manual
  - T2: 4 manuals
  - T3: 10 manuals
  - T4: 30 manuals
  - T5: 70 manuals
- The "distinct manuals" count is calculated by the set of enemy types for which the player has crafted at least one manual. Duplicate crafts or multiple copies of the same manual do not increase the count.
- Bosses and special variants count the same as regular enemies toward the distinct count.

UI & Feedback
-------------
- Manuals should display a tooltip indicating the enemy type they unlock and whether the manual has been crafted by the player.
- Add a Bestiary/Manuals tracker UI showing:
  - Total distinct manuals crafted / total possible (e.g., 13/100)
  - A list or grid of enemy types indicating crafted state (crafted / not crafted)
  - Quick link to recipe and required items for uncrafted manuals (where applicable)

Acceptance criteria
-------------------
- Player can craft a manual only when they possess the required monster drop, charcoal, and paper.
- After crafting, the manual exists as a persistent inventory item and the player's distinct-manuals count increases if it was not previously crafted.
- The system counts boss manuals the same as regular manuals for tier unlocks.
- Crafting duplicates does not increment the distinct-manuals count.

Edge cases & rules
------------------
- If a manual is destroyed/dropped/sold, the player's distinct manual count should still reflect that they have previously crafted that manual (the "crafted once" flag is retained), but the Bestiary UI should show whether they currently hold a copy.
- If manuals are shared among players, they should not automatically grant tier unlocks to the receiving player unless the receiving player has also crafted that manual (policy decision; default: crafted flag is per-player and only set when that player crafts it themselves).
- If a new enemy type is added later, it should be included in the Bestiary and the total count should be updated dynamically.

Metrics & telemetry
-------------------
- Track manuals crafted per player over time.
- Track the distribution of which manuals are crafted first and which are rare.
- Track time-to-next-tier based on manual count growth rate.

Test cases
----------
- Crafting without monster drop: recipe should fail.
- Crafting with required items: manual appears in inventory and crafted flag is set.
- Crafting duplicates: second craft creates an extra item but does not change distinct manual count.
- Destroying manual item: crafted flag remains set, Bestiary UI shows "crafted but not owned" state.
- Boss manual crafting: requires boss drop and sets crafted flag.

Open questions
--------------
- Sharing policy: should manually transferred manuals count as "crafted" for the recipient? Current default: No; must craft yourself to count toward personal tier unlock.
- Should certain rare enemy manuals be weighted differently toward progression? Current default: equal weight.

Notes
-----
Implementation will need a small data table enumerating enemy types and their associated manual IDs and recipes. Manuals should be simple items (icons, descriptions) and integrate with the existing recipe/tech system.