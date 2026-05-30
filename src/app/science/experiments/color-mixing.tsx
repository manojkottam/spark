import { View, Text, Pressable, ScrollView } from 'react-native';
import { useState } from 'react';
import { useLocalSearchParams } from 'expo-router';
import { getHero, HeroId } from '@/lib/heroes';
import { ColorMixingCanvas } from '@/components/experiments/ColorMixingCanvas';
import { echoFragments } from '@/lib/content/echoFragments';
import { heroEchoReactions } from '@/lib/content/echoFragments';

/**
 * Color Mixing Lab
 * 
 * First major Science experiment.
 * 
 * NGSS alignment (gentle): 2-PS1-1, 5-PS1-3 — Observe and describe properties of materials;
 * mixtures and solutions; planning investigations.
 * 
 * Story integration: Gentle hints from The Dimming Shimmer.
 * When children discover meaningful new colors through careful mixing,
 * we plant soft Echo Fragments.
 */

type MixResult = {
  color: string;
  name: string;
  description: string;
};


export default function ColorMixingLab() {
  const params = useLocalSearchParams<{ heroId?: string }>();
  const heroId = (params.heroId as HeroId) || 'lumi';
  const hero = getHero(heroId);

  const [addedColors, setAddedColors] = useState<string[]>([]);
  const [currentMix, setCurrentMix] = useState<MixResult | null>(null);
  const [discoveredEcho, setDiscoveredEcho] = useState<any>(null);
  const [heroComment, setHeroComment] = useState<string>('');

  // New: Prediction phase
  const [hasPredicted, setHasPredicted] = useState(false);
  const [prediction, setPrediction] = useState<string | null>(null);
  const [showPredictionResult, setShowPredictionResult] = useState(false);

  // Simple in-session discoveries list (will connect to profile later)
  const [discoveries, setDiscoveries] = useState<MixResult[]>([]);

  const handleColorDropped = (colorKey: string) => {
    if (addedColors.length >= 3 || addedColors.includes(colorKey)) return;

    const newMix = [...addedColors, colorKey];
    setAddedColors(newMix);

    const mixResult = calculateMix(newMix);
    setCurrentMix(mixResult);

    // Gentle story planting
    triggerStoryMoment(newMix, mixResult, heroId);
  };

  const resetMix = () => {
    setAddedColors([]);
    setCurrentMix(null);
    setDiscoveredEcho(null);
    setHeroComment('');
    setHasPredicted(false);
    setPrediction(null);
    setShowPredictionResult(false);
  };

  // New: Prediction logic
  const makePrediction = (predictedColor: string) => {
    setPrediction(predictedColor);
    setHasPredicted(true);
    
    // Hero reacts to the prediction
    const reactions = {
      flint: "Bold choice! Let's see if the colors agree with you!",
      pebby: "I love how you're thinking about this. Let's find out together.",
      lumi: "A wonderful guess. The colors will show us if you're right.",
    };
    setHeroComment(reactions[heroId as keyof typeof reactions] || "Let's see what happens!");
  };

  const checkPrediction = () => {
    if (!prediction || !currentMix) return;
    
    const wasCorrect = currentMix.name.toLowerCase().includes(prediction.toLowerCase());
    
    if (wasCorrect) {
      setHeroComment("You were right! That was a beautiful observation.");
    } else {
      setHeroComment("Not quite what you expected — but look how interesting it became instead!");
    }
    setShowPredictionResult(true);
  };

  const triggerStoryMoment = (mix: string[], result: MixResult, currentHeroId: HeroId) => {
    // Very gentle planting - only on specific beautiful discoveries
    if (mix.length === 2) {
      if (mix.includes('red') && mix.includes('blue') && result.name === 'Purple') {
        const fragment = echoFragments.find(f => f.id === 'echo_two_lights');
        if (fragment) {
          setDiscoveredEcho(fragment);
          const reaction = heroEchoReactions[currentHeroId as keyof typeof heroEchoReactions]?.uncommon || '';
          setHeroComment(`${reaction} We just made something the crystals have been waiting to see again.`);
        }
      }
      if (mix.includes('yellow') && mix.includes('blue') && result.name === 'Green') {
        const fragment = echoFragments.find(f => f.id === 'echo_listening_stone');
        if (fragment) {
          setDiscoveredEcho(fragment);
          setHeroComment("When yellow and blue meet, something alive appears. The Shimmer remembers this green.");
        }
      }
    }

    if (mix.length === 3) {
      // All three primaries mixed
      const fragment = echoFragments.find(f => f.id === 'echo_hidden_glow');
      if (fragment) {
        setDiscoveredEcho(fragment);
        const reaction = heroEchoReactions[currentHeroId as keyof typeof heroEchoReactions]?.rare || '';
        setHeroComment(`${reaction} When all the colors come together, sometimes the deepest light appears.`);
      }
    }

    // Extra gentle moment when they make Orange
    if (mix.includes('red') && mix.includes('yellow') && result.name === 'Orange') {
      setHeroComment("That warm orange feels like sunlight on the crystals...");
    }
  };

  function calculateMix(colors: string[]): MixResult {
    const hasRed = colors.includes('red');
    const hasYellow = colors.includes('yellow');
    const hasBlue = colors.includes('blue');

    if (hasRed && hasYellow && hasBlue) {
      return { color: '#4A3728', name: 'Deep Earth', description: 'All three colors together make something dark and rich.' };
    }
    if (hasRed && hasYellow) {
      return { color: '#F57C00', name: 'Orange', description: 'Red and yellow together make a warm, glowing orange.' };
    }
    if (hasYellow && hasBlue) {
      return { color: '#43A047', name: 'Green', description: 'Yellow and blue become a living green, like new leaves.' };
    }
    if (hasRed && hasBlue) {
      return { color: '#7B1FA2', name: 'Purple', description: 'Red and blue create a mysterious purple.' };
    }
    if (hasRed) return { color: '#E53935', name: 'Red', description: 'Just red for now.' };
    if (hasYellow) return { color: '#FDD835', name: 'Yellow', description: 'Bright yellow.' };
    if (hasBlue) return { color: '#1E88E5', name: 'Blue', description: 'Cool blue.' };

    return { color: '#FFFFFF', name: 'Nothing yet', description: 'Add some colors to begin mixing.' };
  }

  return (
    <ScrollView className="flex-1 bg-[#F8F7F4]">
      <View className="px-6 pt-12 pb-8">
        {/* Header with hero personality */}
        <View className="mb-6">
          <Text className="text-sm uppercase tracking-[2px] text-neutral-500">Science Lab</Text>
          <Text className="mt-1 text-4xl font-semibold tracking-tighter text-neutral-900">
            The Color Mixing Lab
          </Text>
          <Text className="mt-2 text-lg text-neutral-600">
            What happens when colors meet?
          </Text>
        </View>

        {/* Hero companion area - personality shines here */}
        <View className="mb-8 rounded-3xl bg-white p-5" style={{ borderWidth: 1, borderColor: hero.color + '30' }}>
          <View className="flex-row items-center gap-3">
            <Text style={{ fontSize: 32 }}>{hero.emoji}</Text>
            <View className="flex-1">
              <Text className="text-lg font-semibold" style={{ color: hero.color }}>
                {hero.displayName} says:
              </Text>
              <Text className="mt-1 text-[15px] leading-6 text-neutral-700">
                {heroComment || "Let’s discover what these colors can become together. Go slow. Notice everything."}
              </Text>
            </View>
          </View>
        </View>

        {/* Prediction Phase - only shown before any mixing */}
        {!hasPredicted && addedColors.length === 0 && (
          <View className="mb-8 rounded-3xl bg-white p-6" style={{ borderWidth: 1, borderColor: 'rgba(0,0,0,0.06)' }}>
            <Text className="text-lg font-semibold text-neutral-800">What do you think will happen?</Text>
            <Text className="mt-1 text-neutral-600">Make a guess before you start mixing.</Text>

            <View className="mt-4 flex-row flex-wrap gap-3">
              {['Orange', 'Green', 'Purple', 'Brown'].map((color) => (
                <Pressable
                  key={color}
                  onPress={() => makePrediction(color)}
                  className="rounded-2xl border px-5 py-3 active:opacity-80"
                  style={{ borderColor: hero.color + '40' }}
                >
                  <Text className="text-base font-medium" style={{ color: hero.color }}>{color}</Text>
                </Pressable>
              ))}
            </View>
          </View>
        )}

        {/* The interactive mixing area with drag & drop */}
        <View className="mb-2">
          <Text className="mb-2 text-lg font-semibold text-neutral-800">Mix the colors</Text>
          <ColorMixingCanvas
            addedColors={addedColors}
            currentMixColor={currentMix?.color || '#F5F5F0'}
            onColorDropped={handleColorDropped}
          />
        </View>
        <Text className="mb-6 text-center text-xs text-neutral-500">
          Drag the colored circles up into the paper area
        </Text>

        {/* Prediction result */}
        {hasPredicted && currentMix && !showPredictionResult && (
          <Pressable
            onPress={checkPrediction}
            className="mb-6 rounded-3xl bg-neutral-900 py-4 active:opacity-90"
          >
            <Text className="text-center text-lg font-semibold text-white">
              Check my prediction
            </Text>
          </Pressable>
        )}

        {/* Current discovery */}
        {currentMix && (
          <View className="mb-6 rounded-3xl bg-white p-6" style={{ borderWidth: 1, borderColor: 'rgba(0,0,0,0.06)' }}>
            <Text className="text-sm uppercase tracking-widest text-neutral-500">Right now you have</Text>
            <Text className="mt-1 text-3xl font-semibold tracking-tight" style={{ color: currentMix.color }}>
              {currentMix.name}
            </Text>
            <Text className="mt-2 text-[16px] leading-7 text-neutral-700">
              {currentMix.description}
            </Text>
          </View>
        )}

        {/* Gentle story moment - Echo Fragment */}
        {discoveredEcho && (
          <View className="mb-6 rounded-3xl p-6" style={{ backgroundColor: '#F0E6FF' }}>
            <Text className="text-xs uppercase tracking-[1.5px] text-[#6B4C9A]">Something special just happened</Text>
            <Text className="mt-2 text-2xl font-semibold text-[#3F2A5A]">{discoveredEcho.title}</Text>
            <Text className="mt-2 text-[15px] leading-7 text-[#4A3A66]">
              {discoveredEcho.description}
            </Text>
            <Text className="mt-3 text-xs text-[#6B4C9A]/70">
              The Shimmer noticed.
            </Text>
          </View>
        )}

        {/* Actions */}
        <View className="flex-row gap-4">
          <Pressable
            onPress={resetMix}
            className="flex-1 rounded-2xl bg-neutral-200 py-4 active:bg-neutral-300"
          >
            <Text className="text-center text-lg font-semibold text-neutral-700">Start over</Text>
          </Pressable>

          <Pressable
            onPress={() => {
              if (currentMix) {
                // Save this discovery for the session
                setDiscoveries(prev => [...prev, currentMix]);
                setHeroComment("Thank you for sharing what you noticed. That was beautiful.");
                setTimeout(() => {
                  resetMix();
                }, 1200);
              }
            }}
            disabled={!currentMix}
            className="flex-1 rounded-2xl py-4 active:opacity-90 disabled:bg-neutral-300"
            style={{ backgroundColor: currentMix ? hero.color : '#ccc' }}
          >
            <Text className="text-center text-lg font-semibold text-white">I noticed something</Text>
          </Pressable>
        </View>

        {/* Discoveries made in this session */}
        {discoveries.length > 0 && (
          <View className="mt-8">
            <Text className="mb-3 text-sm font-semibold text-neutral-500">Things you noticed today:</Text>
            {discoveries.map((d, index) => (
              <View key={index} className="mb-2 rounded-2xl bg-white p-4" style={{ borderWidth: 1, borderColor: 'rgba(0,0,0,0.06)' }}>
                <Text className="text-lg font-semibold" style={{ color: d.color }}>{d.name}</Text>
                <Text className="text-neutral-600">{d.description}</Text>
              </View>
            ))}
          </View>
        )}

        <Text className="mt-8 text-center text-xs text-neutral-400">
          NGSS • Grades K–5 • Observation &amp; Mixtures
        </Text>
      </View>
    </ScrollView>
  );
}
