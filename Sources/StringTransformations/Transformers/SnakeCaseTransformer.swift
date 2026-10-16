/// A structure that transforms strings into their snake-case representations.
public struct SnakeCaseTransformer: StringTransformer {
    public func transform(_ value: String) -> String {
        value.joinedCaseWords(separator: "_") { _, word in word.lowercased() }
    }
}

extension StringTransformer where Self == SnakeCaseTransformer {
    /// A string transformer that converts strings to snake-case representations.
    public static var snakeCase: SnakeCaseTransformer { .init() }
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
