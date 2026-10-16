/// A structure that transforms strings into their kebab-case representations.
public struct KebabCaseTransformer: StringTransformer {
    public func transform(_ value: String) -> String {
        value.joinedCaseWords(separator: "-") { _, word in word.lowercased() }
    }
}

extension StringTransformer where Self == KebabCaseTransformer {
    /// A string transformer that converts strings to kebab-case representations.
    public static var kebabCase: KebabCaseTransformer { .init() }
}

extension String {
    /// Returns a kebab-case version of the string.
    ///
    /// Here's an example of transforming a string to kebab case.
    ///
    ///     let key = "myURL"
    ///     print(key.kebabCased())
    ///     // Prints "my-url"
    ///
    /// - Returns: A kebab-case copy of the string.
    public func kebabCased() -> String {
        KebabCaseTransformer().transform(self)
    }
}
