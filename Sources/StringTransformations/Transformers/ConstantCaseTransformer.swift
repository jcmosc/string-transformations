/// A structure that transforms strings into their constant-case representations.
public struct ConstantCaseTransformer: StringTransformer {
    /// The strategy used to split strings into words.
    public var wordSplittingStrategy: WordSplittingStrategy

    /// Creates a constant-case transformer.
    ///
    /// - Parameter wordSplittingStrategy: The strategy used to split strings into words.
    public init(wordSplittingStrategy: WordSplittingStrategy = .useDefaultBoundaries) {
        self.wordSplittingStrategy = wordSplittingStrategy
    }

    public func transform(_ value: String) -> String {
        value.joinedCaseWords(separator: "_", wordSplittingStrategy: wordSplittingStrategy) { _, word in
            word.uppercased()
        }
    }
}

extension StringTransformer where Self == ConstantCaseTransformer {
    /// A string transformer that converts strings to constant-case representations.
    public static var constantCase: ConstantCaseTransformer { .init() }

    /// A string transformer that converts strings to constant-case representations, using the given
    /// strategy to split them into words.
    public static func constantCase(wordSplittingStrategy: WordSplittingStrategy) -> ConstantCaseTransformer {
        .init(wordSplittingStrategy: wordSplittingStrategy)
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
