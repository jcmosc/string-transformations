import Testing

@testable import StringTransformations

@Suite
struct TitleCaseTransformerTests {
    @Test func transform() async throws {
        let tests = [
            ("simpleOneTwo", "Simple One Two"),
            ("myURL", "My Url"),
            ("user_id", "User Id"),
            ("content-type", "Content Type"),
            ("XMLHttpRequest", "Xml Http Request"),
            ("version4Thing", "Version4 Thing"),
            ("_privateName", "_Private Name"),
            ("hello world", "Hello World"),
            ("  padded  ", "  Padded  "),
            ("ǆemal_x", "ǅemal X"),
            ("single", "Single"),
            ("", ""),
            ("🐧🐟", "🐧🐟"),
        ]

        let transformer = TitleCaseTransformer()
        for test in tests {
            let expected = test.1
            let actual = transformer.transform(test.0)
            #expect(expected == actual)
        }
    }
}
