extension String {
    /// The parts of a string relevant to converting between cases.
    struct CaseComponents {
        /// The leading run of word separators, preserved as-is.
        var prefix: Substring
        /// The words between the leading and trailing separators.
        var words: [Substring]
        /// The trailing run of word separators, preserved as-is.
        var suffix: Substring
    }

    /// Splits the string into words for case conversion.
    ///
    /// Words are separated by runs of the strategy's separator characters, and then, if the strategy
    /// allows it, by case changes in the same way as
    /// `JSONEncoder.KeyEncodingStrategy.convertToSnakeCase`. Leading and trailing separators are
    /// not split, so that names such as `_private` keep their prefix. Known words are never split
    /// at case changes.
    func caseComponents(
        wordSplittingStrategy: WordSplittingStrategy,
        knownWords: KnownWords
    ) -> CaseComponents {
        guard let first = firstIndex(where: { !wordSplittingStrategy.isSeparator($0) }),
            let last = lastIndex(where: { !wordSplittingStrategy.isSeparator($0) })
        else {
            return CaseComponents(prefix: self[...], words: [], suffix: "")
        }
        var words = self[first...last].split(whereSeparator: wordSplittingStrategy.isSeparator)
        if wordSplittingStrategy.splitsAtCaseChanges {
            words = words.flatMap { Self.splitAtCaseChanges($0, knownWords: knownWords) }
        }
        return CaseComponents(prefix: self[..<first], words: words, suffix: self[index(after: last)...])
    }

    /// Returns the string with its words transformed and joined by a separator, preserving any
    /// leading and trailing separators.
    func joinedCaseWords(
        separator: String,
        wordSplittingStrategy: WordSplittingStrategy,
        knownWords: KnownWords,
        _ transform: (_ offset: Int, _ word: Substring) -> String
    ) -> String {
        let components = caseComponents(wordSplittingStrategy: wordSplittingStrategy, knownWords: knownWords)
        let words = components.words.enumerated().map { transform($0.offset, $0.element) }
        return components.prefix + words.joined(separator: separator) + components.suffix
    }

    /// Splits a word at case changes, keeping known words together and splitting the text between
    /// them with `splitAtCaseChanges(_:)`.
    private static func splitAtCaseChanges(_ word: Substring, knownWords: KnownWords) -> [Substring] {
        guard !knownWords.isEmpty else {
            return splitAtCaseChanges(word)
        }
        var words: [Substring] = []
        // The start of the text that isn't part of a known word, which is always a word start.
        var gapStart = word.startIndex
        var i = word.startIndex
        while i < word.endIndex {
            guard let end = knownWords.match(in: word, at: i, isWordStart: i == gapStart) else {
                i = word.index(after: i)
                continue
            }
            if gapStart < i {
                words += splitAtCaseChanges(word[gapStart..<i])
            }
            words.append(word[i..<end])
            gapStart = end
            i = end
        }
        if gapStart < word.endIndex {
            words += splitAtCaseChanges(word[gapStart...])
        }
        return words
    }

    /// Splits a word at case changes, matching `JSONEncoder.KeyEncodingStrategy.convertToSnakeCase`.
    ///
    /// A new word starts at the first uppercase letter after a lowercase letter, so digits and other
    /// caseless characters stay with the word before them (`version4Thing`). A run of uppercase
    /// letters is a word of its own, except for the last one, which starts the next word when a
    /// lowercase letter follows (`XMLProperty`).
    private static func splitAtCaseChanges(_ word: Substring) -> [Substring] {
        var words: [Substring] = []
        var wordStart = word.startIndex
        var searchStart = word.startIndex

        while let upper = word[searchStart...].firstIndex(where: \.startsUppercase) {
            if wordStart != upper {
                words.append(word[wordStart..<upper])
            }
            guard let lower = word[upper...].firstIndex(where: \.startsLowercase) else {
                // There are no more lowercase letters, so the rest is one word.
                wordStart = upper
                break
            }
            if lower == word.index(after: upper) {
                // A capitalized word, which continues until the next uppercase letter.
                wordStart = upper
            } else {
                // A run of uppercase letters, up to the character before the lowercase letter.
                let beforeLower = word.index(before: lower)
                words.append(word[upper..<beforeLower])
                wordStart = beforeLower
            }
            searchStart = word.index(after: lower)
        }
        words.append(word[wordStart...])
        return words
    }
}

extension Substring {
    /// Returns the word with its first character titlecased and the rest lowercased.
    func capitalizedWord() -> String {
        guard let first = unicodeScalars.first else {
            return ""
        }
        return first.properties.titlecaseMapping + String(unicodeScalars.dropFirst()).lowercased()
    }
}

/// Words with a fixed spelling, such as acronyms, that are kept together when splitting and keep
/// their spelling when capitalized.
struct KnownWords {
    /// The known words, longest first so that the longest match wins.
    private let words: [String]

    /// The spelling of each known word, keyed by its lowercased form.
    private let spellings: [String: String]

    init(_ words: Set<String>) {
        self.words = words.filter { !$0.isEmpty }.sorted {
            $0.count != $1.count ? $0.count > $1.count : $0 < $1
        }
        // Sorting makes the spelling chosen for words that differ only by case deterministic.
        self.spellings = Dictionary(self.words.map { ($0.lowercased(), $0) }) { first, _ in first }
    }

    var isEmpty: Bool {
        words.isEmpty
    }

    /// Returns the end of the known word that appears at the given index, if there is one.
    ///
    /// A known word must appear with its exact spelling, and must not be followed by a lowercase
    /// letter, which would continue the word. Unless the index is the start of a word, the known
    /// word must also not continue a run of letters of the same case as its first letter, so that
    /// `"URL"` isn't found in `"CURL"`.
    func match(in string: Substring, at index: Substring.Index, isWordStart: Bool) -> Substring.Index? {
        for word in words where string[index...].hasPrefix(word) {
            let end = string.index(index, offsetBy: word.count)
            if end < string.endIndex && string[end].startsLowercase {
                continue
            }
            if !isWordStart, let first = word.first {
                let previous = string[string.index(before: index)]
                if (first.startsUppercase && previous.startsUppercase)
                    || (first.startsLowercase && previous.startsLowercase)
                {
                    continue
                }
            }
            return end
        }
        return nil
    }

    /// Returns the word capitalized, or with its known spelling if it's a known word, ignoring case.
    func capitalized(_ word: Substring) -> String {
        spellings[word.lowercased()] ?? word.capitalizedWord()
    }

    /// Returns the word lowercased, or with its known spelling if it's a known word, ignoring case.
    func lowercased(_ word: Substring) -> String {
        spellings[word.lowercased()] ?? word.lowercased()
    }
}

extension Character {
    // Like Foundation's `CharacterSet.uppercaseLetters`, these check the general category of the
    // base scalar, so combining marks don't affect the result and caseless characters, such as
    // digits, symbols and emoji, are neither uppercase nor lowercase.
    fileprivate var startsUppercase: Bool {
        switch unicodeScalars.first?.properties.generalCategory {
        case .uppercaseLetter, .titlecaseLetter: true
        default: false
        }
    }

    fileprivate var startsLowercase: Bool {
        unicodeScalars.first?.properties.generalCategory == .lowercaseLetter
    }
}
