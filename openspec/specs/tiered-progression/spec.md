# Spec: Tiered Progression System

Capability overview
-------------------
Formalize how Ragebait tiers unlock as players craft distinct manuals, mapping the manual-count thresholds to game phases and enumerating constraints and behaviors. This spec clarifies the thresholds, the per-player counting model, interactions with added enemies, and expected pacing across Early / Mid / Late game.

Motivation
----------
Tying staff upgrades to the player's breadth of manuals encourages exploration and progression that feels earned rather than resource-gated. Fixed thresholds allow clear goals (aspirational endgame power) while staying predictable for playtesters.

Functional requirements
-----------------------
- Unlock thresholds:
  - Tier 1: 1 distinct manual crafted
  - Tier 2: 4 distinct manuals crafted
  - Tier 3: 10 distinct manuals crafted
  - Tier 4: 30 distinct manuals crafted
  - Tier 5: 70 distinct manuals crafted
- Unlock semantics:
  - Tiers are *global to the player* (per-player progression). Crafting a manual sets a crafted flag for that player; the set of flags determines the player's current tier.
  - Tiers unlock additional Staff capabilities automatically when their distinct-manuals count meets or exceeds the threshold.
  - Unlocking a tier does not retroactively modify previously used Ragebait activations; it only affects future activations and abilities.
- Relation to enemy-specific manuals:
  - Having crafted a manual for enemy type E is required to *activate* Ragebait on instances of E (per-enemy gating).
  - Tier unlocks are independent of which specific manuals are crafted; only the count matters. For example, crafting manuals for four spiders counts the same as crafting four different enemy manuals for unlocking Tier 2 (but note: there should be one manual per enemy type in normal data; duplication is allowed but does not increase distinct count).
- Phase mapping and pacing:
  - Tier 2 (4 manuals): early game (day 0–30) — intended to be achievable in normal early exploration.
  - Tier 3 & Tier 4 (10 / 30 manuals): mid-game — requires intentional exploration and mid-game progression.
  - Tier 5 (70 manuals): late-game — aspirational, requires broad exploration or multiple runs.
- New enemy types:
  - If new enemy types are added (e.g., via updates/mods), they are included in the Bestiary and count toward the total possible manual count. The thresholds remain fixed numbers (1/4/10/30/70), so the percentage of the bestiary they represent will adapt as content changes.

Acceptance criteria
-------------------
- When a player crafts their Nth distinct manual and crosses a threshold, Tier N's capabilities become active immediately (no restart required).
- The system properly calculates distinct manuals (boolean crafted flag per enemy type) and does not increment for duplicates.
- Players with shared/received manuals do not gain crafted flags unless they *crafted* the manual themselves (per-player crafted flags).
- Changes to the game's enemy roster update the Bestiary UI and do not break existing crafted flags.

Edge cases & rules
------------------
- Manual destruction or trading does not remove the crafted flag from the originating player's progress (crafted flag is a historical record). The Bestiary UI should show both "crafted" and "owned" states.
- If players want cooperative progress acceleration later, consider an optional design extension where a shared guild/party bestiary exists; this is explicitly out of scope for the initial implementation.
- If a player crafts their first manual and it is a boss manual, Tier 1 unlocks normally; bosses are treated the same way as regular enemies for counting purposes.

Metrics & telemetry
-------------------
- Track distinct manuals crafted per player over time.
- Track time to reach each tier and distribution across players.
- Track which enemy manuals are most/least commonly crafted (helps tune accessibility and difficulty).

Test cases
----------
- Craft 1 manual → verify Tier 1 unlocks.
- Craft 4 distinct manuals (various types) → verify Tier 2 unlocks.
- Craft duplicate manuals for the same enemy type multiple times → distinct-manuals count does not change.
- Craft a boss manual first → Tier system responds as if it were any other manual.
- Add a mock new enemy type and verify the Bestiary updates and thresholds remain consistent.

Notes
-----
Threshold values were chosen to make Tier 2 easily obtainable in early play and to make Tier 5 a long-term aspirational goal (4 / 10 / 30 / 70). These values are tuned around roughly ~100 hostile enemy types; if the roster significantly changes, revisit thresholds to maintain intended pacing.