/**
 * Echo Fragments - The Dimming Shimmer
 *
 * These are the gentle story seeds we will plant throughout the app
 * from the very first piece of content.
 *
 * Philosophy (per user):
 * - Gentle hints, not heavy-handed
 * - Plant from the very beginning
 * - Most children will just enjoy the learning
 * - Attentive or repeat players will start noticing patterns and beauty
 *
 * Each fragment has a soft, poetic quality. They feel like small gifts
 * rather than "collectibles".
 */

import { EchoFragment } from './types';

export const echoFragments: EchoFragment[] = [
  {
    id: 'echo_first_spark',
    title: 'The First Spark',
    description: 'That tiny moment when something suddenly makes sense. The Shimmer remembers these.',
    rarity: 'common',
    relatedTo: ['curiosity', 'aha'],
  },
  {
    id: 'echo_listening_stone',
    title: 'A Listening Stone',
    description: 'When you slow down and truly watch what happens. The crystals lean in closer.',
    rarity: 'common',
    relatedTo: ['observation', 'patience'],
  },
  {
    id: 'echo_two_lights',
    title: 'Two Lights Touching',
    description: 'When an idea from one place connects to an idea from somewhere else.',
    rarity: 'uncommon',
    relatedTo: ['connection', 'patterns'],
  },
  {
    id: 'echo_quiet_question',
    title: 'The Quiet Question',
    description: 'The soft wondering that comes after an experiment doesn’t go as expected.',
    rarity: 'uncommon',
    relatedTo: ['wonder', 'resilience'],
  },
  {
    id: 'echo_hand_held',
    title: 'A Hand Held Out',
    description: 'When you help someone else see what you saw. The light grows between you.',
    rarity: 'uncommon',
    relatedTo: ['teaching', 'generosity'],
  },
  {
    id: 'echo_hidden_glow',
    title: 'The Hidden Glow',
    description: 'Something that was always there, but only becomes visible when you look in just the right way.',
    rarity: 'rare',
    relatedTo: ['discovery', 'perspective'],
  },
  {
    id: 'echo_many_voices',
    title: 'Many Voices, One Light',
    description: 'When different ways of thinking come together and something new appears.',
    rarity: 'rare',
    relatedTo: ['collaboration', 'diversity'],
  },
  {
    id: 'echo_ancient_memory',
    title: 'An Ancient Memory',
    description: 'A feeling that this pattern, this idea, this wonder… has existed for a very long time.',
    rarity: 'legendary',
    relatedTo: ['deep_time', 'belonging'],
  },
];

/**
 * Helper to get a fragment by ID.
 * We will use this when attaching fragments to activities.
 */
export function getEchoFragment(id: string): EchoFragment | undefined {
  return echoFragments.find((f) => f.id === id);
}

/**
 * Gentle story flavor text per hero.
 * These can be used in AI prompts or as subtle dialogue the hero might say
 * when an Echo Fragment is collected.
 */
export const heroEchoReactions = {
  flint: {
    common: "Whoa… did you feel that little flash? Something just lit up!",
    uncommon: "Hey… that one felt different. Like it mattered more than usual.",
    rare: "Okay. That one was special. I don’t know why yet… but it was.",
  },
  pebby: {
    common: "Oh… that was a lovely little pebble. I think we should keep it safe.",
    uncommon: "Friend… I felt something warm when you did that. Did you feel it too?",
    rare: "I think… this one has been waiting for someone like you to find it.",
  },
  lumi: {
    common: "The light leaned toward you just now. I wonder what it heard.",
    uncommon: "Some crystals only glow when the right question is asked. You just asked one.",
    rare: "…This one remembers you. I don’t know how that’s possible yet.",
  },
} as const;
