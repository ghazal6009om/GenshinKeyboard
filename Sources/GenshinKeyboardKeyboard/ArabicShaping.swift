import Foundation

enum ArabicShaping {

    static let nonJoining: Set<Character> = [
        "\u{0622}", "\u{0623}", "\u{0624}", "\u{0625}", "\u{0627}", "\u{0629}",
        "\u{062F}", "\u{0630}", "\u{0631}", "\u{0632}", "\u{0648}", "\u{0649}",
    ]

    static let ligatures: [String: (initial: Character, final: Character)] = [
        "\u{0644}\u{0627}": ("\u{FEFB}", "\u{FEFC}"),
        "\u{0644}\u{0623}": ("\u{FEF5}", "\u{FEF6}"),
        "\u{0644}\u{0625}": ("\u{FEF9}", "\u{FEFA}"),
        "\u{0644}\u{0629}": ("\u{FEF7}", "\u{FEF8}"),
    ]

    static let forms: [Character: (isolated: Character, initial: Character, medial: Character, final: Character)] = [
        "\u{0626}": ("\u{FE89}", "\u{FE8B}", "\u{FE8C}", "\u{FE8A}"),
        "\u{0628}": ("\u{FE8F}", "\u{FE91}", "\u{FE92}", "\u{FE90}"),
        "\u{062A}": ("\u{FE95}", "\u{FE97}", "\u{FE98}", "\u{FE96}"),
        "\u{062B}": ("\u{FE99}", "\u{FE9B}", "\u{FE9C}", "\u{FE9A}"),
        "\u{062C}": ("\u{FE9D}", "\u{FE9F}", "\u{FEA0}", "\u{FE9E}"),
        "\u{062D}": ("\u{FEA1}", "\u{FEA3}", "\u{FEA4}", "\u{FEA2}"),
        "\u{062E}": ("\u{FEA5}", "\u{FEA7}", "\u{FEA8}", "\u{FEA6}"),
        "\u{0633}": ("\u{FEB1}", "\u{FEB3}", "\u{FEB4}", "\u{FEB2}"),
        "\u{0634}": ("\u{FEB5}", "\u{FEB7}", "\u{FEB8}", "\u{FEB6}"),
        "\u{0635}": ("\u{FEB9}", "\u{FEBB}", "\u{FEBC}", "\u{FEBA}"),
        "\u{0636}": ("\u{FEBD}", "\u{FEBF}", "\u{FEC0}", "\u{FEBE}"),
        "\u{0637}": ("\u{FEC1}", "\u{FEC3}", "\u{FEC4}", "\u{FEC2}"),
        "\u{0638}": ("\u{FEC5}", "\u{FEC7}", "\u{FEC8}", "\u{FEC6}"),
        "\u{0639}": ("\u{FEC9}", "\u{FECB}", "\u{FECC}", "\u{FECA}"),
        "\u{063A}": ("\u{FECD}", "\u{FECF}", "\u{FED0}", "\u{FECE}"),
        "\u{0641}": ("\u{FED1}", "\u{FED3}", "\u{FED4}", "\u{FED2}"),
        "\u{0642}": ("\u{FED5}", "\u{FED7}", "\u{FED8}", "\u{FED6}"),
        "\u{0643}": ("\u{FED9}", "\u{FEDB}", "\u{FEDC}", "\u{FEDA}"),
        "\u{0644}": ("\u{FEDD}", "\u{FEDF}", "\u{FEE0}", "\u{FEDE}"),
        "\u{0645}": ("\u{FEE1}", "\u{FEE3}", "\u{FEE4}", "\u{FEE2}"),
        "\u{0646}": ("\u{FEE5}", "\u{FEE7}", "\u{FEE8}", "\u{FEE6}"),
        "\u{0647}": ("\u{FEE9}", "\u{FEEB}", "\u{FEEC}", "\u{FEEA}"),
        "\u{064A}": ("\u{FEF1}", "\u{FEF3}", "\u{FEF4}", "\u{FEF2}"),
    ]

    static let twoForm: [Character: (isolated: Character, final: Character)] = [
        "\u{0622}": ("\u{FE81}", "\u{FE82}"),
        "\u{0623}": ("\u{FE83}", "\u{FE84}"),
        "\u{0624}": ("\u{FE85}", "\u{FE86}"),
        "\u{0625}": ("\u{FE87}", "\u{FE88}"),
        "\u{0627}": ("\u{FE8D}", "\u{FE8E}"),
        "\u{0629}": ("\u{FE93}", "\u{FE94}"),
        "\u{062F}": ("\u{FEA9}", "\u{FEAA}"),
        "\u{0630}": ("\u{FEAB}", "\u{FEAC}"),
        "\u{0631}": ("\u{FEAD}", "\u{FEAE}"),
        "\u{0632}": ("\u{FEAF}", "\u{FEB0}"),
        "\u{0648}": ("\u{FEED}", "\u{FEEE}"),
        "\u{0649}": ("\u{FEEF}", "\u{FEF0}"),
    ]

