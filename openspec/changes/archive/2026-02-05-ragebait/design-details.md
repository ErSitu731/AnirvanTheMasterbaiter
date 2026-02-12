# Ragebait — Implementation Design Details

Purpose
-------
Provide concrete implementation guidance for developers: data models, component interfaces, pseudocode for state transitions, and tuning knobs. This is a developer-focused companion to `design.md` and the specs.

Data Models
-----------
- Manual definition table (`data/manuals.lua`):
  - Key: `manual_id` (string) e.g., `ragebait_manual_hound`
  - Properties: `enemy_tag(s)`, `drop_item`, `is_boss`, `icon`, `description`
- Player component fields (`ragebait_controller`):
  - `cooldown_end_time` (number)
  - `current_state` (enum: idle, active, cooldown, stealth)
  - `active_targets` (list of entity refs)
  - `crafted_manuals` (set of manual_ids) — persists per player
  - `tier` (1..5) computed from `crafted_manuals.size()`

Component Interfaces
--------------------
- Player `ragebait_controller` functions:
  - `CanActivate(target)` -> boolean; checks staff held, manual crafted, cooldown, range
  - `Activate(targets)`; applies `Ragebaited` state to targets and sets controller state to active
  - `OnHit(damage_source)`; called by combat hooks when player receives damage; will call `CancelRagebait(reason="hit")`
  - `CancelRagebait(reason)`; clears active target overrides, triggers stealth if applicable, and starts cooldown timer
  - `CraftManual(manual_id)`; adds manual to `crafted_manuals` and recomputes `tier`
- Enemy `ragebaitable` interface/hooks:
  - `ApplyRagebait(controller_ref)`; stores controller reference and overrides targeting logic
  - `RemoveRagebait()`; reverts behavior to pre-ragebait AI

Pseudocode: Activation
----------------------
```
function Player:UseRagebaitOn(target)
  if not self:HasStaff() or not self:HasCraftedManualFor(target.type) then return error end
  local targets = self:GetTargetsForTierAndMode(target)
  self.active_targets = targets
  for t in targets do
    t:ApplyRagebait(self)
  end
  self.current_state = "active"
  self:SetTemporaryModifiers({damage_multiplier=2, speed_bonus=0.3, damage_reduction=-0.5})
end
```

Pseudocode: OnHit
-----------------
```
function Player:OnHit(damage)
  if self.current_state == "active" then
    self:CancelRagebait("hit")
  end
end
```

Pseudocode: Cancel
------------------
```
function Player:CancelRagebait(reason)
  for t in self.active_targets do
    t:RemoveRagebait()
  end
  self.active_targets = {}
  self.current_state = "cooldown"
  self.cooldown_end_time = GetTime() + self:GetCooldownForTier()
  if reason == "hit" and self.tier >= 3 then
    self:EnterStealth()
  end
end
```

Stealth & Burst
----------------
- `EnterStealth()` sets `current_state` = stealth, `stealth_end_time` = GetTime() + stealth_duration
- While in stealth, `OnAttack` checks if `is_first_attack` then apply burst multiplier and exit stealth

Tier Logic
----------
- Tier is computed from `crafted_manuals.size()` with thresholds: 1->T1, 4->T2, 10->T3, 30->T4, 70->T5

Safety & Edge Cases
-------------------
- Add `ragebait_immunity` tag to immune boss states; `ApplyRagebait` returns false if entity has tag or is untargetable
- Loop prevention for enemy-vs-enemy: store `last_target_change_time` per enemy; if changes exceed X times in Y seconds, revert to neutral AI behavior

Tuning knobs
------------
- Base range, speed bonus, damage multipliers
- Stealth duration, burst multiplier
- AoE max targets, radius
- Cooldown per tier

Testing
-------
- Unit tests for controller state transitions and `CraftManual`
- Integration tests for boss fights and AoE scenarios

Notes
-----
- Persist `crafted_manuals` in the player's save data to survive restarts and deaths.
- Consider data-driven recipes to allow simple content updates and community contributions.