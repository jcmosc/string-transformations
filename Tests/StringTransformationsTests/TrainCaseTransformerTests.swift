import Testing

@testable import StringTransformations

@Suite
struct TrainCaseTransformerTests {
    @Test func transform() async throws {
        let tests = [
            ("simpleOneTwo", "Simple-One-Two"),
            ("myURL", "My-Url"),
            ("content_type", "Content-Type"),
            ("X-Request-ID", "X-Request-Id"),
            ("thisIsAnXMLProperty", "This-Is-An-Xml-Property"),
            ("version4Thing", "Version4-Thing"),
            ("_oneTwo", "_One-Two"),
            ("single", "Single"),
            ("", ""),
            ("🐧🐟", "🐧🐟"),
            ("ǆemal_x", "ǅemal-X"),  // titlecase, not uppercase
        ]

        let transformer = TrainCaseTransformer()
        for test in tests {
            let expected = test.1
            let actual = transformer.transform(test.0)
            #expect(expected == actual)
        }
    }
}
