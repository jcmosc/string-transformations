/// A structure that transforms strings into their dot-case representations.
public struct DotCaseTransformer: StringTransformer {
    /// The strategy used to split strings into words.
    public var wordSplittingStrategy: WordSplittingStrategy

    /// Creates a dot-case transformer.
    ///
    /// - Parameter wordSplittingStrategy: The strategy used to split strings into words.
    public init(wordSplittingStrategy: WordSplittingStrategy = .useDefaultBoundaries) {
        self.wordSplittingStrategy = wordSplittingStrategy
    }

    public func transform(_ value: String) -> String {
        value.joinedCaseWords(separator: ".", wordSplittingStrategy: wordSplittingStrategy) { _, word in
            word.lowercased()
        }
    }
}

extension StringTransformer where Self == DotCaseTransformer {
    /// A string transformer that converts strings to dot-case representations.
    public static var dotCase: DotCaseTransformer { .init() }

    /// A string transformer that converts strings to dot-case representations, using the given
    /// strategy to split them into words.
    public static func dotCase(wordSplittingStrategy: WordSplittingStrategy) -> DotCaseTransformer {
        .init(wordSplittingStrategy: wordSplittingStrategy)
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
