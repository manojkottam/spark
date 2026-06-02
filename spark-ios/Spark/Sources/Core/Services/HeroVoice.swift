import AVFoundation

/// Speaks hero dialogue aloud so non-readers (K-2) can hear instead of read.
/// Uses built-in iOS text-to-speech now (no audio assets); each hero gets a
/// distinct pitch/rate. Swap to recorded voice actors later behind the same API.
@MainActor
final class HeroVoice {
    static let shared = HeroVoice()

    private let synthesizer = AVSpeechSynthesizer()

    private init() {
        // Play through the speaker even if the device is on silent — kids need to hear it.
        try? AVAudioSession.sharedInstance().setCategory(.playback, options: [.mixWithOthers, .duckOthers])
        try? AVAudioSession.sharedInstance().setActive(true)
    }

    /// Speak a line in the chosen hero's voice. Interrupts any line in progress.
    func speak(_ text: String, as heroID: HeroID) {
        let clean = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !clean.isEmpty else { return }

        synthesizer.stopSpeaking(at: .immediate)

        let utterance = AVSpeechUtterance(string: clean)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.preUtteranceDelay = 0.05

        switch heroID {
        case .flint:
            utterance.rate = 0.52
            utterance.pitchMultiplier = 1.18   // bright, energetic
        case .pebby:
            utterance.rate = 0.45
            utterance.pitchMultiplier = 1.05   // warm, gentle
        case .lumi:
            utterance.rate = 0.43
            utterance.pitchMultiplier = 1.28   // light, airy
        }

        synthesizer.speak(utterance)
    }

    func stop() {
        synthesizer.stopSpeaking(at: .immediate)
    }
}
