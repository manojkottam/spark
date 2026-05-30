import { View, Text, Pressable } from 'react-native';
import { Hero } from '@/lib/heroes';

interface HeroCardProps {
  hero: Hero;
  selected: boolean;
  onPress: () => void;
}

export function HeroCard({ hero, selected, onPress }: HeroCardProps) {
  const isFlint = hero.id === 'flint';
  const isPebby = hero.id === 'pebby';
  const isLumi = hero.id === 'lumi';

  const bgColor = selected
    ? isFlint
      ? '#FFF7ED'
      : isPebby
        ? '#F5F0FF'
        : '#E0F7FA'
    : '#FFFFFF';

  const borderColor = selected
    ? hero.color
    : 'rgba(0,0,0,0.08)';

  return (
    <Pressable
      onPress={onPress}
      className="flex-1 rounded-3xl p-5 active:opacity-90"
      style={{
        backgroundColor: bgColor,
        borderWidth: selected ? 3 : 1,
        borderColor,
      }}
    >
      <View className="items-center">
        {/* Temporary visual until we have Rive characters */}
        <View
          className="mb-4 h-20 w-20 items-center justify-center rounded-full"
          style={{ backgroundColor: hero.color + '20' }}
        >
          <Text style={{ fontSize: 42 }}>{hero.emoji}</Text>
        </View>

        <Text
          className="text-2xl font-semibold tracking-tight"
          style={{ color: hero.color }}
        >
          {hero.displayName}
        </Text>

        <Text className="mt-2 text-center text-[15px] leading-6 text-neutral-600">
          {hero.personality.tone}
        </Text>

        {/* Gentle story hint - only visible when selected */}
        {selected && (
          <View className="mt-4 rounded-2xl bg-white/70 px-3 py-2">
            <Text className="text-center text-xs text-neutral-500">
              {hero.storyRole.split('.')[0]}.
            </Text>
          </View>
        )}
      </View>
    </Pressable>
  );
}
