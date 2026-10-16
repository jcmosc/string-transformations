import Testing

@testable import StringTransformations

@Suite
struct ConstantCaseTransformerTests {
    @Test func transform() async throws {
        let tests = [
            ("simpleOneTwo", "SIMPLE_ONE_TWO"),
            ("myURL", "MY_URL"),
            ("thisIsAnXMLProperty", "THIS_IS_AN_XML_PROPERTY"),
            ("LeadingCaps", "LEADING_CAPS"),
            ("version4Thing", "VERSION4_THING"),
            ("kebab-case-input", "KEBAB_CASE_INPUT"),
            ("ALREADY_CONSTANT", "ALREADY_CONSTANT"),
            ("_oneTwo", "_ONE_TWO"),
            ("single", "SINGLE"),
            ("", ""),
            ("🐧🐟", "🐧🐟"),
        ]

        let transformer = ConstantCaseTransformer()
        for test in tests {
            let expected = test.1
            let actual = transformer.transform(test.0)
            #expect(expected == actual)
        }
    }
}
