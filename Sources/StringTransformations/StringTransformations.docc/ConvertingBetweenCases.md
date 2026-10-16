# Converting Between Cases

Convert a string to another case using a method, a transformer accessor or a transformer value.

## Overview

StringTransformations gives you three ways to convert a string. They all produce the same result,
so choose the one that suits the code you're writing.

### Call a method for the case you want

Each case has a method on `String` that returns a converted copy, in the same way that
`lowercased()` and `uppercased()` do:

```swift
"user_id".camelCased()              // "userId"
"user_id".pascalCased()             // "UserId"
"myURL".snakeCased()                // "my_url"
"maxRetryCount".constantCased()     // "MAX_RETRY_COUNT"
"XMLHttpRequest".kebabCased()       // "xml-http-request"
"content_type".trainCased()         // "Content-Type"
"serverPort".dotCased()             // "server.port"
```

These methods use each transformer's default configuration.

### Pass a transformer to a string

To choose a case at runtime, or to configure how a string is converted, pass a transformer to
``Swift/String/transformed(using:)``. ``StringTransformer`` has a static accessor for each case,
so you can write the case's name with a leading period:

```swift
"myURL".transformed(using: .snakeCase)                                // "my_url"
"user_ids".transformed(using: .camelCase(knownWords: ["IDs"]))        // "userIDs"
```

To convert a string in place, use ``Swift/String/transform(using:)``:

```swift
var key = "myURL"
key.transform(using: .snakeCase)
print(key)
// Prints "my_url"
```

### Use a transformer directly

Transformers are values. Create one, configure it once, and use it as many times as you need:

```swift
let transformer = CamelCaseTransformer(
    wordSplittingStrategy: .convertFromSnakeCase,
    knownWords: ["ID", "URL"]
)

transformer.transform("user_id")      // "userID"
transformer.transform("avatar_url")   // "avatarURL"
```

Because each transformer conforms to ``StringTransformer``, code that converts strings can accept
any case:

```swift
func normalizedKeys(_ keys: [String], using transformer: some StringTransformer) -> [String] {
    keys.map { $0.transformed(using: transformer) }
}
```

### Configure a transformer

Every case transformer has two properties:

- term `wordSplittingStrategy`: How strings are split into words. By default, strings are split at
  every separator and change of case. See <doc:AssumingASourceCase>.
- term `knownWords`: Words with a fixed spelling, such as acronyms, that are kept together and
  keep their spelling. See <doc:PreservingAcronymsAndKnownWords>.

You can set them when you create a transformer, or when you use a static accessor:

```swift
"Content-Type".transformed(
    using: .constantCase(wordSplittingStrategy: .convertFromTrainCase)
)
// "CONTENT_TYPE"
```

## See Also

- <doc:HowStringsAreSplitIntoWords>
- ``StringTransformer``