    static func isArabic(_ c: Character) -> Bool {
        forms[c] != nil || twoForm[c] != nil
    }

    static func joinsRight(_ c: Character) -> Bool {
        forms[c] != nil
    }

    static func isArabicChar(_ c: Character) -> Bool {
        if c == " " || c == "\t" || c == "\n" { return true }
        guard let v = c.unicodeScalars.first?.value else { return false }
        return (0x0600...0x06FF).contains(v)
            || (0x0750...0x077F).contains(v)
            || (0x08A0...0x08FF).contains(v)
            || (0xFB50...0xFDFF).contains(v)
            || (0xFE70...0xFEFF).contains(v)
    }

    /// يعكس النص إلى الترتيب البصري بأحرف أساسية (بدون تشكيل).
    /// مناسب للألعاب التي تُطبّع Presentation Forms وتحوّلها لأحرف أساسية.
    static func processPlain(_ text: String) -> String {
        let chars = Array(text)
        var runs: [[Character]] = []
        var current: [Character] = []
        var currentArabic = false

        for (i, c) in chars.enumerated() {
            let isA = isArabicChar(c)
            if i == 0 {
                currentArabic = isA
                current = [c]
                continue
            }
            if isA == currentArabic {
                current.append(c)
            } else {
                runs.append(current)
                current = [c]
                currentArabic = isA
            }
        }
        if !current.isEmpty {
            runs.append(current)
        }

        var parts: [String] = []
        for run in runs {
            if isArabicChar(run[0]) {
                parts.append(String(run.reversed()))
            } else {
                parts.append(String(run))
            }
        }
        return parts.reversed().joined()
    }

    static func shape(_ text: String) -> String {
        let chars = Array(text)
        var result = ""
        var i = 0

        while i < chars.count {
            let c = chars[i]

            if i + 1 < chars.count, c == "\u{0644}",
               let lig = ligatures[String([c]) + String(chars[i + 1])] {
                let prevJoins = i > 0 && joinsRight(chars[i - 1])
                result.append(prevJoins ? lig.final : lig.initial)
                i += 2
                continue
            }

            if let f = forms[c] {
                let next = i + 1 < chars.count ? chars[i + 1] : nil
                let prev = i > 0 ? chars[i - 1] : nil
                let nextJoins = next != nil && joinsRight(next!)
                let prevJoins = prev != nil && joinsRight(prev!)
                if nextJoins && prevJoins {
                    result.append(f.medial)
                } else if nextJoins && !prevJoins {
                    result.append(f.initial)
                } else if !nextJoins && prevJoins {
                    result.append(f.final)
                } else {
                    result.append(f.isolated)
                }
                i += 1
                continue
            }

            if let f = twoForm[c] {
                let prev = i > 0 ? chars[i - 1] : nil
                let prevJoins = prev != nil && joinsRight(prev!)
                result.append(prevJoins ? f.final : f.isolated)
                i += 1
                continue
            }

            result.append(c)
            i += 1
        }
        return result
    }

    static func reverseRTL(_ text: String) -> String {
        var reversed = String(text.reversed())

        var runs: [Range<String.Index>] = []
        var start: String.Index? = nil
        var index = reversed.startIndex
        while index < reversed.endIndex {
            let c = reversed[index]
            let isDigit = (c >= "0" && c <= "9") || c == "." || c == ","
            if isDigit {
                if start == nil { start = index }
            } else {
                if let s = start {
                    runs.append(s..<index)
                    start = nil
                }
            }
            index = reversed.index(after: index)
        }
        if let s = start {
            runs.append(s..<reversed.endIndex)
        }

        var segments: [String] = []
        var current = reversed.startIndex
        for range in runs {
            segments.append(String(reversed[current..<range.lowerBound]))
            segments.append(String(reversed[range].reversed()))
            current = range.upperBound
        }
        if current < reversed.endIndex {
            segments.append(String(reversed[current..<reversed.endIndex]))
        }

        return segments.joined()
    }

    static func process(_ text: String) -> String {
        reverseRTL(shape(text))
    }
}
