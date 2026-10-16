/// A structure that transforms strings into their constant-case representations.
///
/// Constant case joins uppercase words with underscores:
///
///     let transformer = ConstantCaseTransformer()
///     print(transformer.transform("maxRetryCount"))
///     // Prints "MAX_RETRY_COUNT"
///
/// Transformers split strings into words at separators and changes of case. To change how strings
/// are split, set ``wordSplittingStrategy`` and ``knownWords``.
public struct ConstantCaseTransformer: StringTransformer {
    /// The strategy used to split strings into words.
    public var wordSplittingStrategy: WordSplittingStrategy

    /// Words with a fixed spelling, such as acronyms, that are never split at case changes.
    ///
    /// Where a known word appears in a string with exactly this spelling, it's kept as a single
    /// word, so `"myURLs"` splits into `"my"` and `"URLs"` when `"URLs"` is a known word.
    public var knownWords: Set<String>

    /// Creates a constant-case transformer.
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

    /// Returns the result of converting a string to constant case.
    ///
    /// - Parameter value: The string to convert.
    /// - Returns: The constant case representation of `value`.
    public func transform(_ value: String) -> String {
        let knownWords = KnownWords(knownWords)
        return value.joinedCaseWords(
            separator: "_",
            wordSplittingStrategy: wordSplittingStrategy,
            knownWords: knownWords
        ) { _, word in
            word.uppercased()
        }
    }
}

extension StringTransformer where Self == ConstantCaseTransformer {
    /// A string transformer that converts strings to constant-case representations.
    public static var constantCase: ConstantCaseTransformer { .init() }

    /// A string transformer that converts strings to constant-case representations, using the given
    /// strategy and known words to split them into words.
    public static func constantCase(
        wordSplittingStrategy: WordSplittingStrategy = .useDefaultBoundaries,
        knownWords: Set<String> = []
    ) -> ConstantCaseTransformer {
        .init(wordSplittingStrategy: wordSplittingStrategy, knownWords: knownWords)
    }
}

extension String {
    /// Returns a constant-case version of the string.
    ///
    /// Here's an example of transforming a string to constant case.
    ///
    ///     let key = "myURL"
    ///     print(key.constantCased())
    ///     // Prints "MY_URL"
    ///
    /// - Returns: A constant-case copy of the string.
    public func constantCased() -> String {
        ConstantCaseTransformer().transform(self)
    }
}
