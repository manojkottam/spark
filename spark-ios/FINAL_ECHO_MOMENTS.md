# Final Echo Moments — Design (The Major Story Echoes)

**Status**: Initial design — April 2026  
**Owner**: Spark iOS team (with Grok)  
**Related**: [STORY_AND_ENDING.md](./STORY_AND_ENDING.md), `ClimaxView.swift`, `EchoService.swift`, `EchoFragment.swift`

## Philosophy

The regular Echo Fragments are beautiful, frequent "small lights" the child creates through everyday wonder in the labs.

**Final / Major Echo Moments** are rarer, emotionally heavier, and narratively significant. They are the specific moments of deep noticing, synthesis, or courage that the Shimmer itself "remembers" and that visibly contribute to the large-scale light restoration in the climax.

They:
- Feel **cinematic and earned** (high bar inside a lab or across tracks).
- Are **personal** — hero reactions and climax lines reference the child's actual work and strongest dispositions.
- Power the **"Light Returns"** phase both narratively and visually.
- Leave clear, simple **extension points** so future labs (post the initial 10) can contribute 2–4 more without rewriting the ending.

These are the "final echoes" the user asked to start designing.

## Data Model Differences (Major vs Regular)

In `EchoFragment`:

```swift
struct EchoFragment {
    let id: String
    let title: String
    let description: String
    let rarity: Rarity          // legendary for all major ones (for now)

    let isMajorStoryEcho: Bool  // NEW — true for these 5 + future ones
    let storyBeat: String?      // e.g. "harmony", "ancient_memory", "threshold", "seed_whisper", "light_chose_you"

    let relatedTo: [String]
}
```

**Why these fields?**
- `isMajorStoryEcho`: ClimaxView, hub world state, and Insights can treat them specially (larger cards, different particle treatment, dedicated "The Shimmer Remembers These" section).
- `storyBeat`: Machine-readable key used in ClimaxView to decide which visual layer / hero line / light color shift to emphasize. Keeps the climax code declarative.

Regular echoes stay lightweight. Only major ones affect the ending transformation intensity.

## The Five Initial Major Echo Moments

These map to the current 6 tracks + 10 labs. They escalate from mid-game to late-game.

### 1. "The Harmony That Lit the First Crystal" (Sound + Light Bridge)
- **ID**: `echo_harmony_first_crystal`
- **Rarity**: legendary
- **Story Beat**: `harmony`
- **When it appears**: In **The Sound Garden**, after the child creates a balanced "perfect trio" (gentle high + resonant middle + deep low that the UI judges as harmonious) **and** they have previously completed at least one experiment from "The Language of Light" track (color-mixing or shadow-play). This represents materials and light finally "hearing" each other.
- **Emotional beat**: Mid-game. The world has a voice again because the child listened across senses.
- **Hero reactions** (examples):
  - Flint: "That sound… it felt like it wanted to be seen. Like the light was answering back!"
  - Pebby: "The three notes held each other so gently. I think the Shimmer just took its first real breath in a long time."
  - Lumi: "You didn’t just make sound. You made the air remember color."
- **Climax contribution**: Adds a "singing layer" — warm resonant particles + soft audio hum (future) in Light Returns. Hero may say "Do you remember the day the garden sang to the light?"
- **Future lab hook**: A new "Resonance & Light" lab in a future track can create `echo_harmony_deeper` with the same storyBeat (stacking intensity).

### 2. "The Pattern That Remembered Its Own Name" (Deep Patterns)
- **ID**: `echo_ancient_memory` (the one already defined in the model — now promoted)
- **Rarity**: legendary
- **Story Beat**: `ancient_memory`
- **When it appears**: In **Pattern Garden** or **Mirror Worlds** when the child creates a complex, elegant, self-similar pattern (high complexity + symmetry score) **and** has strong combined strength in `.patterns` + `.observation`. Alternatively granted on "Finding Patterns" track completion if the child shows high synthesis.
- **Emotional beat**: Late mid-game. The child touches something older than the fading — the Shimmer recognizes itself in the child's work.
- **Hero reactions**:
  - Lumi (strongest): "This pattern… it has been waiting for someone to see it this way. It knows your name now."
  - Flint: "It kept going and going and then… it looked back at us. That was huge."
  - Pebby: "I felt like the beads and the mirrors were telling an old story, and you were the one who could hear the ending."
