# Spark

A delightful, touch-first learning app for children in Kindergarten through 5th grade.

Spark helps kids explore **English, Math, and Science** through beautiful interactive experiences, guided by three lovable companions.

## The Heroes

- **Flint** — Energetic, bold, and full of excitement. Loves big reactions and experiments.
- **Pebby** — Warm, gentle, and encouraging. A kind companion who collects "knowledge pebbles" with the child.
- **Lumi** — Calm, curious, and full of wonder. Speaks in thoughtful questions and helps children slow down and observe.

Each child chooses their own hero during onboarding. The chosen companion stays with them throughout their learning journey.

## The Story

Behind the learning is a gentle background narrative called **The Dimming Shimmer** — a living crystal world that is slowly losing its light. The three heroes believe that when children deeply explore and understand the world around them, they create tiny "Echoes" of wonder that can help restore light to their home.

Most of the time, this story stays in the background. But attentive children will start noticing small, beautiful moments (called Echo Fragments) that hint at something bigger.

## Current Features

- **Hero Selection & Onboarding** — Children pick their companion and create a profile.
- **Color Mixing Lab** (First Science Experiment)
  - Real drag-and-drop interaction using Skia
  - Prediction phase ("What do you think will happen?")
  - Gentle story moments and reflection
  - "I noticed something" discovery saving

## Tech Stack

- **React Native + Expo SDK 56** (with file-based routing)
- **@shopify/react-native-skia** — High-performance 2D graphics for experiments
- **react-native-reanimated + react-native-gesture-handler** — Smooth interactions
- **@rive-app/react-native** — For future animated hero characters
- **NativeWind (Tailwind)** — Styling
- **Zustand + expo-sqlite** — State and local persistence
- **EAS Build** — Cloud builds for iOS and Android development clients

## Project Goals

- Create genuinely joyful, tablet-first learning experiences
- Use meaningful interactivity (especially in science)
- Weave in a light, emotional background story without making it feel like a game
- Support both iOS and Android with excellent touch and gesture support

## Getting Started

```bash
cd spark
npm install
npx expo start
```

For the best experience (especially the Skia-based experiments), use a **development build** instead of Expo Go.

## Development

This project uses a custom development client. See `eas.json` for build profiles.

```bash
eas build --platform ios --profile development
eas build --platform android --profile development
```

## License

Private project.

---

Built with care for curious kids.
