import Testing

@testable import StringTransformations

@Suite
struct SnakeCaseTransformerTests {
    /// Test cases duplicated from Foundation/JSONEncoderTests.swift
    @Test func foundationJSONEncoder() async throws {
        let toSnakeCaseTests = [
            ("simpleOneTwo", "simple_one_two"),
            ("myURL", "my_url"),
            ("singleCharacterAtEndX", "single_character_at_end_x"),
            ("thisIsAnXMLProperty", "this_is_an_xml_property"),
            ("single", "single"),  // no underscore
            ("", ""),  // don't die on empty string
            ("a", "a"),  // single character
            ("aA", "a_a"),  // two characters
            ("version4Thing", "version4_thing"),  // numerics
            ("partCAPS", "part_caps"),  // only insert underscore before first all caps
            ("partCAPSLowerAGAIN", "part_caps_lower_again"),  // switch back and forth caps.
            ("manyWordsInThisThing", "many_words_in_this_thing"),  // simple lowercase + underscore + more
            ("asdfĆqer", "asdf_ćqer"),
            ("already_snake_case", "already_snake_case"),
            ("dataPoint22", "data_point22"),
            ("dataPoint22Word", "data_point22_word"),
            ("_oneTwoThree", "_one_two_three"),
            ("oneTwoThree_", "one_two_three_"),
            ("__oneTwoThree", "__one_two_three"),
            ("oneTwoThree__", "one_two_three__"),
            ("_oneTwoThree_", "_one_two_three_"),
            ("__oneTwoThree", "__one_two_three"),
            ("__oneTwoThree__", "__one_two_three__"),
            ("_test", "_test"),
            ("_test_", "_test_"),
            ("__test", "__test"),
            ("test__", "test__"),
            ("m͉̟̹y̦̳G͍͚͎̳r̤͉̤͕ͅea̲͕t͇̥̼͖U͇̝̠R͙̻̥͓̣L̥̖͎͓̪̫ͅR̩͖̩eq͈͓u̞e̱s̙t̤̺ͅ", "m͉̟̹y̦̳_g͍͚͎̳r̤͉̤͕ͅea̲͕t͇̥̼͖_u͇̝̠r͙̻̥͓̣l̥̖͎͓̪̫ͅ_r̩͖̩eq͈͓u̞e̱s̙t̤̺ͅ"),  // because Itai wanted to test this
            ("🐧🐟", "🐧🐟"),  // fishy emoji example?
        ]

        let transformer = SnakeCaseTransformer()
        for test in toSnakeCaseTests {
            let expected = test.1
            let actual = transformer.transform(test.0)
            #expect(expected == actual)
        }
    }

    @Test func extra() async throws {
        let toSnakeCaseTests = [
            ("LeadingCaps", "leading_caps"),  // leading caps, from Foundation/JSONEncoderTests.swift
            ("familyPhoto.png", "family_photo_png"),  // periods split words, including file extensions
            ("vector3D", "vector3_d"),  // digits stay with the word before them
            ("utf8String", "utf8_string"),
            ("x½Y", "x½_y"),  // only letters have case, as in Foundation
            ("🐧Fish", "🐧_fish"),
            ("MY_URL", "my_url"),  // no assumed input case; Foundation assumes a lowercase first letter: "m_y_url"
        ]

        let transformer = SnakeCaseTransformer()
        for test in toSnakeCaseTests {
            let expected = test.1
            let actual = transformer.transform(test.0)
            #expect(expected == actual)
        }
    }
}
