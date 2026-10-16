/// A structure that transforms strings into their train-case representations.
public struct TrainCaseTransformer: StringTransformer {
    /// The strategy used to split strings into words.
    public var wordSplittingStrategy: WordSplittingStrategy

    /// Creates a train-case transformer.
    ///
    /// - Parameter wordSplittingStrategy: The strategy used to split strings into words.
    public init(wordSplittingStrategy: WordSplittingStrategy = .useDefaultBoundaries) {
        self.wordSplittingStrategy = wordSplittingStrategy
    }

    public func transform(_ value: String) -> String {
        value.joinedCaseWords(separator: "-", wordSplittingStrategy: wordSplittingStrategy) { _, word in
            word.capitalizedWord()
        }
    }
}

extension StringTransformer where Self == TrainCaseTransformer {
    /// A string transformer that converts strings to train-case representations.
    public static var trainCase: TrainCaseTransformer { .init() }

    /// A string transformer that converts strings to train-case representations, using the given
    /// strategy to split them into words.
    public static func trainCase(wordSplittingStrategy: WordSplittingStrategy) -> TrainCaseTransformer {
        .init(wordSplittingStrategy: wordSplittingStrategy)
    }
}

extension String {
    /// Returns a train-case version of the string.
    ///
    /// Here's an example of transforming a string to train case.
    ///
    ///     let key = "myURL"
    ///     print(key.trainCased())
    ///     // Prints "My-Url"
    ///
    /// - Returns: A train-case copy of the string.
    public func trainCased() -> String {
        TrainCaseTransformer().transform(self)
    }
}
