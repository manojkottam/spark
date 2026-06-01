# Handoff: Freemium Model + Journey Map (June 2026)

> **Note for the receiving agent**: The user has reviewed the current build on a real iPad and is not satisfied with the visual design and overall appeal. They have decided to continue development with another agent. This handoff focuses on preserving the strong functional and story direction while clearly documenting the visual gaps.

## Summary of What Was Built

We implemented a **simple one-time purchase freemium model** for Spark:

- **Free tier**: The first lab in each of the 6 Learning Tracks is playable without purchase.
- **Full Unlock**: One-time purchase ("Unlock the Full Story") that opens every lab, every track, all Major Echo Moments, and the complete emotional ending.

This replaced earlier ideas of per-track purchases or subscriptions.

## Key Design Decisions

- **Model**: "Free play then buy to unlock all" (single global unlock, no subscription).
- The **Journey Map** is now the primary visual and navigational surface for discovering content.
- Light branching (`isExperimentUnlocked`) is kept only as **guidance/recommendation** inside owned content. The hard gate is `canAccess()`.
- Tone: Magical and non-pushy. The unlock sheet and map messaging stay in the story voice.
- Real-device contrast fixes were applied after iPad testing (the original very light "paper" aesthetic washed out on hardware).

---

## Visual Design & Polish Status (High Priority Open Item)

**Important note for the next agent:** The functional architecture, story systems, and freemium model are in good shape. However, the **current visuals are not appealing** on real hardware (especially iPad). The user did a full visual inspection on device and explicitly stated that the visuals are not working.

### Current Problems (as reported on real iPad)
- The app feels very "light" and washed out from the first screen.
- `sparkBackground` (very pale warm off-white) + heavy use of `Color.white` (or semi-transparent white) cards creates extremely low contrast.
- Text (especially secondary text and labels) becomes hard to read.
- Cards and sections blend into the background rather than feeling like distinct, delightful elements.
- The overall aesthetic does not yet feel magical, premium, or particularly appealing to K-5 kids and their parents.
- The app currently feels like a blown-up iPhone experience on iPad rather than a well-designed tablet experience.

### What Was Attempted in This Session
- Slightly darkened `sparkBackground` (from ~0.97 to 0.95 lightness).
- Added subtle black borders (`opacity 0.05–0.06`) to most white cards and sections for better separation.
- Increased opacity on some semi-transparent cards (e.g. in JourneyMapView).
- Strengthened shadows on key elements like the hero dialogue bubble.

These were quick code-level contrast fixes. They helped somewhat but did **not** solve the fundamental visual appeal issue.

### Recommended Approach for the Next Agent
This work needs proper **design direction** rather than more incremental code tweaks. Suggested priorities:

1. **Establish a stronger visual foundation**
   - Create a proper design system with more intentional color palette (deeper backgrounds, richer accents, better use of the three hero colors).
   - Define clear card/component hierarchy with stronger elevation, borders, or textures.
   - Review typography scale and weight usage for better readability on device.

2. **Re-think the core aesthetic**
   - The current "warm paper" look is too subtle and flat on real screens.
   - Consider richer crystal/shimmer materials, more deliberate use of hero-colored tints, or a slightly deeper base background.
   - The Journey Map in particular needs to feel like an exciting world to explore, not a flat list of paths.

3. **iPad-specific design**
   - The app currently does not take advantage of the larger screen.
   - Cards feel too narrow, spacing is not optimized, and the overall experience needs breathing room and better visual rhythm on iPad.

4. **Key screens that need the most attention**
   - **Adventure Hub** (first screen users see after onboarding) — currently the most important impression.
   - **Journey Map** — this is now the flagship navigation surface and needs to feel special.
   - **Unlock Full Story** sheet — should feel like a delightful, high-value moment rather than a standard purchase screen.
   - Lab cards and `ExperimentDetailView` flows.
   - Onboarding / Hero Selection (first impression).
   - `ClimaxView` and Major Echo celebration moments (these should feel magical).
   - Animated hero presence and particle effects (shimmer intensity, sparkle behavior).

5. **Technical recommendations**
   - Consider introducing more sophisticated shadow/elevation system or subtle textures.
   - Review all places using `Color.white` or high opacity white — these are the main culprits of the washed-out feel.
   - Test extensively on real iPad hardware (not just simulator), in different lighting conditions.
   - Consider adding a few high-quality custom illustrations or icon treatments for the crystal world theme.

The direction (story-first, emotional ending, living heroes, meaningful progression via the map) is solid and worth preserving. The visuals just need a dedicated design pass to match that ambition.

---

## Data Model Changes

### Experiment.swift
```swift
let isFree: Bool
```
- First lab of every track is marked `isFree: true`.
- All others default to `false`.

### ChildProfile.swift (SwiftData)
```swift
var hasFullUnlock: Bool = false
```
- Set to `true` when the user purchases the full story.
- Persisted automatically.

### LearningProgress.swift
New primary method:
```swift
func canAccess(_ experiment: Experiment) -> Bool
```
- Returns `true` if `hasFullUnlock` OR `experiment.isFree`.
- `isExperimentUnlocked()` is now secondary guidance only.

