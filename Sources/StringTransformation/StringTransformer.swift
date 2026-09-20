/// A type that transforms a given string into another representation.
public protocol StringTransformer: Codable, Hashable {

    /// Returns the result of transforming a given string.
    ///
    /// - Parameter value: The string to transform.
    /// - Returns: The result of transforming `value`. The default implementation simply returns `value`.
    func transform(_ value: String) -> String
}

extension StringTransformer {
    public func transform(_ value: String) -> String {
        value
    }
}
