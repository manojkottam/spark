# Spark (Native iOS)

This is the **native iOS** version of Spark, built with Swift and SwiftUI.

## Why Native?

After exploring a React Native + Expo approach, we decided to go fully native for iOS to achieve the highest possible animation quality and "story feel" that the product deserves.

## Current Status

Early scaffolding phase. Xcode project created with XcodeGen. Core models (Hero, EchoFragment, etc.) are defined. UI work has not yet begun.

## Key Product Pillars

- Three heroes with distinct personalities (Flint, Pebby, Lumi)
- Gentle background story: *The Dimming Shimmer*
- High-quality interactive science experiments
- Prediction → Experiment → Reflection loop
- Beautiful, purposeful motion design

## Getting Started (on Mac)

The Xcode project is generated with [XcodeGen](https://github.com/yonaskolb/XcodeGen).

### One-time setup

```bash
# If you don't have XcodeGen installed:
brew install xcodegen
```

### Daily development

```bash
# Regenerate the project after changing xcodegen.yml
xcodegen generate

# Then open in Xcode
open Spark.xcodeproj
```

1. Open `Spark.xcodeproj` in Xcode
2. Select your development team in the **Spark** target (Signing & Capabilities tab)
3. Choose an iPad or iPhone simulator and run

> **Note**: The project targets **iOS 17.0+** and supports both iPhone and iPad.

## Architecture

See `ARCHITECTURE.md` and `NATIVE_IOS_PLAN.md` for current thinking.

## License

Private project.
