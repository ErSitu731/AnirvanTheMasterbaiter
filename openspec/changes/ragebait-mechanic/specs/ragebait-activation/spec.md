# Spec: Ragebait Activation & Behavior (Delta)

This spec refines the existing Ragebait Activation requirement with details specific to the ragebait-mechanic change, focusing on manual gating and implementation patterns.

## MODIFIED Requirements

### Requirement: Manual gating for creature activation
The system SHALL require the player to have crafted a specific creature's manual before being able to activate Ragebait on that creature type. Attempting to activate without the manual SHALL fail gracefully.

#### Scenario: Activation requires manual
- **WHEN** a player targets a creature they have not crafted a manual for
- **THEN** the activation fails and a message is shown (e.g., "You need X's manual first")

#### Scenario: Activation succeeds with manual
- **WHEN** a player targets a creature and has crafted that creature's manual
- **THEN** the activation proceeds normally (if other preconditions are met)

#### Scenario: Manual status is checked before preconditions
- **WHEN** the player attempts activation
- **THEN** the system first checks if the manual has been crafted, before checking cooldown or range

### Requirement: Sanity-scaled range effectiveness
The system SHALL scale the effective activation range based on Anirvan's current sanity level, with no additional perks at high sanity (encouraging risk-taking at lower sanity).

#### Scenario: Base range at high sanity
- **WHEN** Anirvan's sanity is above 50%
- **THEN** the activation range is 1x the base range

#### Scenario: Extended range at medium sanity
- **WHEN** Anirvan's sanity is between 25% and 50%
- **THEN** the activation range is 2x the base range

#### Scenario: Maximum range at low sanity
- **WHEN** Anirvan's sanity is below 25%
- **THEN** the activation range is 4x the base range

#### Scenario: Range check is performed before activation
- **WHEN** a player targets a creature outside effective range
- **THEN** activation fails and an appropriate message is shown (not just silent failure)

## ADDED Requirements

### Requirement: Staff item requirement for activation
The system SHALL require the player to be holding the Ragebait Staff item to activate Ragebait; if the player switches away from the staff, any active Ragebait ends immediately.

#### Scenario: Staff must be equipped
- **WHEN** a player does not have the staff equipped
- **THEN** activating Ragebait is not possible

#### Scenario: Staff swap cancels Ragebait
- **WHEN** Ragebait is active and the player equips a different tool
- **THEN** Ragebait ends immediately and the cooldown begins

#### Scenario: Staff unequip cancels Ragebait
- **WHEN** Ragebait is active and the player removes the staff from their equipment slot
- **THEN** Ragebait ends immediately and cooldown begins

Notes
-----
Manual gating is the key new requirement; it ensures the progression system directly gates access to the ability. Sanity-scaled range encourages strategic decision-making during high-risk moments.
