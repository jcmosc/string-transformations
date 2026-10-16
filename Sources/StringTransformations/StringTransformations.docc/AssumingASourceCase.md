# Assuming a Source Case

Split strings only at the boundaries of the case they're known to be in.

## Overview

By default, transformers make no assumption about the case of their input, and split strings at
every separator and change of case. That's the right choice when input can be in any case, but
when you know the case of your input, the default can split words that should stay whole.

For example, a name can contain capitals that aren't word boundaries:

```swift
"John-McCarthy".snakeCased()        // "john_mc_carthy"
"John McCarthy".snakeCased()        // "john_mc_carthy"
```

Set a transformer's `wordSplittingStrategy` to the case of your input, and it splits only where
that case separates words:

```swift
let transformer = SnakeCaseTransformer(wordSplittingStrategy: .convertFromKebabCase)
transformer.transform("John-McCarthy")      // "john_mccarthy"

"John McCarthy".transformed(
    using: .snakeCase(wordSplittingStrategy: .convertFromTitleCase)
)                                           // "john_mccarthy"
```

You can also pass a strategy to a static accessor:

```swift
"this_aNd_that".camelCased()                // "thisANdThat"
"this_aNd_that".transformed(
    using: .camelCase(wordSplittingStrategy: .convertFromSnakeCase)
)                                           // "thisAndThat"
```

### Choose a strategy

| Strategy | Splits strings at |
|---|---|
| ``WordSplittingStrategy/useDefaultBoundaries`` | Underscores, hyphens, periods, whitespace and changes of case |
| ``WordSplittingStrategy/convertFromSnakeCase``, ``WordSplittingStrategy/convertFromConstantCase`` | Underscores |
| ``WordSplittingStrategy/convertFromKebabCase``, ``WordSplittingStrategy/convertFromTrainCase`` | Hyphens |
| ``WordSplittingStrategy/convertFromDotCase`` | Periods |
| ``WordSplittingStrategy/convertFromTitleCase``, ``WordSplittingStrategy/convertFromSentenceCase`` | Whitespace |
| ``WordSplittingStrategy/convertFromCamelCase``, ``WordSplittingStrategy/convertFromPascalCase`` | Changes of case |

Strategies that split at separators don't split at changes of case. The strategies for camel case
and Pascal case split at changes of case only, using the rules described in
<doc:HowStringsAreSplitIntoWords>.

### Other cases' separators

When you assume a source case, separators that belong to other cases are part of the words that
contain them:

```swift
"my_varName".kebabCased()                   // "my-var-name"
"my_varName".transformed(
    using: .kebabCase(wordSplittingStrategy: .convertFromCamelCase)
)                                           // "my_var-name"
```

The separators kept at the start and end of a string are only the source case's separators.

### Words keep their letters, not their case

Assuming a source case changes where a string is split, not how each word is cased. Each word
still takes the case of the transformer, so a word that's split less often changes case as a
whole:

```swift
"server.portNumber".transformed(
    using: .snakeCase(wordSplittingStrategy: .convertFromDotCase)
)                                           // "server_portnumber"
```

To keep the spelling of particular words, such as acronyms, use known words instead. See
<doc:PreservingAcronymsAndKnownWords>.

## See Also

- ``WordSplittingStrategy``
- <doc:HowStringsAreSplitIntoWords>
