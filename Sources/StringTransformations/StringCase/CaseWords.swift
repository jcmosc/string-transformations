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
    /// Words are separated by runs of separator characters (underscores, hyphens, periods and
    /// whitespace), and then by case changes in the same way as
    /// `JSONEncoder.KeyEncodingStrategy.convertToSnakeCase`. Leading and trailing separators are
    /// not split, so that names such as `_private` keep their prefix.
    func caseComponents() -> CaseComponents {
        guard let first = firstIndex(where: { !$0.isWordSeparator }),
            let last = lastIndex(where: { !$0.isWordSeparator })
        else {
            return CaseComponents(prefix: self[...], words: [], suffix: "")
        }
        let words = self[first...last]
            .split(whereSeparator: \.isWordSeparator)
            .flatMap(Self.splitAtCaseChanges)
        return CaseComponents(prefix: self[..<first], words: words, suffix: self[index(after: last)...])
    }

    /// Returns the string with its words transformed and joined by a separator, preserving any
    /// leading and trailing separators.
    func joinedCaseWords(
        separator: String,
        _ transform: (_ offset: Int, _ word: Substring) -> String
    ) -> String {
        let components = caseComponents()
        let words = components.words.enumerated().map { transform($0.offset, $0.element) }
        return components.prefix + words.joined(separator: separator) + components.suffix
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

extension Character {
    fileprivate var isWordSeparator: Bool {
        self == "_" || self == "-" || self == "." || isWhitespace
    }

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
