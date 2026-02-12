## Why

The mod needs a clear, functional Ragebait loop that is grounded in DST's existing mechanics and data, so the character kit can be tested and balanced before investing in art, FX, or audio. This lets us validate the gameplay value of the staff/manual system and per-creature gating early.

## What Changes

- Add or refine the Ragebait activation flow to match the intended one-hit-cancel risk/reward loop and sanity-scaled range.
- Introduce a Ragebait staff item and a manual item for each hostile/neutral creature, using vanilla data tables and existing DST recipe/book patterns where possible.
- Implement per-creature gating (manual required) and tier progression based on distinct manuals crafted.
- Provide placeholder assets from vanilla game(icons/anim builds) and data hooks only; no custom art, sfx, or fx production in this phase.
- Add an UI or warning that represents the cooldown of ragebait ability.

## Capabilities

### New Capabilities
- `ragebait-items`: Define the staff/manual item prefabs, placeholder assets from vanilla game, and data mapping from vanilla creatures to manual IDs.

### Modified Capabilities
- `ragebait-activation`: Refine activation, cancellation, and sanity-scaled range behavior to match the desired Ragebait loop.
- `manuals-crafting`: Expand manual crafting to cover all hostile/neutral creatures and follow vanilla book/paper-style recipe structures.
- `tiered-progression`: Ensure tier unlocks align with distinct manual counts for the expanded creature set.

## Impact

- New/updated prefab scripts for the staff and manuals; updates to recipe and crafting tech definitions.
- Data tables mapping creatures to manuals and required drops, derived from vanilla data where possible.
- Potential updates to existing mod initialization and tuning constants for balance testing.
