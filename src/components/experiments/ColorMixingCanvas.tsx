import { Canvas, RoundedRect, Circle } from '@shopify/react-native-skia';
import { View, Text } from 'react-native';
import { Gesture, GestureDetector } from 'react-native-gesture-handler';
import Animated, {
  useSharedValue,
  useAnimatedStyle,
  runOnJS,
  withSpring,
} from 'react-native-reanimated';

interface ColorMixingCanvasProps {
  addedColors: string[];
  currentMixColor: string;
  onColorDropped: (colorKey: string) => void;
}

/**
 * Color Mixing Canvas v2 - Now with real drag & drop!
 * 
 * Kids can drag the primary color blobs from the bottom into the mixing paper.
 * When released over the mixing area, the color is added to the mix.
 * 
 * This is much more satisfying and educational than buttons.
 */

const MIXING_WIDTH = 340;
const MIXING_HEIGHT = 320;
const MIXING_TOP = 20;
const MIXING_BOTTOM = 180;

const COLOR_BLOBS = [
  { key: 'red',    color: '#E53935', startX: 70 },
  { key: 'yellow', color: '#FDD835', startX: 170 },
  { key: 'blue',   color: '#1E88E5', startX: 270 },
];

export function ColorMixingCanvas({ 
  addedColors, 
  currentMixColor, 
  onColorDropped 
}: ColorMixingCanvasProps) {
  const colorMap: Record<string, string> = {
    red: '#E53935',
    yellow: '#FDD835',
    blue: '#1E88E5',
  };

  const dropPositions = [
    { x: 130, y: 90 },
    { x: 200, y: 115 },
    { x: 165, y: 155 },
  ];

  return (
    <View className="items-center rounded-3xl bg-white p-4" style={{ borderWidth: 1, borderColor: 'rgba(0,0,0,0.06)' }}>
      <Canvas style={{ width: MIXING_WIDTH, height: MIXING_HEIGHT }}>
        {/* Mixing paper background */}
        <RoundedRect
          x={10}
          y={MIXING_TOP}
          width={MIXING_WIDTH - 20}
          height={MIXING_BOTTOM - MIXING_TOP}
          r={24}
          color="#FFFBF0"
        />

        {/* Already mixed colors in the paper */}
        {addedColors.map((colorKey, index) => {
          const pos = dropPositions[index] || { x: 170, y: 120 };
          const paintColor = colorMap[colorKey] || '#999';
          return (
            <Circle
              key={index}
              cx={pos.x}
              cy={pos.y}
              r={65 - index * 8}
              color={paintColor}
              opacity={0.6 - index * 0.1}
            />
          );
        })}

        {/* Live result preview in the center */}
        <Circle
          cx={MIXING_WIDTH / 2}
          cy={100}
          r={52}
          color={currentMixColor}
          opacity={0.95}
        />
        <Circle
          cx={MIXING_WIDTH / 2 - 16}
          cy={82}
          r={18}
          color="rgba(255,255,255,0.4)"
        />
      </Canvas>

      {/* Draggable color blobs below the canvas */}
      <View className="flex-row justify-between w-full px-6 mt-2" style={{ height: 90 }}>
        {COLOR_BLOBS.map((blob) => {
          const translateX = useSharedValue(0);
          const translateY = useSharedValue(0);
          const scale = useSharedValue(1);

          const isAlreadyUsed = addedColors.includes(blob.key);

          const panGesture = Gesture.Pan()
            .onUpdate((event) => {
              'worklet';
              translateX.value = event.translationX;
              translateY.value = event.translationY;
              scale.value = 1.15;
            })
            .onEnd((event) => {
              'worklet';
              const finalY = event.translationY;

              // Check if dropped inside the mixing paper area
              if (finalY < -40) { // roughly above the blobs into the canvas area
                runOnJS(onColorDropped)(blob.key);
              }

              // Spring back to start
              translateX.value = withSpring(0);
              translateY.value = withSpring(0);
              scale.value = withSpring(1);
            });

          const animatedStyle = useAnimatedStyle(() => ({
            transform: [
              { translateX: translateX.value },
              { translateY: translateY.value },
              { scale: scale.value },
            ],
          }));

          return (
            <GestureDetector key={blob.key} gesture={panGesture}>
              <Animated.View style={animatedStyle}>
                <View
                  className="items-center justify-center"
                  style={{
                    width: 68,
                    height: 68,
                    borderRadius: 34,
                    backgroundColor: blob.color,
                    opacity: isAlreadyUsed ? 0.35 : 1,
                  }}
                >
                  <Text className="text-white font-semibold text-sm">
                    {blob.key}
                  </Text>
                </View>
              </Animated.View>
            </GestureDetector>
          );
        })}
      </View>

      <Text className="mt-1 text-center text-xs tracking-widest text-neutral-400">
        DRAG COLORS INTO THE PAPER TO MIX
      </Text>
    </View>
  );
}