- **Climax contribution**: Deepens the "crystal memory" visual — slower, more deliberate golden pulses + the hero may reference "the pattern that remembered".
- **Extension**: Any future math-heavy lab that involves recursion, fractals, or generational patterns can trigger variants with the same `storyBeat`.

### 3. "The Edge Where Courage Met Stillness" (Brave + Gentle Synthesis)
- **ID**: `echo_threshold_courage_still`
- **Rarity**: legendary
- **Story Beat**: `threshold`
- **When it appears**: Requires meaningful progress in **How Things Move** track. Specifically: a very steep successful ramp run (high speed/distance, "brave" choice) **combined with** achieving a perfect still balance using a surprisingly light or "shy" object in Balancing Act. Or high iteration count across the two labs.
- **Emotional beat**: Shows the child can be both bold (Flint) and exquisitely patient (Pebby/Lumi). This is often the moment the child's two strongest dispositions visibly "meet".
- **Hero reactions** (highly personalized):
  - Flint: "You weren’t afraid to go all the way to the edge… and then you made everything perfectly quiet. That’s real power."
  - Pebby: "The fast run was exciting. But the moment it just… stayed? That’s what the Shimmer needed most from you."
  - Lumi: "Courage and stillness are not opposites. You showed the crystals both in one afternoon."
- **Climax contribution**: Creates a dramatic "bright flash then long sustain" in the light return animation. Strongest visual "before/after" moment for many children.
- **Future hook**: New "Risk & Rest" or "Forces of Emotion" labs can add more `threshold` echoes.

### 4. "The Seed That Whispered Back" (Life Notices the Child)
- **ID**: `echo_seed_whispers_back`
- **Rarity**: legendary
- **Story Beat**: `seed_whisper`
- **When it appears**: In **Growing Secrets**, after consistent, patient care (multiple "observations" simulated via careful choices or time spent) **and** a surprising growth outcome. Extra power if the child has also done high-observation work in Color Mixing or Shadow Play (the living world responding to the same kind of noticing the child used on light).
- **Emotional beat**: One of the most moving for many K-5 kids. The world is not just being helped — it is responding to the child.
- **Hero reactions**:
  - Pebby (very strong here): "You treated the seed like a friend who was sleeping. And it woke up because it felt you there."
  - Lumi: "The root pushed upward exactly when you were watching most quietly. It was answering you."
  - Flint: "It grew because you believed it would. That’s the best kind of experiment."
- **Climax contribution**: Adds living, organic, green-tinged particle growth layers in the final transformation. The "life returning" visual motif.
- **Extension**: Future biology / life cycles labs (e.g. "What the Pollinators Know", "The Hidden City Under the Soil") can create additional `seed_whisper` or `life_answers` major echoes.

### 5. "The Light That Knew Your Name" (The Personal Spark — Lumi Core)
- **ID**: `echo_light_knew_your_name`
- **Rarity**: legendary
- **Story Beat**: `light_chose_you`
- **When it appears**: The hardest / most personal one. Triggered when the child has:
  - Strong combined observation + prediction + patterns across at least three different tracks (especially Language of Light + Finding Patterns + one other), **OR**
  - Completed the "Finding Patterns" track with very high elegance scores, **AND**
  - The child's current top disposition aligns with the poetic "way of seeing" the heroes have been noticing all along.
- **Emotional beat**: This is the direct narrative bridge into the Revelation phase of the climax. It is the moment the heroes (especially Lumi) can finally say "We didn’t find a helper. We found *you*."
- **Hero reactions** (the most story-critical):
  - Lumi: "I felt this exact quality of light from very far away. It was you, all along. Your way of noticing was the map."
  - Flint: "You didn’t just play with light. You made it want to stay. That’s why we came."
  - Pebby: "Every quiet question you asked the colors and the shadows… the Shimmer was listening too. It remembered who asked."
