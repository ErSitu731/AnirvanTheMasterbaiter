# Spec: FX & SFX

Capability overview
-------------------
Define all visual and audio feedback for Ragebait activation, active state, ally buffs, stealth enter/exit, burst attack, AoE activations, and enemy-vs-enemy behavior. This spec outlines asset needs, animation timing, visibility for other players, and accessibility considerations.

Motivation
----------
Clear and satisfying FX/SFX are critical to player communication: Ragebait is high-risk and players must understand when it is active, when it breaks, and when stealth/burst is available. Proper audio-visual cues also help teammates respond appropriately.

Requirements
------------
- Ragebait activation FX/SFX:
  - Distinct activation sound and visual taunt ring centered on the target entity.
  - Taunt icon above the enemy HUD (visible to all players).
- Ragebait active FX:
  - An aura or outline on Anirvan indicating vulnerability and increased speed.
  - A targeting FX on the enemy indicating "focused on Anirvan" (red taunt icon, pulsing ring).
- Ally buff FX:
  - Small particle ring or glow on allies while buffed; tooltip shows buff values.
- Stealth FX/SFX:
  - Enter stealth sound and fade-out visual for Anirvan; stealth icon appears in HUD.
  - Burst attack FX: brief flash and hit SFX; show stronger hit effect than normal attacks.
- AoE & enemy-vs-enemy FX:
  - AoE activation shows a widening ring; multiple taunt icons on enemies.
  - Enemy-vs-enemy confusion FX: optional small anger/fight icons above enemies engaging others.

Implementation notes
--------------------
- FX prefabs should be small and optimized; avoid heavy particle usage to prevent frame drops in large fights.
- Provide colorblind-friendly variations and audio fallback cues for accessibility.

Acceptance criteria
-------------------
- Visual and audio cues are present for activation, active state, stealth, burst, and ally buffs.
- FX do not cause performance regressions in mid-sized fights.

Assets list
-----------
- Activation sound
- Taunt ring FX prefab
- Anirvan vulnerable aura prefab
- Ally buff glow prefab
- Stealth enter/exit SFX and visual
- Burst hit FX

Test cases
----------
- Activate Ragebait and verify FX plays and taunt icons appear.
- Multiple AoE activations: verify FX scales without performance issues.
- Stealth enter + burst attack: verify proper FX and SFX trigger on burst.