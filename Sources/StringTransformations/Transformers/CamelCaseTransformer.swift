/// A structure that transforms strings into their camel-case representations.
public struct CamelCaseTransformer: StringTransformer {
    /// The strategy used to split strings into words.
    public var wordSplittingStrategy: WordSplittingStrategy

    /// Words with a fixed spelling, such as acronyms, that are never split at case changes.
    ///
    /// Where a known word appears in a string with exactly this spelling, it's kept as a single
    /// word, so `"myURLs"` splits into `"my"` and `"URLs"` when `"URLs"` is a known word.
    /// Words that match a known word, ignoring case, are written with the known word's spelling
    /// instead of being capitalized, so `"user_id"` becomes `"userID"` when `"ID"` is a known word.
    public var knownWords: Set<String>

    /// Creates a camel-case transformer.
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

    public func transform(_ value: String) -> String {
        let knownWords = KnownWords(knownWords)
        return value.joinedCaseWords(
            separator: "",
            wordSplittingStrategy: wordSplittingStrategy,
            knownWords: knownWords
        ) { offset, word in
            offset == 0 ? word.lowercased() : knownWords.capitalized(word)
        }
    }
}

extension StringTransformer where Self == CamelCaseTransformer {
    /// A string transformer that converts strings to camel-case representations.
    public static var camelCase: CamelCaseTransformer { .init() }

    /// A string transformer that converts strings to camel-case representations, using the given
    /// strategy and known words to split them into words.
    public static func camelCase(
        wordSplittingStrategy: WordSplittingStrategy = .useDefaultBoundaries,
        knownWords: Set<String> = []
    ) -> CamelCaseTransformer {
        .init(wordSplittingStrategy: wordSplittingStrategy, knownWords: knownWords)
    }
}

extension String {
    /// Returns a camel-case version of the string.
    ///
    /// Here's an example of transforming a string to camel case.
    ///
    ///     let key = "my_url"
    ///     print(key.camelCased())
    ///     // Prints "myUrl"
    ///
    /// - Returns: A camel-case copy of the string.
    public func camelCased() -> String {
        CamelCaseTransformer().transform(self)
    }
}
