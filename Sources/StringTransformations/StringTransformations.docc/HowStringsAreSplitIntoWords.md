# How Strings Are Split into Words

Learn the rules transformers use to find the words in a string.

## Overview

Every transformer converts a string in the same steps:

1. Set aside any separators at the start and end of the string.
2. Split the rest of the string into words at separators.
3. Split each word again at changes of case.
4. Change the case of each word, and join the words with the new case's separator.
5. Put back the separators from the start and end.

This article describes the default rules, which make no assumption about the case of the input.
To limit splitting to the boundaries of a particular case, see <doc:AssumingASourceCase>.

### Separators

Underscores (`_`), hyphens (`-`), periods (`.`) and whitespace separate words. They're removed
when a string is split, and the new case's separator takes their place:

```swift
"my-url".snakeCased()               // "my_url"
"my url".snakeCased()               // "my_url"
"my.url".snakeCased()               // "my_url"
```

A run of separators counts as one, even when it mixes different separators:

```swift
"first  name".snakeCased()          // "first_name"
"first-_name".snakeCased()          // "first_name"
```

Periods split file extensions too. If you want to keep an extension, remove it before converting
the string and add it back afterwards:

```swift
"familyPhoto.png".snakeCased()      // "family_photo_png"
```

### Changes of case

Within the text between separators, a new word starts at an uppercase letter that follows a
lowercase letter:

```swift
"myURL".snakeCased()                // "my_url"
"LeadingCaps".snakeCased()          // "leading_caps"
```

A run of uppercase letters is a word of its own, such as an acronym. When a lowercase letter
follows the run, the run's last letter starts the next word:

```swift
"XMLProperty".snakeCased()              // "xml_property"
"thisIsAnXMLProperty".snakeCased()      // "this_is_an_xml_property"
```

Changes of case are found the same way as Foundation's
`JSONEncoder.KeyEncodingStrategy.convertToSnakeCase`, with one difference: Foundation assumes
that a key starts with a lowercase letter, and transformers don't. This means input in
CONSTANT_CASE or PascalCase splits the same way as input in camelCase:

```swift
"MY_URL".camelCased()               // "myUrl"
```

### Digits and other characters without case

Only letters have case. Digits, symbols, emoji and other characters without case stay with the
word before them, and an uppercase letter after one of them starts a new word:

```swift
"version4Thing".snakeCased()        // "version4_thing"
"utf8String".snakeCased()           // "utf8_string"
"vector3D".snakeCased()             // "vector3_d"
"word2vec".snakeCased()             // "word2vec"
"🐧Fish".snakeCased()               // "🐧_fish"
```

### Leading and trailing separators

Separators at the start and end of a string often carry meaning, such as marking a name as
private. Transformers keep them exactly as they are:

```swift
"_privateName".snakeCased()         // "_private_name"
"__dunder__".kebabCased()           // "__dunder__"
"_one_two_".camelCased()            // "_oneTwo_"
```

A string that contains only separators, or nothing at all, is returned unchanged:

```swift
"___".camelCased()                  // "___"
"".camelCased()                     // ""
```

### Unicode

Transformers classify each character by the Unicode general category of its first scalar:
uppercase and titlecase letters are uppercase, lowercase letters are lowercase, and everything
else has no case. This works for any script, and combining marks stay with the letter they
modify:

```swift
"größe_änderung".camelCased()       // "größeÄnderung"
"ΜΕΓΑΛΟ_ΟΝΟΜΑ".camelCased()         // "μεγαλοΟνομα"
```

When a transformer capitalizes a word, the first character uses its Unicode titlecase mapping and
the rest are lowercased. For most letters, titlecase is the same as uppercase, but some characters
have a distinct titlecase form:

```swift
"ǆemal_x".pascalCased()             // "ǅemalX", not "ǄemalX"
```

### When the rules aren't enough

Some strings can't be split correctly from their case alone:

- **Acronyms written next to each other** run together, because nothing marks where one ends:
  `"HTTPURLResponse".snakeCased()` returns `"httpurl_response"`.
- **Plural acronyms** split before their last capital, because a lowercase letter follows it:
  `"myURLs".snakeCased()` returns `"my_ur_ls"`.
- **Acronyms lose their spelling** in cases that capitalize words: `"user_id".camelCased()`
  returns `"userId"`.

Known words solve each of these. See <doc:PreservingAcronymsAndKnownWords>.

## See Also

- <doc:AssumingASourceCase>
- <doc:PreservingAcronymsAndKnownWords>
