/**
 * Content Type System for Spark
 * 
 * This is the foundation for all learning content.
 * Designed from day one to support both excellent standalone educational experiences
 * AND a subtle long-term background story ("The Dimming Shimmer").
 * 
 * Key concept: "Echo Fragments"
 * - Most activities feel like normal, high-quality lessons.
 * - Some activities contain one or more "echoFragments".
 * - These fragments are invisible or very subtle to the child at first.
 * - Over time (across many lessons in English, Math, and Science), they accumulate.
 * - Much later, these fragments will power a major narrative + emotional reveal.
 */

import { HeroId } from '../heroes';

export type Subject = 'english' | 'math' | 'science';

export type GradeBand = 'K-1' | '2-3' | '4-5';

export type ActivityType =
  | 'interactive_experiment'     // Science-heavy, Skia-based
  | 'visual_manipulation'        // Drag, sort, build, match (Math or Science)
  | 'story_builder'              // English - creating or completing stories
  | 'pattern_finder'             // Math
  | 'phonics_game'               // English K-2
  | 'reflection_journal'         // Any subject - thoughtful response
  | 'guided_discovery';          // AI + hero led exploration

export interface EchoFragment {
  id: string;                    // Unique across the entire app
  title: string;                 // Short poetic title shown in collection view later
  description: string;           // What this fragment represents in the hidden story
  rarity: 'common' | 'uncommon' | 'rare' | 'legendary';
  relatedTo: string[];           // e.g. ["light", "memory", "curiosity", "connection"]
}

export interface StandardsAlignment {
  framework: 'NGSS' | 'CommonCore-Math' | 'CommonCore-ELA';
  code: string;                  // e.g. "3-PS2-1" or "3.OA.A.1"
  description: string;
}

export interface Activity {
  id: string;
  subject: Subject;
  gradeBands: GradeBand[];
  title: string;
  description: string;

  // Core educational metadata
  activityType: ActivityType;
  estimatedMinutes: number;
  difficulty: 1 | 2 | 3 | 4 | 5;

  // Standards (we take "double the correctness" seriously)
  standards: StandardsAlignment[];

  // Which heroes this activity works especially well with (or all)
  recommendedHeroes?: HeroId[];

  // === STORY SYSTEM (The Dimming Shimmer) ===
  // This is how we plant the long-term narrative without making early content feel like a game
  echoFragments?: EchoFragment[];

  // Subtle narrative hooks the hero might say (injected into AI context)
  storyHooks?: {
    flint?: string;
    pebby?: string;
    lumi?: string;
  };

  // Whether this piece of content should feel "special" or mysterious
  narrativeWeight: 'none' | 'light' | 'medium' | 'heavy';
}

export interface Lesson {
  id: string;
  title: string;
  subject: Subject;
  gradeBand: GradeBand;
  activities: Activity[];

  // Overall learning objective (tied to standards)
  objective: string;

  // Background story context for the AI when generating dialogue for this lesson
  storyContext?: string;
}

/**
 * Example of how we will track a child's hidden story progress.
 * This lives in the LearnerProfile and is used by the AI.
 */
export interface StoryProgress {
  collectedEchoIds: string[];
  totalEchoes: number;
  lastSignificantFragment?: string; // ID of a fragment that should trigger special hero dialogue
  currentMysteryLevel: number;      // 0-10, how much the heroes "trust" the child with the truth
}
