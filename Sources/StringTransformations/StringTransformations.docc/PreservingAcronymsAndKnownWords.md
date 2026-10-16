# Preserving Acronyms and Known Words

Keep acronyms, their plurals and other words with a fixed spelling together, and spelled the way
you want.

## Overview

A string's case alone isn't always enough to find its words. Acronyms can run together, plural
acronyms end in a lowercase letter, and words like "iOS" mix cases. When the words are converted,
acronyms lose their capitals:

```swift
"HTTPURLResponse".snakeCased()      // "httpurl_response"
"myURLs".snakeCased()               // "my_ur_ls"
"user_id".camelCased()              // "userId"
```

Give a transformer the words it should recognize in its `knownWords` property, and it keeps them
together and spells them the way you wrote them:

```swift
"HTTPURLResponse".transformed(using: .snakeCase(knownWords: ["HTTP", "URL"]))  // "http_url_response"
"myURLs".transformed(using: .snakeCase(knownWords: ["URLs"]))                 // "my_urls"
"user_id".transformed(using: .camelCase(knownWords: ["ID"]))                  // "userID"
```

Known words aren't limited to acronyms. Any word with a fixed spelling works, including plurals
and brand names:

```swift
"OAuthToken".snakeCased()                                               // "o_auth_token"
"OAuthToken".transformed(using: .snakeCase(knownWords: ["OAuth"]))      // "oauth_token"
"ios_version".transformed(using: .pascalCase(knownWords: ["iOS"]))      // "iOSVersion"
```

### Known words when splitting

Where a known word appears in a string with exactly its spelling, it's kept as one word instead of
being split at changes of case. Matching is case-sensitive, so `"ID"` doesn't match the `id` in
`valid`. List each spelling you expect to find, including plurals:

```swift
let transformer = SnakeCaseTransformer(knownWords: ["ID", "IDs", "URL", "URLs"])
```

To avoid finding a known word inside another word, a match is rejected when:

- A lowercase letter follows it, because the letter continues the word. For example, `"ID"` isn't
  found in `IDentity`.
- It continues a run of letters with the same case as its own first letter, unless it's at the
  start of a word. For example, `"URL"` isn't found in `myCURLRequest`:

```swift
"myCURLRequest".transformed(using: .snakeCase(knownWords: ["URL"]))     // "my_curl_request"
```

This means adjacent acronyms are found only when the first one is also a known word, as with
`"HTTP"` and `"URL"` above. Similarly, a known word that starts with a lowercase letter, such as
`"iOS"`, isn't found directly after another lowercase letter.

Splitting at separators isn't affected by known words, so a known word that contains a
separator isn't kept together.

### Known words in the output

Transformers that capitalize words, ``CamelCaseTransformer``, ``PascalCaseTransformer`` and
``TrainCaseTransformer``, write any word that matches a known word with the known word's
spelling. These matches ignore case, so they also apply to words that came from lowercase or
uppercase input:

```swift
"url_session".transformed(using: .pascalCase(knownWords: ["URL"]))      // "URLSession"
"x-request-id".transformed(using: .trainCase(knownWords: ["ID"]))       // "X-Request-ID"
"MY_URL".transformed(using: .camelCase(knownWords: ["URL"]))            // "myURL"
```

The first word of a camel-case string is always lowercase, even when it's a known word:

```swift
"url_session".transformed(using: .camelCase(knownWords: ["URL"]))       // "urlSession"
```

Transformers that make every word lowercase or uppercase, such as ``SnakeCaseTransformer`` and
``ConstantCaseTransformer``, use known words only for splitting:

```swift
"iOSVersion".transformed(using: .constantCase(knownWords: ["iOS"]))     // "IOS_VERSION"
```

Avoid known words that differ only by case, such as `"IDs"` and `"IDS"`. When a word matches more
than one, the spelling that comes first in sorted order is used.

## See Also

- <doc:HowStringsAreSplitIntoWords>
- <doc:AssumingASourceCase>
