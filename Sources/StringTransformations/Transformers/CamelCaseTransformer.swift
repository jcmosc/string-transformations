/// A structure that transforms strings into their camel-case representations.
public struct CamelCaseTransformer: StringTransformer {
    /// The strategy used to split strings into words.
    public var wordSplittingStrategy: WordSplittingStrategy

    /// Creates a camel-case transformer.
    ///
    /// - Parameter wordSplittingStrategy: The strategy used to split strings into words.
    public init(wordSplittingStrategy: WordSplittingStrategy = .useDefaultBoundaries) {
        self.wordSplittingStrategy = wordSplittingStrategy
    }

    public func transform(_ value: String) -> String {
        value.joinedCaseWords(separator: "", wordSplittingStrategy: wordSplittingStrategy) { offset, word in
            offset == 0 ? word.lowercased() : word.capitalizedWord()
        }
    }
}

extension StringTransformer where Self == CamelCaseTransformer {
    /// A string transformer that converts strings to camel-case representations.
    public static var camelCase: CamelCaseTransformer { .init() }

    /// A string transformer that converts strings to camel-case representations, using the given
    /// strategy to split them into words.
    public static func camelCase(wordSplittingStrategy: WordSplittingStrategy) -> CamelCaseTransformer {
        .init(wordSplittingStrategy: wordSplittingStrategy)
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
