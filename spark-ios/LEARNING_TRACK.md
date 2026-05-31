# Spark Learning Track Architecture

## Guiding Principles (from team direction)

- **Open exploration first**, with light "gate checks" for knowledge/insight rather than heavy quizzes.
- Color Mixing Lab is the **first of many** experiments (Science + Math).
- **Parents get a dashboard** showing their child's strength areas.
- Personalization is driven primarily by:
  - Chosen Hero (personality lens)
  - Grade (developmental appropriateness + complexity)
- The experience should feel like **wonder-driven discovery**, not curriculum.

## Core Model: Learning Dispositions

We track development across six core dispositions. These are the "strength areas" shown to parents and used to personalize recommendations and hero reactions.

| Disposition              | Short Label   | What it means                              | Example behaviors we celebrate |
|--------------------------|---------------|--------------------------------------------|--------------------------------|
| Observation              | Observation   | Noticing fine details and subtle changes   | "I saw the edges turn purple first" |
| Prediction & Wondering   | Prediction    | Forming thoughtful expectations            | "I think it will turn green because..." |
| Experimentation & Iteration | Iteration  | Trying, adjusting, and learning from results | Repeating an experiment with a small change |
| Pattern Recognition      | Patterns      | Finding relationships and structure        | "It always happens when we do this..." |
| Quantitative Thinking    | Numbers       | Working with measurement, comparison, quantity | "This one needed three more blocks" |
| Wonder & Connection      | Connections   | Linking ideas and seeing bigger pictures   | Connecting an experiment to the Shimmer story or another experience |

These are **not** traditional academic skills. They are habits of mind we want to strengthen.

## Content Model: Experiments (Labs)

Every piece of interactive content is an `Experiment`.

Key properties:
- `domain`: Science or Math (expandable later)
- `primaryDispositions` + `secondaryDispositions`
- `suggestedGradeRange`
- `baseComplexity` (1–5)
- `supportsEchoFragments` (story integration)

Experiments are designed once, then experienced through the **Hero + Grade Lens**:
- The hero changes tone, focus, and which dispositions they highlight.
- Grade subtly changes language complexity, number of variables, and depth of reflection.

## Multiple Entry Points Strategy

### Primary Experience (Open with Light Structure)
- Kids mostly browse and choose experiments freely.
- Hero + current strengths influence what surfaces in "Recommended for you".
- Gentle daily/periodic suggestions ("Your hero thinks you might like this today").

### Light Gate / Insight Checks
Instead of traditional quizzes, we use low-pressure "Insight Moments":
- After meaningful experiments, the hero might ask 1–2 gentle questions.
- These are framed as "I'm curious what you noticed..." rather than tests.
- Correct/insightful answers strengthen the relevant dispositions.
- Wrong or uncertain answers are treated as interesting data (more iteration opportunity), never failure.

### Parent Dashboard (Future)
Parents will see:
- Top 2–3 strength areas for their child (with warm, non-comparative language).
- Recent experiments and which dispositions they exercised.
- Gentle suggestions for experiences that would stretch growth areas.

## Hero Personalization

Each hero has natural affinities:
- **Flint**: Strong on Iteration + Prediction (bold experimentation)
- **Pebby**: Strong on Observation + Connection (gentle noticing + stories)
- **Lumi**: Strong on Observation + Patterns + Wonder (poetic attention to detail)

When a child has a chosen hero, that hero becomes their primary companion and subtly biases which dispositions get attention and celebration.

## Recommended Next Implementation Steps

1. **Foundation** (Current)
   - Define `LearningDisposition` and `Experiment` models ✓
   - Light strength tracking on `ChildProfile`

2. **First Real Lab** 
   - Build Color Mixing Lab with disposition tagging
   - Add 1–2 light Insight Checks after the lab

3. **Recommendation Engine (MVP)**
   - Simple scoring: recent experiments + hero affinity + grade
   - "For you" section on the main screen

4. **Parent Dashboard (Phase 1)**
   - Basic view of top dispositions
   - Recent activity with disposition tags

5. **Expansion**
   - Add 4–6 more experiments across Science and Math
   - Introduce light branching / multiple paths within a single experiment

## Team Direction (May 2026)

