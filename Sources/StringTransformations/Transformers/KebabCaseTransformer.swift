/// A structure that transforms strings into their kebab-case representations.
///
/// Kebab case joins lowercase words with hyphens:
///
///     let transformer = KebabCaseTransformer()
///     print(transformer.transform("XMLHttpRequest"))
///     // Prints "xml-http-request"
///
/// Transformers split strings into words at separators and changes of case. To change how strings
/// are split, set ``wordSplittingStrategy`` and ``knownWords``.
public struct KebabCaseTransformer: StringTransformer {
    /// The strategy used to split strings into words.
    public var wordSplittingStrategy: WordSplittingStrategy

    /// Words with a fixed spelling, such as acronyms, that are never split at case changes.
    ///
    /// Where a known word appears in a string with exactly this spelling, it's kept as a single
    /// word, so `"myURLs"` splits into `"my"` and `"URLs"` when `"URLs"` is a known word.
    public var knownWords: Set<String>

    /// Creates a kebab-case transformer.
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

    /// Returns the result of converting a string to kebab case.
    ///
    /// - Parameter value: The string to convert.
    /// - Returns: The kebab case representation of `value`.
    public func transform(_ value: String) -> String {
        let knownWords = KnownWords(knownWords)
        return value.joinedCaseWords(
            separator: "-",
            wordSplittingStrategy: wordSplittingStrategy,
            knownWords: knownWords
        ) { _, word in
            word.lowercased()
        }
    }
}

extension StringTransformer where Self == KebabCaseTransformer {
    /// A string transformer that converts strings to kebab-case representations.
    public static var kebabCase: KebabCaseTransformer { .init() }

    /// A string transformer that converts strings to kebab-case representations, using the given
    /// strategy and known words to split them into words.
    public static func kebabCase(
        wordSplittingStrategy: WordSplittingStrategy = .useDefaultBoundaries,
        knownWords: Set<String> = []
    ) -> KebabCaseTransformer {
        .init(wordSplittingStrategy: wordSplittingStrategy, knownWords: knownWords)
    }
}

extension String {
    /// Returns a kebab-case version of the string.
    ///
    /// Here's an example of transforming a string to kebab case.
    ///
    ///     let key = "myURL"
    ///     print(key.kebabCased())
    ///     // Prints "my-url"
    ///
    /// - Returns: A kebab-case copy of the string.
    public func kebabCased() -> String {
        KebabCaseTransformer().transform(self)
    }
}
