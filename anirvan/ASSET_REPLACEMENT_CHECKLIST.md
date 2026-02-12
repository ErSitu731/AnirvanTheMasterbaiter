# Ragebait Mechanic: Asset Replacement Checklist

This document lists all placeholder assets used in the Ragebait mechanic implementation. All placeholders are currently using vanilla DST assets and need to be replaced with custom artwork.

## Asset Categories

### 1. Ragebait Staff Assets
**Current Placeholders:**
- Animation: `anim/staff.zip` (vanilla staff animation)
- Inventory Icon: `staff` (vanilla staff icon)
- Swap Symbol: Using vanilla `swap_staff` symbol

**Requirements:**
- [ ] Custom staff animation build (`anim/ragebait_staff.zip`)
- [ ] Custom inventory icon (`images/inventoryimages/ragebait_staff.tex` + `.xml`)
- [ ] Custom swap symbol for equipped appearance
- [ ] Custom inspect animation (optional)

**Specifications:**
- Style: Should visually distinct from vanilla staff (different color scheme, unique design elements)
- Theme: Consider incorporating "bait" or "taunt" visual motifs
- States: idle, equipped swap symbol

---

### 2. Ragebait Manual Assets (62 variants needed)
**Current Placeholders:**
- Base Animation: `anim/papyrus.zip` (vanilla papyrus roll)
- Inventory Icons: All manuals use `papyrus` icon

**Requirements:**
- [ ] Base manual animation build (`anim/ragebait_manual_base.zip`)
- [ ] Manual atlas with 62 creature-specific icons (`images/inventoryimages/ragebait_manual_atlas.xml`)
- [ ] Individual manual textures (can be color/symbol variants of base design)

**Specifications:**
- Base Design: Book, scroll, or bestiary-style item
- Creature Differentiation Options:
  - Option A: Single base texture with color tint per creature category
  - Option B: 62 unique icons with creature silhouettes
  - Option C: Tiered sets (early/mid/late game visual styles)
- Size: Standard DST inventory icon size (64x64 base, 128x128 high-res recommended)

**Manual Creatures (62 total):**
See `anirvan/data/ragebait_creature_map.lua` for complete list. Categories:
- Spiders (6 variants)
- Hounds (3 variants)
- Depths creatures (5 types)
- Lunar creatures (8 types)
- Shadow creatures (4 types)
- Bosses (12 types)
- Chess pieces (3 types)
- Misc hostile/neutral (21 types)

---

### 3. HUD / UI Elements
**Current Status:** Not yet implemented (Section 12 pending)

**Requirements (when implemented):**
- [ ] Cooldown timer widget (ring, bar, or numeric display)
- [ ] Active ragebait indicator icon
- [ ] Tier unlock notification graphics
- [ ] Stealth mode indicator (Tier 3+)
- [ ] Manual crafting progress bar

**Specifications:**
- Style: Match DST's UI aesthetic (hand-drawn, sketchy outlines)
- Size: Standard HUD widget sizes
- Colors: Use DST color palette (consider red/orange for aggro theme)

---

### 4. Bestiary Screen Assets
**Current Status:** Not yet implemented (Section 13 pending)

**Requirements (when implemented):**
- [ ] Bestiary background frame
- [ ] Creature entry slots (grid or list layout)
- [ ] Locked/unlocked creature icons
- [ ] Tier progression bar graphics
- [ ] Recipe display panel

**Specifications:**
- Layout: Full-screen or panel-style (TBD)
- Integration: Should fit DST crafting menu style

---

### 5. World Effects / Indicators
**Current Status:** Not yet implemented (Section 14 pending)

**Requirements (when implemented):**
- [ ] Taunted enemy indicator (icon, aura, or overhead symbol)
- [ ] Ally buff indicator (icon above buffed allies)
- [ ] Ragebait activation visual effect (FX on staff use)
- [ ] Stealth mode visual effect (transparency, shimmer, speed trail)

**Specifications:**
- Taunted Indicator: Should be visible to all players, clear "this enemy is targeting someone" visual
- Effects: Particles, glows, or symbols (DST supports .tex/.xml particle systems)

---

### 6. Sound Effects (SFX)
**Current Status:** Not implemented (placeholders support is ready but no custom sounds added)

**Requirements:**
- [ ] Ragebait activation sound (staff attack hit)
- [ ] Ragebait success sound (taunt applied successfully)
- [ ] Ragebait fail sound (activation blocked/failed)
- [ ] Ragebait interrupt sound (hit cancels buff)
- [ ] Tier unlock sound (achievement-style chime)
- [ ] Manual craft sound (book/scroll crafting)
- [ ] Cooldown ready sound (subtle notification)

**Specifications:**
- Format: `.fsb` (FMOD sound bank) + event definitions
- Volume: Should not overpower vanilla game sounds
- Style: Fantasy/medieval theme consistent with DST

---

### 7. Animations / FX
**Current Status:** Not implemented (placeholders in place)

**Requirements:**
- [ ] Ragebait activation particle effect
- [ ] Stealth mode shimmer/fade animation
- [ ] Tier unlock celebration effect
- [ ] Manual crafting animation (if custom needed)

**Specifications:**
- Format: `.zip` animation builds + atlas textures
- Integration: Via DST's `AnimState` system

---

## Priority Ranking

**Phase 1 - Core Gameplay (High Priority):**
1. Ragebait Staff (inventory icon + animation)
2. Manual base design (single texture is acceptable for initial release)
3. Ragebait activation sound

**Phase 2 - Polish (Medium Priority):**
4. Distinct manual icons per creature (or per category)
5. HUD widgets (cooldown timer, active indicator)
6. Taunted enemy indicator

**Phase 3 - Full Release (Lower Priority):**
7. Bestiary screen full artwork
8. Complete SFX suite
9. Particle effects and animations
10. Stealth/ally buff visual effects

---

## File Locations Summary

**Placeholder References:**
- `anirvan/data/ragebait_assets.lua` - Centralized asset path definitions
- `anirvan/scripts/prefabs/ragebait_staff.lua` - Staff item visuals
- `anirvan/scripts/prefabs/ragebait_manual_base.lua` - Manual item visuals

**Where to Add Final Assets:**
- Animations: `anirvan/anim/`
- Textures: `anirvan/images/inventoryimages/`
- Sounds: `anirvan/sound/` (if custom SFX added)
- FX: `anirvan/fx/` (for particle effects)

**How to Replace:**
1. Update paths in `ragebait_assets.lua`
2. Add new files to appropriate directories
3. Update `Assets` table in `modmain.lua` to preload new assets
4. Test in-game to verify assets load correctly

---

## Current Placeholder Strategy

All placeholders are using vanilla DST assets with TODO comments marking replacement points:
- `TODO: Replace with custom ragebait_staff animation`
- `TODO: Replace with ragebait_manual icon per creature`
- `TODO: Create distinct textures per manual category`

**Search for TODO comments:**
```bash
grep -r "TODO" anirvan/scripts/prefabs/
grep -r "TODO" anirvan/data/ragebait_assets.lua
```

This approach allows the mod to function 100% with vanilla assets for testing, while providing clear markers for art team integration.
