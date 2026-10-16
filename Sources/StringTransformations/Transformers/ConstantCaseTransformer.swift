/// A structure that transforms strings into their constant-case representations.
public struct ConstantCaseTransformer: StringTransformer {
    public func transform(_ value: String) -> String {
        value.joinedCaseWords(separator: "_") { _, word in word.uppercased() }
    }
}

extension StringTransformer where Self == ConstantCaseTransformer {
    /// A string transformer that converts strings to constant-case representations.
    public static var constantCase: ConstantCaseTransformer { .init() }
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
