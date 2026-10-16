import Foundation
import Testing
import StringTransformations

struct COBOLCaseTransformer: StringTransformer {
    var kebabCase = KebabCaseTransformer()

    func transform(_ value: String) -> String {
        kebabCase.transform(value).uppercased()
    }
}

extension StringTransformer where Self == COBOLCaseTransformer {
    static var cobolCase: COBOLCaseTransformer { .init() }
}

struct AnyCodingKey: CodingKey {
    var stringValue: String
    var intValue: Int?
    init(stringValue: String) { self.stringValue = stringValue }
    init?(intValue: Int) { self.stringValue = String(intValue); self.intValue = intValue }
}

struct User: Codable { var userID: Int; var avatarURL: String }

/// Checks the examples used in the documentation catalog.
@Test func documentationExamples() throws {
    let e: [(String, String)] = [
        ("user_id".camelCased(), "userId"),
        ("user_id".pascalCased(), "UserId"),
        ("myURL".snakeCased(), "my_url"),
        ("maxRetryCount".constantCased(), "MAX_RETRY_COUNT"),
        ("XMLHttpRequest".kebabCased(), "xml-http-request"),
        ("content_type".trainCased(), "Content-Type"),
        ("serverPort".dotCased(), "server.port"),
        ("myURL".transformed(using: .snakeCase), "my_url"),
        ("_privateName".snakeCased(), "_private_name"),
        ("__init__".camelCased(), "__init__"),
        ("version4Thing".snakeCased(), "version4_thing"),
        ("utf8String".snakeCased(), "utf8_string"),
        ("vector3D".snakeCased(), "vector3_d"),
        ("word2vec".snakeCased(), "word2vec"),
        ("user_ids".transformed(using: .camelCase(knownWords: ["IDs"])), "userIDs"),
        ("myURLs".transformed(using: .snakeCase(knownWords: ["URLs"])), "my_urls"),
        ("myURLs".snakeCased(), "my_ur_ls"),
        ("John-McCarthy".transformed(using: .snakeCase(wordSplittingStrategy: .convertFromKebabCase)), "john_mccarthy"),
        ("John-McCarthy".snakeCased(), "john_mc_carthy"),
        ("ǆemal_x".pascalCased(), "ǅemalX"),
        ("größe_änderung".camelCased(), "größeÄnderung"),
        ("ΜΕΓΑΛΟ_ΟΝΟΜΑ".camelCased(), "μεγαλοΟνομα"),
        ("my-url".snakeCased(), "my_url"),
        ("my url".snakeCased(), "my_url"),
        ("my.url".snakeCased(), "my_url"),
        ("first  name".snakeCased(), "first_name"),
        ("first-_name".snakeCased(), "first_name"),
        ("familyPhoto.png".snakeCased(), "family_photo_png"),
        ("MY_URL".camelCased(), "myUrl"),
        ("XMLProperty".snakeCased(), "xml_property"),
        ("thisIsAnXMLProperty".snakeCased(), "this_is_an_xml_property"),
        ("LeadingCaps".snakeCased(), "leading_caps"),
        ("🐧Fish".snakeCased(), "🐧_fish"),
        ("__dunder__".kebabCased(), "__dunder__"),
        ("_one_two_".camelCased(), "_oneTwo_"),
        ("___".camelCased(), "___"),
        ("".camelCased(), ""),
        ("this_aNd_that".camelCased(), "thisANdThat"),
        ("this_aNd_that".transformed(using: .camelCase(wordSplittingStrategy: .convertFromSnakeCase)), "thisAndThat"),
        ("my_varName".transformed(using: .snakeCase(wordSplittingStrategy: .convertFromCamelCase)), "my_var_name"),
        ("my_varName".transformed(using: .kebabCase(wordSplittingStrategy: .convertFromCamelCase)), "my_var-name"),
        ("my_varName".kebabCased(), "my-var-name"),
        ("server.portNumber".transformed(using: .snakeCase(wordSplittingStrategy: .convertFromDotCase)), "server_portnumber"),
        ("Content-Type".transformed(using: .constantCase(wordSplittingStrategy: .convertFromTrainCase)), "CONTENT_TYPE"),
        ("HTTPURLResponse".snakeCased(), "httpurl_response"),
        ("HTTPURLResponse".transformed(using: .snakeCase(knownWords: ["HTTP", "URL"])), "http_url_response"),
        ("url_session".transformed(using: .camelCase(knownWords: ["URL"])), "urlSession"),
        ("url_session".transformed(using: .pascalCase(knownWords: ["URL"])), "URLSession"),
        ("x-request-id".transformed(using: .trainCase(knownWords: ["ID"])), "X-Request-ID"),
        ("ios_version".transformed(using: .pascalCase(knownWords: ["iOS"])), "iOSVersion"),
        ("iOSVersion".transformed(using: .constantCase(knownWords: ["iOS"])), "IOS_VERSION"),
        ("OAuthToken".snakeCased(), "o_auth_token"),
        ("OAuthToken".transformed(using: .snakeCase(knownWords: ["OAuth"])), "oauth_token"),
        ("myCURLRequest".transformed(using: .snakeCase(knownWords: ["URL"])), "my_curl_request"),
        ("valid_id".transformed(using: .camelCase(knownWords: ["ID"])), "validID"),
        ("MY_URL".transformed(using: .camelCase(knownWords: ["URL"])), "myURL"),
        ("myAPIKey".transformed(using: .cobolCase), "MY-API-KEY"),
        ("Title Case Input".camelCased(), "titleCaseInput"),
        ("avatar_url".transformed(using: .camelCase(wordSplittingStrategy: .convertFromSnakeCase, knownWords: ["ID", "URL"])), "avatarURL"),
        ("avatar_url".transformed(using: .camelCase(wordSplittingStrategy: .convertFromSnakeCase)), "avatarUrl"),
        ("userIDs".transformed(using: .snakeCase(knownWords: ["ID", "URL"])), "user_i_ds"),
        ("userIDs".transformed(using: .snakeCase(knownWords: ["ID", "IDs", "URL"])), "user_ids"),
    ]
    for (actual, expected) in e { #expect(actual == expected) }

    var key = "myURL"
    key.transform(using: .snakeCase)
    #expect(key == "my_url")

    let swiftNames = CamelCaseTransformer(wordSplittingStrategy: .convertFromSnakeCase, knownWords: ["ID", "URL"])
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .custom { codingPath in
        let key = codingPath.last!
        guard key.intValue == nil else { return key }
        return AnyCodingKey(stringValue: key.stringValue.transformed(using: swiftNames))
    }
    let user = try decoder.decode(User.self, from: Data(#"{"user_id": 1, "avatar_url": "a.png"}"#.utf8))
    #expect(user.userID == 1 && user.avatarURL == "a.png")

    let snakeKeys = SnakeCaseTransformer(knownWords: ["ID", "URL"])
    let encoder = JSONEncoder()
    encoder.outputFormatting = .sortedKeys
    encoder.keyEncodingStrategy = .custom { codingPath in
        AnyCodingKey(stringValue: codingPath.last!.stringValue.transformed(using: snakeKeys))
    }
    let json = String(decoding: try encoder.encode(user), as: UTF8.self)
    #expect(json == #"{"avatar_url":"a.png","user_id":1}"#)

    let data = try JSONEncoder().encode(swiftNames)
    #expect(try JSONDecoder().decode(CamelCaseTransformer.self, from: data) == swiftNames)
    let set: Set<CamelCaseTransformer> = [.camelCase, .init()]
    #expect(set.count == 1)
}
