import Testing

@testable import StringTransformations

@Suite
struct DotCaseTransformerTests {
    @Test func transform() async throws {
        let tests = [
            ("simpleOneTwo", "simple.one.two"),
            ("myURL", "my.url"),
            ("snake_case_input", "snake.case.input"),
            ("thisIsAnXMLProperty", "this.is.an.xml.property"),
            ("already.dot.case", "already.dot.case"),
            ("_oneTwo", "_one.two"),
            ("single", "single"),
            ("", ""),
            ("🐧🐟", "🐧🐟"),
        ]

        let transformer = DotCaseTransformer()
        for test in tests {
            let expected = test.1
            let actual = transformer.transform(test.0)
            #expect(expected == actual)
        }
    }
}