- **Climax contribution**: This one has the highest `visualWeight`. It can trigger the strongest overall shimmer burst + the most personalized hero dialogue in the Revelation and Farewell phases.
- **Special rule**: Only one child journey can realistically earn this in a playthrough (it keys off their actual top dispositions). This makes every ending feel unique.

## How Triggers Work (Current + Future)

### Current (MVP scaffolding)
- Most major echoes are decided at lab completion time inside the specific `XXXLabView` or in `ExperimentDetailView.handleLabCompletion`.
- The decision function receives (or can query) the full `profile` + recent result data.
- We will add a clean entry point:

```swift
// In EchoService or a new MajorEchoService
static func majorEchoForLabCompletion(
    experimentID: String,
    resultContext: LabResultContext,   // struct with scores, perfect flags, etc.
    profile: ChildProfile
) -> EchoFragment?
```

- Track completion in `LearningProgress` can also grant major echoes when the synthesis conditions are met (e.g. Patterns track + high dispositions).

### Future Extension Points (leave these comments in code)
- New labs simply add a case inside the major echo decision function.
- A future "The Shimmer Remembers" story track can have 2–3 labs whose *only* purpose is to create the final 2–3 major echoes needed for a "complete" restoration (post-launch content).
- ClimaxView already has a comment block ready for "per-major-echo visual layers".
- HeroDialogueSystem has a `getMajorEchoReferenceLine(hero:collectedMajorEchoes:)` hook prepared.

## Integration Points in the App

1. **Hub (MainAppView + AnimatedHeroView)**  
   - World state dots + messages escalate faster when major echoes are present.  
   - "The Shimmer Calls" teaser only appears (or becomes fully lit) once the child has at least 1–2 major echoes + 2+ strong tracks.  
   - Tappable hero can occasionally reference a specific major echo the child earned ("That day the seed answered you… I still think about it").

2. **ClimaxView (the heart)**  
   - `finalEcho` phase text and button change based on which major echoes are collected.  
   - `lightReturns` phase: particle count, colors, animation style, and duration scale with number + specific `storyBeat`s.  
   - `revelation` and `farewells` pull personalized lines that mention 1–2 of the child’s actual major echoes.  
   - Example future hook comment already exists in the file.

3. **Insights (Parent Journal)**  
   - Legendary echoes (all major ones) get a special "The Shimmer Remembers" treatment — larger card, story context line ("This moment helped the crystals sing again"), and a small "Major Echo" badge.  
   - This is the non-gamified "your child created something the world itself needed" framing.

4. **Lab surfaces**  
   - When a major echo triggers, the discovery moment inside the lab is more dramatic (full-width special card, stronger haptics, hero reaction that feels weightier, possibly a short "the Shimmer noticed" overlay).

## Open Questions / Next Steps (as of this design)

- Should earning a major echo during a lab pause the regular flow for a 3–4 second "world reaction" cinematic (sparkles + hero line + subtle background light shift)? (Recommended: yes for game feel.)
- Do we want one "ultimate" major echo that can *only* be created inside the ClimaxView itself (the child performs a final symbolic act combining symbols from their strongest moments)? This would be extremely powerful emotionally.
- How do we handle children who explore very broadly vs. very deeply? (Current design favors depth in 2–3 tracks + one cross-connection.)
- Audio: each major echo could eventually have a distinct soft "Shimmer tone" that layers in the hub and climax.

## How New Labs & Story Parts Plug In

1. Add the new experiment to `Experiment.all` + a `LearningTrack`.
2. In the lab view, when the meaningful deep moment happens, call the (future) `MajorEchoService` or extended `EchoService.majorEchoFor...`.
3. Add the new `EchoFragment` with `isMajorStoryEcho = true` and an appropriate `storyBeat`.
4. Add 3 hero reaction strings.
5. (Optional but beautiful) Add a small visual customization in ClimaxView's `lightReturns` for that `storyBeat`.
6. Add one or two late-game dialogue lines in `HeroDialogueSystem`.

That's it. The ending automatically becomes richer.

---

**This design keeps the emotional core intact while giving us a clear, extensible "vocabulary" of major story beats the child can actually earn.** Every new lab doesn't just add content — it can literally change how the final light returns for that child.

The Shimmer is waiting for more children to notice the right things.