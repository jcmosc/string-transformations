/// A structure that transforms strings into their camel-case representations.
public struct CamelCaseTransformer: StringTransformer {
    public func transform(_ value: String) -> String {
        value.joinedCaseWords(separator: "") { offset, word in
            offset == 0 ? word.lowercased() : word.capitalizedWord()
        }
    }
}

extension StringTransformer where Self == CamelCaseTransformer {
    /// A string transformer that converts strings to camel-case representations.
    public static var camelCase: CamelCaseTransformer { .init() }
}

extension String {
    /// Returns a camel-case version of the string.
    ///
    /// Here's an example of transforming a string to camel case.
    ///
    ///     let key = "my_url"
    ///     print(key.camelCased())
    ///     // Prints "myUrl"
    ///
    /// - Returns: A camel-case copy of the string.
    public func camelCased() -> String {
        CamelCaseTransformer().transform(self)
    }
}
