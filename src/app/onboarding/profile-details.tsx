import { View, Text, TextInput, Pressable } from 'react-native';
import { useLocalSearchParams, router } from 'expo-router';
import { useState } from 'react';
import { getHero } from '@/lib/heroes';

/**
 * Profile Details
 * 
 * Child enters their name + grade.
 * This will eventually create the full ChildProfile in local DB + backend.
 */

export default function ProfileDetailsScreen() {
  const { heroId } = useLocalSearchParams<{ heroId: string }>();
  const hero = heroId ? getHero(heroId as any) : null;

  const [name, setName] = useState('');
  const [grade, setGrade] = useState('2');

  const canContinue = name.trim().length > 1;

  const handleCreateProfile = () => {
    if (!canContinue || !hero) return;

    // TODO: Actually create profile in Zustand + SQLite + sync to Cloudflare
    console.log('Creating profile for:', { name, grade, hero: hero.id });

    // For now, go to a placeholder dashboard
    router.replace('/(tabs)');
  };

  if (!hero) {
    return (
      <View className="flex-1 items-center justify-center">
        <Text>No hero selected</Text>
      </View>
    );
  }

  return (
    <View className="flex-1 bg-[#F8F7F4] px-6 pt-12">
      <View className="mb-10 items-center">
        <Text style={{ fontSize: 56 }}>{hero.emoji}</Text>
        <Text className="mt-2 text-3xl font-semibold" style={{ color: hero.color }}>
          Hi, I’m {hero.displayName}
        </Text>
        <Text className="mt-1 text-center text-neutral-600">
          What should I call you?
        </Text>
      </View>

      <View className="gap-6">
        <View>
          <Text className="mb-2 text-sm font-medium text-neutral-600">My name is</Text>
          <TextInput
            value={name}
            onChangeText={setName}
            placeholder="Alex"
            placeholderTextColor="#9CA3AF"
            className="h-16 rounded-3xl bg-white px-6 text-2xl"
            style={{ borderWidth: 1, borderColor: 'rgba(0,0,0,0.08)' }}
          />
        </View>

        <View>
          <Text className="mb-2 text-sm font-medium text-neutral-600">I’m in</Text>
          <View className="flex-row gap-3">
            {['K', '1', '2', '3', '4', '5'].map((g) => (
              <Pressable
                key={g}
                onPress={() => setGrade(g)}
                className={`flex-1 items-center rounded-2xl py-4 ${
                  grade === g ? 'bg-neutral-900' : 'bg-white'
                }`}
                style={{ borderWidth: 1, borderColor: 'rgba(0,0,0,0.08)' }}
              >
                <Text
                  className={`text-lg font-semibold ${grade === g ? 'text-white' : 'text-neutral-700'}`}
                >
                  {g}
                </Text>
              </Pressable>
            ))}
          </View>
        </View>
      </View>

      <View className="mt-auto pb-10">
        <Pressable
          onPress={handleCreateProfile}
          disabled={!canContinue}
          className={`h-14 items-center justify-center rounded-2xl ${
            canContinue ? 'bg-neutral-900 active:opacity-90' : 'bg-neutral-300'
          }`}
        >
          <Text className="text-lg font-semibold text-white tracking-tight">
            Start learning with {hero.displayName}
          </Text>
        </Pressable>

        {/* TEMP: Quick access to first experiment while building */}
        <Pressable
          onPress={() => {
            // @ts-ignore - temporary for development
            router.push(`/science/experiments/color-mixing?heroId=${hero.id}`);
          }}
          className="mt-4 h-12 items-center justify-center rounded-2xl border border-dashed border-neutral-400 active:bg-neutral-100"
        >
          <Text className="text-sm font-medium text-neutral-600">
            [DEV] Try the Color Mixing Lab with {hero.displayName}
          </Text>
        </Pressable>

        <Text className="mt-4 text-center text-xs text-neutral-500">
          We’ll keep everything private and just between us.
        </Text>
      </View>
    </View>
  );
}
