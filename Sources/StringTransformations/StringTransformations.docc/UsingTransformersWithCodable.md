# Using Transformers with Codable

Convert the keys of encoded data, and store transformers as part of your configuration.

## Overview

Transformers convert any string, which makes them useful for converting the keys of encoded data
between the conventions of a data format and the names of Swift properties. Transformers are also
`Codable` themselves, so you can store how to convert keys alongside the rest of your
configuration.

### Convert keys when decoding JSON

`JSONDecoder` accepts a custom key decoding strategy that converts each key in the data to the
name of a property. A camel-case transformer that assumes snake-case input, and knows the
acronyms your property names use, produces names that follow the Swift API Design Guidelines:

```swift
struct User: Codable {
    var userID: Int
    var avatarURL: String
}

struct AnyCodingKey: CodingKey {
    var stringValue: String
    var intValue: Int?

    init(stringValue: String) {
        self.stringValue = stringValue
    }

    init?(intValue: Int) {
        self.stringValue = String(intValue)
        self.intValue = intValue
    }
}

let propertyNames = CamelCaseTransformer(
    wordSplittingStrategy: .convertFromSnakeCase,
    knownWords: ["ID", "URL"]
)

let decoder = JSONDecoder()
decoder.keyDecodingStrategy = .custom { codingPath in
    let key = codingPath.last!
    // Leave the keys of array elements alone.
    guard key.intValue == nil else {
        return key
    }
    return AnyCodingKey(stringValue: key.stringValue.transformed(using: propertyNames))
}

let json = #"{"user_id": 1, "avatar_url": "avatar.png"}"#
let user = try decoder.decode(User.self, from: Data(json.utf8))
```

Without the known words, the keys would convert to `userId` and `avatarUrl`, which don't match
the properties.

### Convert keys when encoding JSON

`JSONEncoder` accepts a custom key encoding strategy in the same way. The default word splitting
strategy splits property names at changes of case:

```swift
let snakeCaseKeys = SnakeCaseTransformer(knownWords: ["ID", "URL"])

let encoder = JSONEncoder()
encoder.keyEncodingStrategy = .custom { codingPath in
    AnyCodingKey(stringValue: codingPath.last!.stringValue.transformed(using: snakeCaseKeys))
}

let data = try encoder.encode(user)
// Encodes the keys "user_id" and "avatar_url".
```

Known words matter when encoding too: without `"IDs"`, a property named `userIDs` would be encoded
as `user_i_ds`.

### Store and compare transformers

Every transformer is `Codable` and `Hashable`, including its word splitting strategy and known
words. You can save a transformer in a configuration file, send it to another process, or use it
as a dictionary key, and get back a transformer that behaves the same way:

```swift
let data = try JSONEncoder().encode(propertyNames)
let decoded = try JSONDecoder().decode(CamelCaseTransformer.self, from: data)
// decoded == propertyNames
```

## See Also

- <doc:PreservingAcronymsAndKnownWords>
- <doc:AssumingASourceCase>
