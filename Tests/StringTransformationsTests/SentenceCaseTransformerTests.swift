import Testing

@testable import StringTransformations

@Suite
struct SentenceCaseTransformerTests {
    @Test func transform() async throws {
        let tests = [
            ("simpleOneTwo", "Simple one two"),
            ("myURL", "My url"),
            ("user_id", "User id"),
            ("HELLO_WORLD", "Hello world"),
            ("XMLHttpRequest", "Xml http request"),
            ("Title Case Input", "Title case input"),
            ("_privateName", "_Private name"),
            ("ǆemal_x", "ǅemal x"),
            ("single", "Single"),
            ("", ""),
            ("🐧🐟", "🐧🐟"),
        ]

        let transformer = SentenceCaseTransformer()
        for test in tests {
            let expected = test.1
            let actual = transformer.transform(test.0)
            #expect(expected == actual)
        }
    }
}
