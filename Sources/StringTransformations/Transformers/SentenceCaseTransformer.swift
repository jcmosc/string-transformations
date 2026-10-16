/// A structure that transforms strings into their Sentence-case representations.
///
/// Sentence case joins words with spaces, with the first word capitalized and the rest
/// lowercased:
///
///     let transformer = SentenceCaseTransformer()
///     print(transformer.transform("user_id"))
///     // Prints "User id"
///
/// Transformers split strings into words at separators and changes of case. To change how strings
/// are split, set ``wordSplittingStrategy`` and ``knownWords``.
public struct SentenceCaseTransformer: StringTransformer {
    /// The strategy used to split strings into words.
    public var wordSplittingStrategy: WordSplittingStrategy

    /// Words with a fixed spelling, such as acronyms, that are never split at case changes.
    ///
    /// Where a known word appears in a string with exactly this spelling, it's kept as a single
    /// word, so `"myURLs"` splits into `"my"` and `"URLs"` when `"URLs"` is a known word.
    /// Words that match a known word, ignoring case, are written with the known word's spelling
    /// instead of being capitalized or lowercased, so `"user_id"` becomes `"User ID"` when `"ID"` is
    /// a known word.
    public var knownWords: Set<String>

    /// Creates a Sentence-case transformer.
    ///
    /// - Parameters:
    ///   - wordSplittingStrategy: The strategy used to split strings into words.
    ///   - knownWords: Words with a fixed spelling, such as acronyms.
    public init(
        wordSplittingStrategy: WordSplittingStrategy = .useDefaultBoundaries,
        knownWords: Set<String> = []
    ) {
        self.wordSplittingStrategy = wordSplittingStrategy
        self.knownWords = knownWords
    }

    /// Returns the result of converting a string to Sentence case.
    ///
    /// - Parameter value: The string to convert.
    /// - Returns: The Sentence case representation of `value`.
    public func transform(_ value: String) -> String {
        let knownWords = KnownWords(knownWords)
        return value.joinedCaseWords(
            separator: " ",
            wordSplittingStrategy: wordSplittingStrategy,
            knownWords: knownWords
        ) { offset, word in
            offset == 0 ? knownWords.capitalized(word) : knownWords.lowercased(word)
        }
    }
}

extension StringTransformer where Self == SentenceCaseTransformer {
    /// A string transformer that converts strings to Sentence-case representations.
    public static var sentenceCase: SentenceCaseTransformer { .init() }

    /// A string transformer that converts strings to Sentence-case representations, using the given
    /// strategy and known words to split them into words.
    public static func sentenceCase(
        wordSplittingStrategy: WordSplittingStrategy = .useDefaultBoundaries,
        knownWords: Set<String> = []
    ) -> SentenceCaseTransformer {
        .init(wordSplittingStrategy: wordSplittingStrategy, knownWords: knownWords)
    }
}

extension String {
    /// Returns a Sentence-case version of the string.
    ///
    /// Here's an example of transforming a string to Sentence case.
    ///
    ///     let key = "myURL"
    ///     print(key.sentenceCased())
    ///     // Prints "My url"
    ///
    /// - Returns: A Sentence-case copy of the string.
    public func sentenceCased() -> String {
        SentenceCaseTransformer().transform(self)
    }
}
