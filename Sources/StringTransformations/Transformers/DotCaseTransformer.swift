/// A structure that transforms strings into their dot-case representations.
///
/// Dot case joins lowercase words with periods:
///
///     let transformer = DotCaseTransformer()
///     print(transformer.transform("serverPort"))
///     // Prints "server.port"
///
/// Transformers split strings into words at separators and changes of case. To change how strings
/// are split, set ``wordSplittingStrategy`` and ``knownWords``.
public struct DotCaseTransformer: StringTransformer {
    /// The strategy used to split strings into words.
    public var wordSplittingStrategy: WordSplittingStrategy

    /// Words with a fixed spelling, such as acronyms, that are never split at case changes.
    ///
    /// Where a known word appears in a string with exactly this spelling, it's kept as a single
    /// word, so `"myURLs"` splits into `"my"` and `"URLs"` when `"URLs"` is a known word.
    public var knownWords: Set<String>

    /// Creates a dot-case transformer.
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

    /// Returns the result of converting a string to dot case.
    ///
    /// - Parameter value: The string to convert.
    /// - Returns: The dot case representation of `value`.
    public func transform(_ value: String) -> String {
        let knownWords = KnownWords(knownWords)
        return value.joinedCaseWords(
            separator: ".",
            wordSplittingStrategy: wordSplittingStrategy,
            knownWords: knownWords
        ) { _, word in
            word.lowercased()
        }
    }
}

extension StringTransformer where Self == DotCaseTransformer {
    /// A string transformer that converts strings to dot-case representations.
    public static var dotCase: DotCaseTransformer { .init() }

    /// A string transformer that converts strings to dot-case representations, using the given
    /// strategy and known words to split them into words.
    public static func dotCase(
        wordSplittingStrategy: WordSplittingStrategy = .useDefaultBoundaries,
        knownWords: Set<String> = []
    ) -> DotCaseTransformer {
        .init(wordSplittingStrategy: wordSplittingStrategy, knownWords: knownWords)
    }
}

extension String {
    /// Returns a dot-case version of the string.
    ///
    /// Here's an example of transforming a string to dot case.
    ///
    ///     let key = "myURL"
    ///     print(key.dotCased())
    ///     // Prints "my.url"
    ///
    /// - Returns: A dot-case copy of the string.
    public func dotCased() -> String {
        DotCaseTransformer().transform(self)
    }
}
