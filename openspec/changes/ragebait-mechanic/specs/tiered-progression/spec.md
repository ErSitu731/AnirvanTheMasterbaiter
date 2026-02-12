# Spec: Tiered Progression System (Delta)

This spec refines the existing Tiered Progression capability with details specific to the ragebait-mechanic change, focusing on automatic tier unlocks and the expanded creature roster.

## MODIFIED Requirements

### Requirement: Automatic tier unlock on manual count threshold
The system SHALL automatically unlock tier capabilities when the player's crafted distinct manuals count reaches or exceeds the tier threshold, without requiring restart or manual activation.

#### Scenario: Tier 1 unlocks at 1 manual
- **WHEN** a player crafts their first manual of any creature
- **THEN** Tier 1 capabilities are immediately available (no restart needed)

#### Scenario: Tier 2 unlocks at 4 manuals
- **WHEN** a player crafts their fourth distinct manual
- **THEN** Tier 2 capabilities (e.g., ally buffs, reduced cooldown) are immediately available

#### Scenario: Tier 3 unlocks at 10 manuals
- **WHEN** a player crafts their tenth distinct manual
- **THEN** Tier 3 capabilities (e.g., Stealth Mode on interrupt) are immediately available

#### Scenario: Tier 4 unlocks at 20 manuals
- **WHEN** a player crafts their twentieth distinct manual
- **THEN** Tier 4 capabilities (e.g., multi-target Ragebait) are immediately available

#### Scenario: Tier 5 unlocks at 45 manuals
- **WHEN** a player crafts their forty-fifth distinct manual
- **THEN** Tier 5 capabilities (e.g., shortest cooldown) are immediately available

### Requirement: Tier progression is independent of which specific manuals are crafted
The system SHALL calculate tier solely on the count of distinct creature types with crafted manuals, not on which creatures are chosen.

#### Scenario: Any four distinct manuals unlock Tier 2
- **WHEN** a player crafts manuals for four different creatures (e.g., spider, hound, tentacle, lureplant)
- **THEN** Tier 2 unlocks regardless of which specific creatures are chosen

#### Scenario: Duplicate creatures do not grant tier progress
- **WHEN** a player crafts a second manual for spider (already crafted before)
- **THEN** the distinct manual count does not increase and no tier progress is made

## ADDED Requirements

### Requirement: Tier system accounts for dynamic creature roster
The system SHALL maintain fixed threshold numbers (1/4/10/20/45) tuned for the 62-creature roster; tier unlock thresholds are numerical, not percentage-based, to provide predictable progression milestones.

#### Scenario: Fixed threshold with expanding roster
- **WHEN** new creatures are added to vanilla DST (e.g., next DLC expansion adds 20 new creatures)
- **THEN** the tier unlock thresholds remain 1/4/10/20/45; if new creatures are added later, thresholds can be rebalanced or extended (e.g., new T6 at 70 manuals)

#### Scenario: New creatures are tier-unlocked appropriately
- **WHEN** new creatures are added
- **THEN** manuals for new creatures are immediately craftable and count toward tier progression for any player who has already unlocked access

#### Scenario: Balance tuning is based on current roster
- **WHEN** threshold values are analyzed
- **THEN** they are documented as assuming ~100 hostile/neutral creatures; if the roster changes significantly, thresholds may be re-evaluated

### Requirement: Per-player tier tracking across sessions
The system SHALL persist each player's distinct manuals crafted count and current tier in save data, allowing tier state to be restored on login.

#### Scenario: Tier state persists across sessions
- **WHEN** a player logs out and back in
- **THEN** their crafted manuals and current tier are restored exactly as they left them

#### Scenario: Tier state is per-character, per-player
- **WHEN** multiple players play on the same server
- **THEN** each player's tier unlock is calculated independently based on their own crafted manuals

#### Scenario: Newly received manuals do not grant tier progress
- **WHEN** a player receives a manual from another player (not by crafting it)
- **THEN** the tier system only increments the distinct count if this is the first manual of that creature type the receiving player crafted themselves, per their own crafted flag

Notes
-----
Fixed thresholds (rather than percentage-based) provide predictable progression goals and allow the system to scale as content is added. Per-player tracking ensures cooperative play doesn't force shared progression. Tier capabilities unlock immediately to reduce friction and provide satisfying mid-gameplay power jumps.
