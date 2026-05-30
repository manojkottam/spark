import { View, Text, Pressable } from 'react-native';
import { useState } from 'react';
import { router } from 'expo-router';
import { heroList, HeroId } from '@/lib/heroes';
import { HeroCard } from '@/components/hero/HeroCard';

/**
 * Hero Selection Screen
 *
 * This is one of the most important screens in the app.
 * The child (with a parent) chooses which companion will guide them.
 *
 * Story note: Even this early choice has gentle narrative weight.
 * Different heroes notice different kinds of "Echoes".
 */

export default function ChooseHeroScreen() {
  const [selectedHero, setSelectedHero] = useState<HeroId | null>(null);

  const handleContinue = () => {
    if (!selectedHero) return;

    // For now we just navigate forward.
    // Later this will create the ChildProfile + start the story.
    router.push({
      pathname: '/onboarding/profile-details',
      params: { heroId: selectedHero },
    });
  };

  return (
    <View className="flex-1 bg-[#F8F7F4] px-6 pt-12">
      <View className="mb-8">
        <Text className="text-center text-4xl font-semibold tracking-tighter text-neutral-900">
          Who would you like{'\n'}to learn with?
        </Text>
        <Text className="mt-3 text-center text-lg text-neutral-600">
          You can always change later.
        </Text>
      </View>

      {/* Three hero cards */}
      <View className="flex-row gap-3">
        {heroList.map((hero) => (
          <HeroCard
            key={hero.id}
            hero={hero}
            selected={selectedHero === hero.id}
            onPress={() => setSelectedHero(hero.id)}
          />
        ))}
      </View>

      {/* Gentle story hint at the bottom */}
      <View className="mt-auto pb-10 pt-6">
        <Text className="text-center text-sm text-neutral-500">
          Each companion sees the world a little differently.{'\n'}
          They’ll notice different kinds of wonders with you.
        </Text>

        <Pressable
          onPress={handleContinue}
          disabled={!selectedHero}
          className={`mt-6 h-14 items-center justify-center rounded-2xl active:opacity-90 ${
            selectedHero ? 'bg-neutral-900' : 'bg-neutral-300'
          }`}
        >
          <Text className="text-lg font-semibold text-white tracking-tight">
            Continue with {selectedHero ? heroList.find(h => h.id === selectedHero)?.displayName : '...'}
          </Text>
        </Pressable>
      </View>
    </View>
  );
}
