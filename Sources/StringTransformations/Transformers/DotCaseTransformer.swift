/// A structure that transforms strings into their dot-case representations.
public struct DotCaseTransformer: StringTransformer {
    public func transform(_ value: String) -> String {
        value.joinedCaseWords(separator: ".") { _, word in word.lowercased() }
    }
}

extension StringTransformer where Self == DotCaseTransformer {
    /// A string transformer that converts strings to dot-case representations.
    public static var dotCase: DotCaseTransformer { .init() }
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
