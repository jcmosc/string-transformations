/// A structure that transforms strings into their Pascal-case representations.
public struct PascalCaseTransformer: StringTransformer {
    public func transform(_ value: String) -> String {
        value.joinedCaseWords(separator: "") { _, word in word.capitalizedWord() }
    }
}

extension StringTransformer where Self == PascalCaseTransformer {
    /// A string transformer that converts strings to Pascal-case representations.
    public static var pascalCase: PascalCaseTransformer { .init() }
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
