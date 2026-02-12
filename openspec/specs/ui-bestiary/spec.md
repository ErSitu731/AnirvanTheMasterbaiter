# Spec: UI & Bestiary

Capability overview
-------------------
Provide a Bestiary/Manuals tracker and in-world/HUD indicators for Ragebait activity and Manual state. This capability makes progression readable, shows what manuals the player has crafted and which ones remain, and provides immediate feedback for Ragebait activation, cooldowns, and stealth states.

Motivation
----------
Players need clear, accessible feedback about their manual collection progress, what manuals they own, whether they can ragebait a given enemy, and the status of Ragebait/Stealth during combat. Good feedback reduces player frustration with the one-hit cancel mechanic and makes progression goals clear.

Functional requirements
-----------------------
- Bestiary / Manual tracker UI:
  - Accessible from the main character menu or a keybind.
  - Shows a grid or list of all known enemy types with the following states per entry:
    - Not discovered (greyed out)
    - Discovered but uncrafted (shows recipe button and required materials)
    - Crafted (shows an "owned" icon and whether currently in inventory)
  - Displays: total distinct manuals crafted / total possible (e.g., 4/100) and a progress bar toward next tier threshold.
  - Provides a quick link to the manual's recipe and the monster drop required.
  - Allows filtering/sorting (e.g., by biome, by boss status, by crafted/unset).
- Manual Item Tooltip:
  - For each `ragebait_manual_<enemy>` item, tooltip should include: enemy name, brief description, whether it has been crafted, and crafting recipe.
- HUD indicators for Ragebait state:
  - Ragebait active: show a small HUD element indicating active state and remaining time (if timed) or "active" label if untimed.
  - Cooldown: show a cooldown timer that counts down, with a visual progress ring or bar and numeric seconds.
  - Stealth: show a stealth icon and remaining duration while stealth is active (Tier ≥ 3).
- World indicators:
  - Ragebaited enemy: show a clear taunt icon above the enemy and a visual effect (taunt aura or target icon) visible to all players.
  - Ally buff: show a small buff FX on allies who have the Tier 2 buff; include tooltip when hovered/clicked describing buff values.
- Accessibility & readability:
  - All HUD elements should have clear color contrast and optional labels for colorblind players.
  - Sounds should be optional and include visual alternatives.

Acceptance criteria
-------------------
- Bestiary UI is implementable within the existing UI system and shows accurate crafted/owned states.
- Ragebait and Stealth HUD elements update in real-time and match the player's current state.
- World indicators are visible to all players and clearly signal taunted enemies and buffed allies.

Edge cases & rules
------------------
- If the player crafts a manual while the Bestiary is open, the UI should refresh to show the new state immediately.
- If a manual was crafted in a previous run, the Bestiary should show it as crafted but indicate if the physical item is not currently in inventory.
- In multiplayer, other players should be able to see Ragebaited enemy indicators but not the player's Bestiary private progress unless explicitly implemented as shared features.

Metrics & telemetry
-------------------
- Track Bestiary open rates and how often players view recipes vs crafting manuals directly.
- Track HUD usage and whether players frequently check cooldowns/stealth indicators.

Test cases
----------
- Craft a manual and verify Bestiary updates immediately and progress toward next tier increments.
- Activate Ragebait and verify HUD shows active and cooldown timers for the correct player only.
- Verify world indicators appear on enemies and buffed allies for all players in the session.

Notes
-----
Keep UI designs simple and consistent with the existing DST UI. Focus on clarity: this system's primary goal is to communicate progression and combat state clearly to players.