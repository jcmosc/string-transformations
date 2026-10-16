/// A structure that transforms strings into their train-case representations.
public struct TrainCaseTransformer: StringTransformer {
    public func transform(_ value: String) -> String {
        value.joinedCaseWords(separator: "-") { _, word in word.capitalizedWord() }
    }
}

extension StringTransformer where Self == TrainCaseTransformer {
    /// A string transformer that converts strings to train-case representations.
    public static var trainCase: TrainCaseTransformer { .init() }
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
