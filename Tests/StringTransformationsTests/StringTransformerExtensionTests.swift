import Testing

@testable import StringTransformations

@Suite
struct StringTransformerExtensionTests {
    @Test func transformed() async throws {
        #expect("myURL".transformed(using: .snakeCase) == "my_url")
        #expect("my_url".transformed(using: .camelCase) == "myUrl")
        #expect("my_url".transformed(using: .pascalCase) == "MyUrl")
    }

    @Test func transform() async throws {
        var value = "myURL"
        value.transform(using: .snakeCase)
        #expect(value == "my_url")
        value.transform(using: .pascalCase)
        #expect(value == "MyUrl")
        value.transform(using: .camelCase)
        #expect(value == "myUrl")
    }
}
