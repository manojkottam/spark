import { useEffect } from 'react';
import { View, Text, ActivityIndicator } from 'react-native';
import { router } from 'expo-router';

/**
 * Entry point.
 * For now, we always send users into the new onboarding flow.
 * Later we will check if a profile already exists.
 */
export default function EntryPoint() {
  useEffect(() => {
    // Small delay so the splash feels intentional
    const timer = setTimeout(() => {
      router.replace('/onboarding/choose-hero');
    }, 400);

    return () => clearTimeout(timer);
  }, []);

  return (
    <View className="flex-1 items-center justify-center bg-[#F8F7F4]">
      <ActivityIndicator size="large" color="#9CA3AF" />
      <Text className="mt-4 text-neutral-500">Preparing your adventure…</Text>
    </View>
  );
}