## Major New UI

### JourneyMapView (new)
- Located at `Spark/Sources/Features/Story/JourneyMapView.swift`
- Visual representation of all 6 tracks as horizontal "paths".
- Free labs are bright and tappable.
- Locked labs are dimmed with "Unlock" affordances that open the purchase sheet.
- Automatically shows different messaging when the user has the full unlock.
- Integrated as a top-level destination from the Adventure Hub ("Journey Map" button).

### UnlockFullStoryView (new)
- Located at `Spark/Sources/Features/Story/UnlockFullStoryView.swift`
- Beautiful, story-aligned one-time purchase sheet.
- Lists benefits (all labs, Major Echoes, full ending).
- Currently simulates purchase (sets `hasFullUnlock = true` with success animation).
- Hero immediately reacts with a personalized line when the sheet is dismissed after unlock.

### Hub Integration (MainAppView)
- When `!hasFullUnlock`, a prominent "The full story of The Shimmer is waiting" teaser card appears near the world state.
- Tapping it presents the unlock sheet.
- "Journey Map" is now one of the primary navigation buttons.

### Lock States
- Updated in `TrackSection.swift` and inside `JourneyMapView`.
- Tapping locked content surfaces the unlock flow.

## Hero Personality on Unlock
Added `getFullUnlockLine(for:)` in `HeroDialogueSystem.swift`:
- Flint: Excited / energetic
- Pebby: Warm / grateful
- Lumi: Poetic / profound

This line appears in the Hub dialogue bubble shortly after a successful unlock.

## Visual / Contrast Fixes (Post iPad Testing)
- Darkened `sparkBackground` slightly for better real-device contrast.
- Most white cards now have subtle borders (`Color.black.opacity(0.05)`) in addition to shadows.
- Journey Map track sections and several Hub cards were strengthened.
- Hero dialogue bubble received stronger separation.

These changes were made after the user reported the app was "very light" and hard to read on a real iPad.

## How to Test Right Now

1. Run the app (no profile → go through onboarding).
2. On the Adventure Hub you should see the unlock teaser.
3. Tap "Journey Map" — free labs are open; others show Unlock buttons.
4. Tap any locked lab or the Hub teaser → beautiful unlock sheet appears.
5. "Purchase" (simulated) → hero reacts, map and all labs become available.

There is currently no in-app purchase UI — the sheet directly sets the flag. Real StoreKit can be wired later.

## Files Changed / Added (Key Ones)

**New:**
- `FREEMIUM_AND_JOURNEY_MAP_HANDOFF.md` (this document)
- `Spark/Sources/Features/Story/JourneyMapView.swift`
- `Spark/Sources/Features/Story/UnlockFullStoryView.swift`
- `Spark/Sources/Features/Story/` directory (now contains Climax + unlock + map)

**Modified (core logic):**
- `Spark/Sources/Core/Models/Experiment.swift` (added `isFree`)
- `Spark/Sources/Core/Models/ChildProfile.swift` (added `hasFullUnlock`)
- `Spark/Sources/Core/Services/LearningProgress.swift` (added `canAccess`)
- `Spark/Sources/App/MainAppView.swift` (Hub integration + unlock sheet + contrast)
- `Spark/Sources/Features/Experiments/TrackSection.swift` (lock visuals)
- `Spark/Sources/DesignSystem/SparkDesign.swift` (background contrast)
- Multiple lab views (minor wiring for consistency)
- `xcodegen.yml` (iPad support + Info.plist generation fixes)

## Open / Next Steps (Recommended Order)

1. **Real monetization**
   - Wire StoreKit for the one-time "Full Story" purchase.
   - Add receipt validation / restore purchases.
   - Store the purchase state in `hasFullUnlock`.

2. **Map polish**
   - Make tapping a free lab node navigate directly to the lab (currently visual only).
   - Add unlock celebration animation when full content is purchased from the map.
   - Consider a "world light up" effect across the map when `hasFullUnlock` becomes true.

3. **Story gating**
   - Decide whether the Climax / ending should be strictly behind full unlock (currently still reachable for testing).
   - Update "The Shimmer Calls" teaser logic accordingly.

4. **iPad / visual refinement**
   - The app now runs on iPad but still feels very "iPhone blown up" in many places.
   - Consider larger cards, better use of space, or split view in the map for iPad.

5. **Minor**
   - Re-add a clean debug toggle (now that the real sheet exists) if needed during development.
   - Update InsightsView to mention free vs full content status for parents.

## Notes for Future Work

- The model is deliberately simple. We avoided per-track purchases and subscriptions per the latest direction.
- All Major Echo Moments and the emotional ending are intended to be part of the paid experience.
- The map is meant to feel like "the world opening up" once the user unlocks — lean into that thematically when adding animations.

---

**This handoff captures the state as of early June 2026.** The core freemium plumbing, Journey Map, and unlock experience are functional and tested on device.

If you have questions about any specific file or flow, the code is reasonably well-commented in the new views and the access logic layer.

Good luck with the next phase!