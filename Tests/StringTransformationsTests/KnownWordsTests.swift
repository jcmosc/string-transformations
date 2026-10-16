import Foundation
import Testing

@testable import StringTransformations

@Suite
struct KnownWordsTests {
    @Test func splitting() async throws {
        let transformer = SnakeCaseTransformer(knownWords: ["URL", "URLs", "ID", "IDs", "HTTP", "iOS", "OAuth"])
        #expect(transformer.transform("myURLs") == "my_urls")
        #expect(transformer.transform("userIDs") == "user_ids")
        #expect(transformer.transform("HTTPURLResponse") == "http_url_response")
        #expect(transformer.transform("OAuthToken") == "oauth_token")
        #expect(transformer.transform("app2iOSVersion") == "app2_ios_version")
        #expect(transformer.transform("iOSVersion") == "ios_version")
        #expect(transformer.transform("") == "")
    }

    @Test func partialMatches() async throws {
        let transformer = SnakeCaseTransformer(knownWords: ["URL", "ID", "iOS"])
        // Known words aren't found inside runs of letters of the same case.
        #expect(transformer.transform("myCURLRequest") == "my_curl_request")
        #expect(transformer.transform("radiOS") == "radi_os")
        #expect(transformer.transform("myiOSApp") == "myi_os_app")
        // Known words aren't found when a lowercase letter continues them.
        #expect(transformer.transform("IDentity") == "i_dentity")
        // Matching is case-sensitive.
        #expect(transformer.transform("valid") == "valid")
        #expect(transformer.transform("myUrls") == "my_urls")
        // Without "URLs", the plural splits as usual.
        #expect(transformer.transform("myURLs") == "my_ur_ls")
    }

    @Test func spelling() async throws {
        let knownWords: Set<String> = ["ID", "IDs", "URL", "iOS"]
        #expect(CamelCaseTransformer(knownWords: knownWords).transform("user_id") == "userID")
        #expect(CamelCaseTransformer(knownWords: knownWords).transform("user_ids") == "userIDs")
        #expect(CamelCaseTransformer(knownWords: knownWords).transform("MY_URL") == "myURL")
        // The first word of a camel-case string is lowercased.
        #expect(CamelCaseTransformer(knownWords: knownWords).transform("url_session") == "urlSession")
        #expect(PascalCaseTransformer(knownWords: knownWords).transform("url_session") == "URLSession")
        #expect(PascalCaseTransformer(knownWords: knownWords).transform("ios_version") == "iOSVersion")
        #expect(TrainCaseTransformer(knownWords: knownWords).transform("x-request-id") == "X-Request-ID")
        #expect(TitleCaseTransformer(knownWords: knownWords).transform("x_request_id") == "X Request ID")
        // Sentence case uses the spelling for every word, not only capitalized ones.
        #expect(SentenceCaseTransformer(knownWords: knownWords).transform("user_id") == "User ID")
        #expect(SentenceCaseTransformer(knownWords: knownWords).transform("id_number") == "ID number")
        #expect(SentenceCaseTransformer(knownWords: knownWords).transform("ios_version") == "iOS version")
        // Cases that don't capitalize words ignore the spelling.
        #expect(ConstantCaseTransformer(knownWords: knownWords).transform("iOSVersion") == "IOS_VERSION")
        #expect(KebabCaseTransformer(knownWords: knownWords).transform("userIDs") == "user-ids")
    }

    @Test func wordSplittingStrategies() async throws {
        // Known words keep their spelling without splitting at case changes.
        let transformer = CamelCaseTransformer(wordSplittingStrategy: .convertFromSnakeCase, knownWords: ["ID"])
        #expect(transformer.transform("user_id") == "userID")
        #expect(transformer.transform("this_aNd_that") == "thisAndThat")
    }

    @Test func spellingsDifferingOnlyByCase() async throws {
        // The first spelling in sorted order is used.
        let transformer = PascalCaseTransformer(knownWords: ["IDs", "IDS"])
        #expect(transformer.transform("user_ids") == "UserIDS")
    }

    @Test func staticAccessors() async throws {
        #expect("user_id".transformed(using: .camelCase(knownWords: ["ID"])) == "userID")
        #expect("myURLs".transformed(using: .snakeCase(knownWords: ["URLs"])) == "my_urls")
        #expect("user_id".transformed(using: .camelCase) == "userId")
    }

    @Test func codable() async throws {
        let transformer = CamelCaseTransformer(knownWords: ["ID", "URL"])
        let data = try JSONEncoder().encode(transformer)
        #expect(try JSONDecoder().decode(CamelCaseTransformer.self, from: data) == transformer)
    }
}
