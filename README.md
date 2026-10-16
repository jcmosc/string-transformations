# StringTransformations

Convert Swift strings between camel case, snake case, Title case and other naming conventions.

```swift
import StringTransformations

"user_id".camelCased()              // "userId"
"XMLHttpRequest".snakeCased()       // "xml_http_request"
"content_type".trainCased()         // "Content-Type"
"maxRetryCount".sentenceCased()     // "Max retry count"
```

## Features

- **Converts input in any case.** Strings are split at underscores, hyphens, periods, whitespace
  and changes of case, so you don't have to say what case the input is in. Acronym runs like
  `XML` are words of their own, and digits stay with the word before them.
- **Keeps leading and trailing separators**, so names like `_privateName` and `__init__` keep
  their meaning.
- **Known words** keep acronyms, their plurals and brand names together, with the spelling you
  choose: `user_ids` → `userIDs`, `myURLs` → `my_urls`, `ios_version` → `iOSVersion`.
- **Optional source case.** If you know what case the input is in, splitting can be limited to
  that case's separators, so `John McCarthy` → `john_mccarthy`.
- **Unicode.** Letters are classified by Unicode general category, combining marks stay with
  their letters, and capitalized words start with a titlecase letter (`ǆemal_x` → `ǅemalX`).
- **Matches Foundation.** Case changes are found the same way as `JSONEncoder`'s
  `convertToSnakeCase`.
- **Transformers are values** that are `Codable` and `Hashable`, and you can add your own cases
  through a protocol.
- **No dependencies**, not even Foundation.

## Supported cases

| Case | Method | Transformer | Example |
|---|---|---|---|
| camelCase | `camelCased()` | `CamelCaseTransformer` | `userId` |
| PascalCase | `pascalCased()` | `PascalCaseTransformer` | `UserId` |
| snake_case | `snakeCased()` | `SnakeCaseTransformer` | `user_id` |
| CONSTANT_CASE | `constantCased()` | `ConstantCaseTransformer` | `USER_ID` |
| kebab-case | `kebabCased()` | `KebabCaseTransformer` | `user-id` |
| Train-Case | `trainCased()` | `TrainCaseTransformer` | `User-Id` |
| dot.case | `dotCased()` | `DotCaseTransformer` | `user.id` |
| Title Case | `titleCased()` | `TitleCaseTransformer` | `User Id` |
| Sentence case | `sentenceCased()` | `SentenceCaseTransformer` | `User id` |

## Installation

Add the package to the dependencies in your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/jcmosc/string-transformations.git", branch: "main"),
],
```

Then add the `StringTransformations` product to your target:

```swift
.target(
    name: "MyTarget",
    dependencies: [
        .product(name: "StringTransformations", package: "string-transformations"),
    ]
),
```

The package needs Swift 6.4 or later.

## Usage

### Converting strings

Call the method for the case you want, or pass a transformer to `transformed(using:)`. To convert
a string in place, use `transform(using:)`:

```swift
"myURL".transformed(using: .snakeCase)      // "my_url"

var key = "myURL"
key.transform(using: .snakeCase)            // key == "my_url"
```

### Known words

List the words that have a fixed spelling, including any plurals. They're kept together when
splitting, and the cases that capitalize words use their spelling:

```swift
"user_id".transformed(using: .camelCase(knownWords: ["ID"]))                  // "userID"
"HTTPURLResponse".transformed(using: .snakeCase(knownWords: ["HTTP", "URL"]))  // "http_url_response"
"request_id".transformed(using: .sentenceCase(knownWords: ["ID"]))             // "Request ID"
```

### Assuming a source case

By default, strings are split at every separator and change of case. If you know the case of
your input, set a word splitting strategy so that only that case's separators split words:

```swift
"this_aNd_that".camelCased()                // "thisANdThat"
"this_aNd_that".transformed(
    using: .camelCase(wordSplittingStrategy: .convertFromSnakeCase)
)                                           // "thisAndThat"
```

### Configuring a transformer

Transformers are values, so you can configure one once, use it many times, and store it:

```swift
let propertyNames = CamelCaseTransformer(
    wordSplittingStrategy: .convertFromSnakeCase,
    knownWords: ["ID", "URL"]
)

propertyNames.transform("user_id")          // "userID"
propertyNames.transform("avatar_url")       // "avatarURL"
```

This works well as a custom `JSONDecoder` key decoding strategy, so JSON keys like `user_id`
decode into properties like `userID`.

## Documentation

The package includes a DocC catalog with articles explaining:

- how strings are split into words;
- how known words and source cases change the result;
- how to write your own transformers;
- how to use transformers with `Codable`.

To read it, open the package in Xcode and choose Product › Build Documentation.

## Contributing

Run the tests with:

```sh
swift test
```

The examples in the documentation are checked by `DocumentationExamplesTests.swift`, so update
both when behaviour changes.
