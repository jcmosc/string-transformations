/// A structure that transforms strings into their snake-case representations.
public struct SnakeCaseTransformer: StringTransformer {
    /// The strategy used to split strings into words.
    public var wordSplittingStrategy: WordSplittingStrategy

    /// Creates a snake-case transformer.
    ///
    /// - Parameter wordSplittingStrategy: The strategy used to split strings into words.
    public init(wordSplittingStrategy: WordSplittingStrategy = .useDefaultBoundaries) {
        self.wordSplittingStrategy = wordSplittingStrategy
    }

    public func transform(_ value: String) -> String {
        value.joinedCaseWords(separator: "_", wordSplittingStrategy: wordSplittingStrategy) { _, word in
            word.lowercased()
        }
    }
}

extension StringTransformer where Self == SnakeCaseTransformer {
    /// A string transformer that converts strings to snake-case representations.
    public static var snakeCase: SnakeCaseTransformer { .init() }

    /// A string transformer that converts strings to snake-case representations, using the given
    /// strategy to split them into words.
    public static func snakeCase(wordSplittingStrategy: WordSplittingStrategy) -> SnakeCaseTransformer {
        .init(wordSplittingStrategy: wordSplittingStrategy)
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
