import Foundation

enum ArabicShaping {

    static func isArabicLetter(_ character: Character) -> Bool {
        guard let scalar = character.unicodeScalars.first else {
            return false
        }
        let v = scalar.value
        return (0x0621...0x064A).contains(v) ||
               (0x0671...0x06D3).contains(v) ||
               v == 0x06D5 ||
               (0x06FA...0x06FF).contains(v) ||
               (0x0750...0x077F).contains(v) ||
               (0x08A0...0x08FF).contains(v)
    }

    static func isArabicMark(_ character: Character) -> Bool {
        guard let scalar = character.unicodeScalars.first else {
            return false
        }
        let v = scalar.value
        return (0x064B...0x065F).contains(v) ||
               v == 0x0670
    }

    // MARK: - Plain visual reorder

    /// Reorders Arabic text for Genshin's chat renderer.
    ///
    /// Example:
    /// "مرحبا" -> "ابحرم"
    ///
    /// The game then displays this visually as:
    /// "مرحبا"
    ///
    /// Spaces, numbers, English letters, punctuation and emoji
    /// are kept in place — only Arabic runs are reversed.
    static func processPlain(_ text: String) -> String {
        let characters = Array(text)
        guard !characters.isEmpty else {
            return ""
        }

        var result: [Character] = []
        var arabicRun: [Character] = []

        func flushArabicRun() {
            guard !arabicRun.isEmpty else {
                return
            }
            // Reverse only the Arabic sequence.
            result.append(contentsOf: arabicRun.reversed())
            arabicRun.removeAll(keepingCapacity: true)
        }

        for character in characters {
            if isArabicLetter(character) || isArabicMark(character) {
                arabicRun.append(character)
            } else {
                // Space, number, English letter,
                // punctuation, emoji, etc.
                flushArabicRun()
                result.append(character)
            }
        }

        flushArabicRun()

        return String(result)
    }

    // MARK: - Genshin processor

    /// Main function used by the Genshin mode.
    ///
    /// IMPORTANT:
    /// We intentionally do NOT use Arabic Presentation Forms here.
    /// Some iOS applications normalize those characters back to
    /// standard Arabic Unicode before rendering.
    static func process(_ text: String) -> String {
        return processPlain(text)
    }

    // MARK: - Optional compatibility functions

    static func reverseRTL(_ text: String) -> String {
        return processPlain(text)
    }

    static func shape(_ text: String) -> String {
        // Kept for compatibility with the original project.
        // We no longer use Presentation Forms for Genshin mode.
        return text
    }
}
