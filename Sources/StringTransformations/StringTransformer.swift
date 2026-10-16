/// A type that transforms a given string into another representation.
public protocol StringTransformer: Codable, Hashable {

    /// Returns the result of transforming a given string.
    ///
    /// - Parameter value: The string to transform.
    /// - Returns: The result of transforming `value`.
    func transform(_ value: String) -> String
}