- **Exploration style**: Mostly open, with light "gate checks" / insight moments to surface understanding (not traditional quizzes).
- **Scope**: Science + Math only for the foreseeable future.
- **Parent experience**: Parents will get a dashboard showing their child's strength areas (based on the dispositions above).
- **First experiment**: Color Mixing Lab is just the first of many. We need a scalable model.

## Current Experiments (as of now)

We currently have the following experiments defined:

| ID                | Title                | Domain   | Primary Dispositions              | Notes |
|-------------------|----------------------|----------|-----------------------------------|-------|
| color-mixing      | Color Mixing Lab     | Science  | Observation, Prediction, Iteration | First lab. Strong hero differentiation. |
| ramp-runners      | Ramp Runners         | Science  | Prediction, Iteration, Quantitative | Excellent for variable testing and hero personality. |
| sound-garden      | The Sound Garden     | Science  | Observation, Prediction, Patterns  | Very strong for Lumi and Pebby. |
| shadow-play       | Shadow Play          | Science  | Observation, Patterns, Connection  | Poetic and visual. |
| balancing-act     | The Balancing Act    | Math     | Prediction, Iteration, Quantitative | Good spatial + measurement crossover. |
| pattern-garden    | Pattern Garden       | Math     | Patterns, Observation, Prediction  | Core math dispositions + creative expression. |
| mirror-worlds     | Mirror Worlds        | Math     | Observation, Patterns, Quantitative | Strong symmetry and spatial reasoning. |
| growing-secrets   | Growing Secrets      | Science  | Observation, Prediction, Patterns   | Long-term observation + living things. |
| attribute-detectives | Attribute Detectives | Math  | Observation, Patterns, Quantitative | Classification and rule-making. |
| pouring-lab       | The Pouring Lab      | Math     | Prediction, Quantitative, Iteration | Volume, conservation, and measurement. |

**Newly Built Labs (this session):**
- Mirror Worlds (symmetry & reflection)
- The Pouring Lab (volume & surprise)
- Pattern Garden (visual pattern building)
- Shadow Play (light & shadows)
- Balancing Act (weight & equilibrium)
- Growing Secrets (plant growth over time)
- Attribute Detectives (sorting & rule making)

We now have **10 fully interactive labs**, all with:
- Prediction phases
- Hero-specific reactions and commentary
- Meaningful interactive mechanics
- Echo Fragment discovery moments
- Disposition tracking for the future parent dashboard

This completes the core set of experiments defined in the model.

Each experiment includes hero-specific approach notes to guide writing and design.

## Design Work Started

We have begun building the in-app discovery experience:

- `ExperimentDiscoveryView` — Main exploration screen
- `ExperimentCard` — Reusable card showing title, hook, dispositions, and recommendation status
- Personalized "Recommended for you" section powered by `LearningProgress`
- Hero-colored accents throughout for consistency with the rest of the app

The goal is to keep the experience feeling open and delightful while still providing smart, hero- and grade-aware recommendations.

We have also begun designing the **Experiment Detail Screen** (`ExperimentDetailView`):

- Strong hero personality voice at the top
- Clear Prediction → Lab → Reflection structure
- Disposition tags prominently shown
- Subtle story/Echo Fragment teaser when relevant
- Light, open tone with room for future Insight Checks

**Real Interactive Content Added** (Color Mixing Lab):
- `ColorMixingLabView` now contains actual interactive content:
  - Prediction phase with hero-flavored suggestions
  - Draggable primary color blobs (Red, Yellow, Blue)
  - Live mixing canvas with color blending
  - Dynamic result with poetic name + description
  - Hero-specific reactions
  - Reflection flow that records practiced dispositions
- Stunning visuals generated with Grok Imagine are prepared for use as:
  - Painterly primary color blobs
  - Beautiful mixed color references
  - Subtle crystal shimmer background layers

This is the first fully interactive lab prototype in the app.

## Open Questions

- How visible should disposition language be to the child themselves? (We currently lean toward keeping it mostly parent-facing.)
- What is the right cadence and tone for Insight Checks?
- How do we surface "recommended" experiments without making the experience feel prescriptive?

---
Last updated: After confirming learning track direction with the team.
