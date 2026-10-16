# ``StringTransformations/StringTransformer``

## Overview

A string transformer converts a string into another representation, such as another case. Each
case has a transformer, and `StringTransformer` has a static accessor for each one, so you can pass
a case to ``Swift/String/transformed(using:)`` with a leading period:

```swift
"myURL".transformed(using: .snakeCase)                            // "my_url"
"user_id".transformed(using: .camelCase(knownWords: ["ID"]))      // "userID"
```

Transformers are `Codable` and `Hashable`, so you can store and compare them. To add your own
transformations, see <doc:CreatingCustomTransformers>.

## Topics

### Transforming Strings

- ``transform(_:)``

### Case Transformers

- ``camelCase``
- ``camelCase(wordSplittingStrategy:knownWords:)``
- ``pascalCase``
- ``pascalCase(wordSplittingStrategy:knownWords:)``
- ``snakeCase``
- ``snakeCase(wordSplittingStrategy:knownWords:)``
- ``constantCase``
- ``constantCase(wordSplittingStrategy:knownWords:)``
- ``kebabCase``
- ``kebabCase(wordSplittingStrategy:knownWords:)``
- ``trainCase``
- ``trainCase(wordSplittingStrategy:knownWords:)``
- ``dotCase``
- ``dotCase(wordSplittingStrategy:knownWords:)``
