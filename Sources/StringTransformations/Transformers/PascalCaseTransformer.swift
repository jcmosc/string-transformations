/// A structure that transforms strings into their Pascal-case representations.
public struct PascalCaseTransformer: StringTransformer {
    /// The strategy used to split strings into words.
    public var wordSplittingStrategy: WordSplittingStrategy

    /// Creates a Pascal-case transformer.
    ///
    /// - Parameter wordSplittingStrategy: The strategy used to split strings into words.
    public init(wordSplittingStrategy: WordSplittingStrategy = .useDefaultBoundaries) {
        self.wordSplittingStrategy = wordSplittingStrategy
    }

    public func transform(_ value: String) -> String {
        value.joinedCaseWords(separator: "", wordSplittingStrategy: wordSplittingStrategy) { _, word in
            word.capitalizedWord()
        }
    }
}

extension StringTransformer where Self == PascalCaseTransformer {
    /// A string transformer that converts strings to Pascal-case representations.
    public static var pascalCase: PascalCaseTransformer { .init() }

    /// A string transformer that converts strings to Pascal-case representations, using the given
    /// strategy to split them into words.
    public static func pascalCase(wordSplittingStrategy: WordSplittingStrategy) -> PascalCaseTransformer {
        .init(wordSplittingStrategy: wordSplittingStrategy)
    }
}

extension String {
    /// Returns a Pascal-case version of the string.
    ///
    /// Here's an example of transforming a string to Pascal case.
    ///
    ///     let key = "my_url"
    ///     print(key.pascalCased())
    ///     // Prints "MyUrl"
    ///
    /// - Returns: A Pascal-case copy of the string.
    public func pascalCased() -> String {
        PascalCaseTransformer().transform(self)
    }
}
