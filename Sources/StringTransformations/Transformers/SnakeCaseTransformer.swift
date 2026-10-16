/// A structure that transforms strings into their snake-case representations.
///
/// Snake case joins lowercase words with underscores:
///
///     let transformer = SnakeCaseTransformer()
///     print(transformer.transform("myURL"))
///     // Prints "my_url"
///
/// Transformers split strings into words at separators and changes of case. To change how strings
/// are split, set ``wordSplittingStrategy`` and ``knownWords``.
public struct SnakeCaseTransformer: StringTransformer {
    /// The strategy used to split strings into words.
    public var wordSplittingStrategy: WordSplittingStrategy

    /// Words with a fixed spelling, such as acronyms, that are never split at case changes.
    ///
    /// Where a known word appears in a string with exactly this spelling, it's kept as a single
    /// word, so `"myURLs"` splits into `"my"` and `"URLs"` when `"URLs"` is a known word.
    public var knownWords: Set<String>

    /// Creates a snake-case transformer.
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

    /// Returns the result of converting a string to snake case.
    ///
    /// - Parameter value: The string to convert.
    /// - Returns: The snake case representation of `value`.
    public func transform(_ value: String) -> String {
        let knownWords = KnownWords(knownWords)
        return value.joinedCaseWords(
            separator: "_",
            wordSplittingStrategy: wordSplittingStrategy,
            knownWords: knownWords
        ) { _, word in
            word.lowercased()
        }
    }
}

extension StringTransformer where Self == SnakeCaseTransformer {
    /// A string transformer that converts strings to snake-case representations.
    public static var snakeCase: SnakeCaseTransformer { .init() }

    /// A string transformer that converts strings to snake-case representations, using the given
    /// strategy and known words to split them into words.
    public static func snakeCase(
        wordSplittingStrategy: WordSplittingStrategy = .useDefaultBoundaries,
        knownWords: Set<String> = []
    ) -> SnakeCaseTransformer {
        .init(wordSplittingStrategy: wordSplittingStrategy, knownWords: knownWords)
    }
}

extension String {
    /// Returns a snake-case version of the string.
    ///
    /// Here's an example of transforming a string to snake case.
    ///
    ///     let key = "myURL"
    ///     print(key.snakeCased())
    ///     // Prints "my_url"
    ///
    /// - Returns: A snake-case copy of the string.
    public func snakeCased() -> String {
        SnakeCaseTransformer().transform(self)
    }
}
