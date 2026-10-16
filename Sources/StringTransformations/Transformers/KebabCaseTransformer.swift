/// A structure that transforms strings into their kebab-case representations.
public struct KebabCaseTransformer: StringTransformer {
    /// The strategy used to split strings into words.
    public var wordSplittingStrategy: WordSplittingStrategy

    /// Creates a kebab-case transformer.
    ///
    /// - Parameter wordSplittingStrategy: The strategy used to split strings into words.
    public init(wordSplittingStrategy: WordSplittingStrategy = .useDefaultBoundaries) {
        self.wordSplittingStrategy = wordSplittingStrategy
    }

    public func transform(_ value: String) -> String {
        value.joinedCaseWords(separator: "-", wordSplittingStrategy: wordSplittingStrategy) { _, word in
            word.lowercased()
        }
    }
}

extension StringTransformer where Self == KebabCaseTransformer {
    /// A string transformer that converts strings to kebab-case representations.
    public static var kebabCase: KebabCaseTransformer { .init() }

    /// A string transformer that converts strings to kebab-case representations, using the given
    /// strategy to split them into words.
    public static func kebabCase(wordSplittingStrategy: WordSplittingStrategy) -> KebabCaseTransformer {
        .init(wordSplittingStrategy: wordSplittingStrategy)
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
