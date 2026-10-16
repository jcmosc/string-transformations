import Testing

@testable import StringTransformations

@Suite
struct KebabCaseTransformerTests {
    @Test func transform() async throws {
        let tests = [
            ("simpleOneTwo", "simple-one-two"),
            ("myURL", "my-url"),
            ("thisIsAnXMLProperty", "this-is-an-xml-property"),
            ("LeadingCaps", "leading-caps"),
            ("version4Thing", "version4-thing"),
            ("dataPoint22Word", "data-point22-word"),
            ("already-kebab-case", "already-kebab-case"),
            ("snake_case_input", "snake-case-input"),
            ("Title Case Input", "title-case-input"),
            ("CONSTANT_CASE", "constant-case"),
            ("_oneTwo", "_one-two"),
            ("oneTwo__", "one-two__"),
            ("single", "single"),
            ("", ""),
            ("___", "___"),
            ("asdfĆqer", "asdf-ćqer"),
            ("🐧🐟", "🐧🐟"),
        ]

        let transformer = KebabCaseTransformer()
        for test in tests {
            let expected = test.1
            let actual = transformer.transform(test.0)
            #expect(expected == actual)
        }
    }
}
