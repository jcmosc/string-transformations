extension String {
    /// Returns a version of the string transformed using the given transformer.
    ///
    /// Here's an example of transforming a string to snake case.
    ///
    ///     let key = "myURL"
    ///     print(key.transformed(using: .snakeCase))
    ///     // Prints "my_url"
    ///
    /// - Parameter transformer: The transformer to apply to the string.
    /// - Returns: A transformed copy of the string.
    public func transformed(using transformer: some StringTransformer) -> String {
        transformer.transform(self)
    }

    /// Transforms the string in place using the given transformer.
    ///
    /// Here's an example of transforming a string to snake case in place.
    ///
    ///     var key = "myURL"
    ///     key.transform(using: .snakeCase)
    ///     print(key)
    ///     // Prints "my_url"
    ///
    /// - Parameter transformer: The transformer to apply to the string.
    public mutating func transform(using transformer: some StringTransformer) {
        self = transformer.transform(self)
    }
}
