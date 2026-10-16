/// A structure that transforms strings into their Train-case representations.
///
/// Train case joins capitalized words with hyphens:
///
///     let transformer = TrainCaseTransformer()
///     print(transformer.transform("content_type"))
///     // Prints "Content-Type"
///
/// Transformers split strings into words at separators and changes of case. To change how strings
/// are split, set ``wordSplittingStrategy`` and ``knownWords``.
public struct TrainCaseTransformer: StringTransformer {
    /// The strategy used to split strings into words.
    public var wordSplittingStrategy: WordSplittingStrategy

    /// Words with a fixed spelling, such as acronyms, that are never split at case changes.
    ///
    /// Where a known word appears in a string with exactly this spelling, it's kept as a single
    /// word, so `"myURLs"` splits into `"my"` and `"URLs"` when `"URLs"` is a known word.
    /// Words that match a known word, ignoring case, are written with the known word's spelling
    /// instead of being capitalized, so `"user_id"` becomes `"User-ID"` when `"ID"` is a known word.
    public var knownWords: Set<String>

    /// Creates a Train-case transformer.
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

    /// Returns the result of converting a string to Train case.
    ///
    /// - Parameter value: The string to convert.
    /// - Returns: The Train case representation of `value`.
    public func transform(_ value: String) -> String {
        let knownWords = KnownWords(knownWords)
        return value.joinedCaseWords(
            separator: "-",
            wordSplittingStrategy: wordSplittingStrategy,
            knownWords: knownWords
        ) { _, word in
            knownWords.capitalized(word)
        }
    }
}

extension StringTransformer where Self == TrainCaseTransformer {
    /// A string transformer that converts strings to Train-case representations.
    public static var trainCase: TrainCaseTransformer { .init() }

    /// A string transformer that converts strings to Train-case representations, using the given
    /// strategy and known words to split them into words.
    public static func trainCase(
        wordSplittingStrategy: WordSplittingStrategy = .useDefaultBoundaries,
        knownWords: Set<String> = []
    ) -> TrainCaseTransformer {
        .init(wordSplittingStrategy: wordSplittingStrategy, knownWords: knownWords)
    }
}

extension String {
    /// Returns a Train-case version of the string.
    ///
    /// Here's an example of transforming a string to train case.
    ///
    ///     let key = "myURL"
    ///     print(key.trainCased())
    ///     // Prints "My-Url"
    ///
    /// - Returns: A Train-case copy of the string.
    public func trainCased() -> String {
        TrainCaseTransformer().transform(self)
    }
}
