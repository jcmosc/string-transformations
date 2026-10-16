# Creating Custom Transformers

Add your own cases and string transformations by conforming to the transformer protocol.

## Overview

Any type that conforms to ``StringTransformer`` works everywhere the built-in transformers do,
including with ``Swift/String/transformed(using:)`` and ``Swift/String/transform(using:)``.

### Conform to the protocol

``StringTransformer`` has one requirement, ``StringTransformer/transform(_:)``, which returns the
transformed string. The protocol also requires `Codable` and `Hashable`, which Swift synthesizes
for structures whose properties conform to them, including the built-in transformers.

A good way to create a new case is to build it from an existing transformer. For example, a
transformer for COBOL-CASE, which is kebab case in uppercase, can store a
``KebabCaseTransformer`` and uppercase its result:

```swift
struct COBOLCaseTransformer: StringTransformer {
    var kebabCase = KebabCaseTransformer()

    func transform(_ value: String) -> String {
        kebabCase.transform(value).uppercased()
    }
}
```

Storing the transformer, rather than creating one when it's needed, lets callers configure its
word splitting strategy and known words.

### Add a static accessor

To let callers write your transformer with a leading period, like the built-in cases, add a static
property in an extension of ``StringTransformer`` that's constrained to your type:

```swift
extension StringTransformer where Self == COBOLCaseTransformer {
    static var cobolCase: COBOLCaseTransformer { .init() }
}

"myAPIKey".transformed(using: .cobolCase)   // "MY-API-KEY"
```

You can add a static method in the same extension to accept configuration, and a method on
`String`, such as `cobolCased()`, for the common case.

## See Also

- ``StringTransformer``
- <doc:UsingTransformersWithCodable>
