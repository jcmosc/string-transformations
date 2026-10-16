# ``StringTransformations``

Convert strings between camel case, snake case, kebab case and other naming conventions.

## Overview

StringTransformations converts identifiers, keys and other strings from one naming convention to
another. It splits a string into words, whatever case the string is in, and joins the words again
in the case you ask for:

```swift
import StringTransformations

"user_id".camelCased()              // "userId"
"XMLHttpRequest".snakeCased()       // "xml_http_request"
"content_type".trainCased()         // "Content-Type"
"maxRetryCount".constantCased()     // "MAX_RETRY_COUNT"
```

Each case is a transformer: a small value that conforms to ``StringTransformer``. Pass a
transformer to ``Swift/String/transformed(using:)`` to convert a string, or to
``Swift/String/transform(using:)`` to convert it in place:

```swift
var key = "myURL"
key.transform(using: .snakeCase)    // key == "my_url"
```

### Supported cases

| Case | Transformer | Example |
|---|---|---|
| camelCase | ``CamelCaseTransformer`` | `userId` |
| PascalCase | ``PascalCaseTransformer`` | `UserId` |
| snake_case | ``SnakeCaseTransformer`` | `user_id` |
| CONSTANT_CASE | ``ConstantCaseTransformer`` | `USER_ID` |
| kebab-case | ``KebabCaseTransformer`` | `user-id` |
| Train-Case | ``TrainCaseTransformer`` | `User-Id` |
| dot.case | ``DotCaseTransformer`` | `user.id` |

### Any input, no guessing

You don't need to say what case a string is in. Transformers split strings at underscores,
hyphens, periods and whitespace, and at changes of case, so input in any of the cases above, or
in a mix of them, converts correctly. Acronyms are recognized as words of their own, and digits
stay with the word before them:

```swift
"thisIsAnXMLProperty".kebabCased()  // "this-is-an-xml-property"
"version4Thing".snakeCased()        // "version4_thing"
"Title Case Input".camelCased()     // "titleCaseInput"
```

Case changes are found the same way as Foundation's
`JSONEncoder.KeyEncodingStrategy.convertToSnakeCase`, so results agree with the keys Foundation
produces. For the complete rules, see <doc:HowStringsAreSplitIntoWords>.

### Leading and trailing separators are kept

Separators at the start and end of a string are part of a name's meaning, so they're kept as they
are, in every case:

```swift
"_privateName".snakeCased()         // "_private_name"
"__init__".camelCased()             // "__init__"
```

### Acronyms, plurals and brand names

Tell a transformer about words with a fixed spelling, and it keeps them together and spells them
the way you wrote them. This covers acronyms, their plurals and mixed-case names:

```swift
"user_ids".transformed(using: .camelCase(knownWords: ["IDs"]))       // "userIDs"
"myURLs".transformed(using: .snakeCase(knownWords: ["URLs"]))        // "my_urls"
"ios_version".transformed(using: .pascalCase(knownWords: ["iOS"]))   // "iOSVersion"
```

For more information, see <doc:PreservingAcronymsAndKnownWords>.

### Assume a source case when you know it

When you know what case your input is in, a ``WordSplittingStrategy`` limits splitting to that
case's separators, so capitals inside words are left alone:

```swift
"John-McCarthy".snakeCased()                        // "john_mc_carthy"
"John-McCarthy".transformed(
    using: .snakeCase(wordSplittingStrategy: .convertFromKebabCase)
)                                                   // "john_mccarthy"
```

For more information, see <doc:AssumingASourceCase>.

### Unicode throughout

Transformers work with any script, and use Unicode's definitions throughout:

- Letters are classified by their Unicode general category, so digits, symbols and emoji have no
  case.
- Combining marks stay with the letters they modify.
- Capitalized words start with a titlecase letter, which differs from uppercase for characters
  such as `ǅ`.

```swift
"größe_änderung".camelCased()       // "größeÄnderung"
"ΜΕΓΑΛΟ_ΟΝΟΜΑ".camelCased()         // "μεγαλοΟνομα"
"ǆemal_x".pascalCased()             // "ǅemalX"
```

### Values you can store and compare

Transformers are `Codable` and `Hashable`, so you can store them in configuration, send them
between processes, and compare them. They don't depend on Foundation, and you can add your own
cases by conforming to ``StringTransformer``. For more information, see
<doc:CreatingCustomTransformers> and <doc:UsingTransformersWithCodable>.

## Topics

### Essentials

- <doc:ConvertingBetweenCases>
- ``StringTransformer``

### Case Transformers

- ``CamelCaseTransformer``
- ``PascalCaseTransformer``
- ``SnakeCaseTransformer``
- ``ConstantCaseTransformer``
- ``KebabCaseTransformer``
- ``TrainCaseTransformer``
- ``DotCaseTransformer``

### Splitting Strings into Words

- <doc:HowStringsAreSplitIntoWords>
- <doc:AssumingASourceCase>
- <doc:PreservingAcronymsAndKnownWords>
- ``WordSplittingStrategy``

### Extending and Integrating

- <doc:CreatingCustomTransformers>
- <doc:UsingTransformersWithCodable>
