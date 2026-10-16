import Testing

@testable import StringTransformations

@Suite
struct CamelCaseTransformerTests {
    /// Test cases copied from Foundation/JSONEncoderTests.swift (`decodingKeyStrategyCamel`), which
    /// tests `JSONDecoder.KeyDecodingStrategy.convertFromSnakeCase`.
    ///
    /// Foundation only splits on underscores, while this transformer also splits on case changes, so
    /// the cases that differ are noted inline.
    ///
    /// - See: https://github.com/swiftlang/swift-foundation/blob/release/6.4.0/Tests/FoundationEssentialsTests/JSONEncoderTests.swift
    @Test func foundationJSONDecoder() async throws {
        let toCamelCaseTests = [
            ("", ""), // don't die on empty string
            ("a", "a"), // single character
            ("ALLCAPS", "allcaps"), // Foundation leaves words without underscores as-is: "ALLCAPS"
            ("ALL_CAPS", "allCaps"), // Conversion from screaming snake case
            ("single", "single"), // do not capitalize anything with no underscore
            ("snake_case", "snakeCase"), // capitalize a character
            ("one_two_three", "oneTwoThree"), // more than one word
            ("one_2_three", "one2Three"), // numerics
            ("one2_three", "one2Three"), // numerics, part 2
            ("snake_Ćase", "snakeĆase"), // do not further modify a capitalized diacritic
            ("snake_ćase", "snakeĆase"), // capitalize a diacritic
            ("alreadyCamelCase", "alreadyCamelCase"), // do not modify already camel case
            ("__this_and_that", "__thisAndThat"),
            ("_this_and_that", "_thisAndThat"),
            ("this__and__that", "thisAndThat"),
            ("this_and_that__", "thisAndThat__"),
            ("this_aNd_that", "thisANdThat"), // "aNd" splits at the case change; Foundation: "thisAndThat"
            ("_one_two_three", "_oneTwoThree"),
            ("one_two_three_", "oneTwoThree_"),
            ("__one_two_three", "__oneTwoThree"),
            ("one_two_three__", "oneTwoThree__"),
            ("_one_two_three_", "_oneTwoThree_"),
            ("__one_two_three", "__oneTwoThree"),
            ("__one_two_three__", "__oneTwoThree__"),
            ("_test", "_test"),
            ("_test_", "_test_"),
            ("__test", "__test"),
            ("test__", "test__"),
            ("_", "_"),
            ("__", "__"),
            ("___", "___"),
            ("m͉̟̹y̦̳G͍͚͎̳r̤͉̤͕ͅea̲͕t͇̥̼͖U͇̝̠R͙̻̥͓̣L̥̖͎͓̪̫ͅR̩͖̩eq͈͓u̞e̱s̙t̤̺ͅ", "m͉̟̹y̦̳G͍͚͎̳r̤͉̤͕ͅea̲͕t͇̥̼͖U͇̝̠r͙̻̥͓̣l̥̖͎͓̪̫ͅR̩͖̩eq͈͓u̞e̱s̙t̤̺ͅ"), // the acronym "URL" becomes "Url"; Foundation leaves words without underscores as-is
            ("🐧_🐟", "🐧🐟"),  // fishy emoji example?
        ]

        let transformer = CamelCaseTransformer()
        for test in toCamelCaseTests {
            let expected = test.1
            let actual = transformer.transform(test.0)
            #expect(expected == actual)
        }
    }

    @Test func otherCases() async throws {
        let toCamelCaseTests = [
            ("my_url", "myUrl"),
            ("this_is_an_xml_property", "thisIsAnXmlProperty"),
            ("version4_thing", "version4Thing"),
            ("data_point22_word", "dataPoint22Word"),
            ("myURL", "myUrl"),
            ("XMLHttpRequest", "xmlHttpRequest"),
            ("kebab-case-input", "kebabCaseInput"),
            ("Title Case Input", "titleCaseInput"),
            ("CONSTANT_CASE", "constantCase"),
            ("alreadyCamelCase", "alreadyCamelCase"),
        ]

        let transformer = CamelCaseTransformer()
        for test in toCamelCaseTests {
            let expected = test.1
            let actual = transformer.transform(test.0)
            #expect(expected == actual)
        }
    }
}
