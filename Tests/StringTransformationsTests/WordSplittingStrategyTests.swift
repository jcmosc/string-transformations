import Foundation
import Testing

@testable import StringTransformations

@Suite
struct WordSplittingStrategyTests {
    @Test func useDefaultBoundaries() async throws {
        let transformer = SnakeCaseTransformer(wordSplittingStrategy: .useDefaultBoundaries)
        #expect(transformer.transform("John-McCarthy") == "john_mc_carthy")
        #expect(transformer.transform("my_varName") == "my_var_name")
    }

    @Test func separatedSourceCases() async throws {
        // Case changes within words are not split.
        #expect(SnakeCaseTransformer(wordSplittingStrategy: .convertFromKebabCase).transform("John-McCarthy") == "john_mccarthy")
        #expect(SnakeCaseTransformer(wordSplittingStrategy: .convertFromTrainCase).transform("Content-Type") == "content_type")
        #expect(CamelCaseTransformer(wordSplittingStrategy: .convertFromSnakeCase).transform("this_aNd_that") == "thisAndThat")
        #expect(KebabCaseTransformer(wordSplittingStrategy: .convertFromConstantCase).transform("MY_URL") == "my-url")
        #expect(SnakeCaseTransformer(wordSplittingStrategy: .convertFromDotCase).transform("server.portNumber") == "server_portnumber")

        // Separators of other cases are part of the word.
        #expect(KebabCaseTransformer(wordSplittingStrategy: .convertFromSnakeCase).transform("my_file.name") == "my-file.name")
        #expect(SnakeCaseTransformer(wordSplittingStrategy: .convertFromDotCase).transform("my_file.name") == "my_file_name")
    }

    @Test func caseChangeSourceCases() async throws {
        // Separators are part of the word.
        #expect(SnakeCaseTransformer(wordSplittingStrategy: .convertFromCamelCase).transform("my_varName") == "my_var_name")
        #expect(KebabCaseTransformer(wordSplittingStrategy: .convertFromCamelCase).transform("my_varName") == "my_var-name")
        #expect(KebabCaseTransformer(wordSplittingStrategy: .convertFromPascalCase).transform("XMLHttpRequest") == "xml-http-request")
    }

    @Test func leadingAndTrailingSeparators() async throws {
        #expect(KebabCaseTransformer(wordSplittingStrategy: .convertFromSnakeCase).transform("_private_name_") == "_private-name_")
        #expect(SnakeCaseTransformer(wordSplittingStrategy: .convertFromKebabCase).transform("_private-name") == "_private_name")
        #expect(SnakeCaseTransformer(wordSplittingStrategy: .convertFromSnakeCase).transform("___") == "___")
        #expect(SnakeCaseTransformer(wordSplittingStrategy: .convertFromSnakeCase).transform("") == "")
    }

    @Test func staticAccessors() async throws {
        #expect("John-McCarthy".transformed(using: .snakeCase(wordSplittingStrategy: .convertFromKebabCase)) == "john_mccarthy")
        #expect("this_aNd_that".transformed(using: .camelCase(wordSplittingStrategy: .convertFromSnakeCase)) == "thisAndThat")
    }

    @Test func codable() async throws {
        let transformer = PascalCaseTransformer(wordSplittingStrategy: .convertFromKebabCase)
        let data = try JSONEncoder().encode(transformer)
        #expect(try JSONDecoder().decode(PascalCaseTransformer.self, from: data) == transformer)
    }
}
