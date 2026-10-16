import Testing

@testable import StringTransformations

@Suite
struct PascalCaseTransformerTests {
    /// Inputs adapted from Foundation/JSONEncoderTests.swift
    ///
    /// - See: https://github.com/swiftlang/swift-foundation/blob/release/6.4.0/Tests/FoundationEssentialsTests/JSONEncoderTests.swift
    @Test func foundationJSONEncoder() async throws {
        let toPascalCaseTests = [
            ("simple_one_two", "SimpleOneTwo"),
            ("my_url", "MyUrl"),
            ("single_character_at_end_x", "SingleCharacterAtEndX"),
            ("this_is_an_xml_property", "ThisIsAnXmlProperty"),
            ("single", "Single"),
            ("", ""),
            ("a", "A"),
            ("a_a", "AA"),
            ("version4_thing", "Version4Thing"),
            ("part_caps", "PartCaps"),
            ("part_caps_lower_again", "PartCapsLowerAgain"),
            ("many_words_in_this_thing", "ManyWordsInThisThing"),
            ("asdf_ćqer", "AsdfĆqer"),
            ("already_snake_case", "AlreadySnakeCase"),
            ("data_point22", "DataPoint22"),
            ("data_point22_word", "DataPoint22Word"),
            ("_one_two_three", "_OneTwoThree"),
            ("one_two_three_", "OneTwoThree_"),
            ("__one_two_three", "__OneTwoThree"),
            ("one_two_three__", "OneTwoThree__"),
            ("_one_two_three_", "_OneTwoThree_"),
            ("__one_two_three__", "__OneTwoThree__"),
            ("_test", "_Test"),
            ("_test_", "_Test_"),
            ("__test", "__Test"),
            ("test__", "Test__"),
            ("m͉̟̹y̦̳_g͍͚͎̳r̤͉̤͕ͅea̲͕t͇̥̼͖_u͇̝̠r͙̻̥͓̣l̥̖͎͓̪̫ͅ_r̩͖̩eq͈͓u̞e̱s̙t̤̺ͅ", "M͉̟̹y̦̳G͍͚͎̳r̤͉̤͕ͅea̲͕t͇̥̼͖U͇̝̠r͙̻̥͓̣l̥̖͎͓̪̫ͅR̩͖̩eq͈͓u̞e̱s̙t̤̺ͅ"),
            ("🐧🐟", "🐧🐟"),
        ]

        let transformer = PascalCaseTransformer()
        for test in toPascalCaseTests {
            let expected = test.1
            let actual = transformer.transform(test.0)
            #expect(expected == actual)
        }
    }

    @Test func otherCases() async throws {
        let toPascalCaseTests = [
            ("myURL", "MyUrl"),
            ("XMLHttpRequest", "XmlHttpRequest"),
            ("kebab-case-input", "KebabCaseInput"),
            ("Title Case Input", "TitleCaseInput"),
            ("CONSTANT_CASE", "ConstantCase"),
            ("AlreadyPascalCase", "AlreadyPascalCase"),
            ("ǆemal_x", "ǅemalX"),  // titlecase, not uppercase
            ("ǄEMAL", "ǅemal"),
        ]

        let transformer = PascalCaseTransformer()
        for test in toPascalCaseTests {
            let expected = test.1
            let actual = transformer.transform(test.0)
            #expect(expected == actual)
        }
    }
}
