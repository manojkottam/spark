/** @type {import('tailwindcss').Config} */
module.exports = {
  // NOTE: Update this to include the paths to all of your component files.
  content: ['./src/**/*.{js,jsx,ts,tsx}'],
  presets: [require('nativewind/preset')],
  theme: {
    extend: {
      colors: {
        // Hero brand colors (can be referenced in Tailwind)
        flint: '#FF6B35',
        pebby: '#7C3AED',
        lumi: '#22D3EE',
      },
    },
  },
  plugins: [],
};
