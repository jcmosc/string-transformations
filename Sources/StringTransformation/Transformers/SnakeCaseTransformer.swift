import Foundation

/// A structure that transforms strings into their snake-case representations.
public struct SnakeCaseTransformer: StringTransformer {
    public func transform(_ value: String) -> String {
        guard !value.isEmpty else { return value }

        var words: [Range<String.Index>] = []
        var wordStart = value.startIndex
        var searchRange = value.startIndex..<value.endIndex

        // Find next uppercase character
        while let upperCaseRange = value[searchRange].rangeOfCharacter(from: .uppercaseLetters) {
            // If the first character is already uppercase the first "word" will be empty
            if wordStart != upperCaseRange.lowerBound {
                let untilUpperCase = wordStart..<upperCaseRange.lowerBound
                words.append(untilUpperCase)
            }

            // Find next lowercase character
            searchRange = upperCaseRange.lowerBound..<searchRange.upperBound
            guard let lowerCaseRange = value[searchRange].rangeOfCharacter(from: .lowercaseLetters)
            else {
                // There are no more lower case letters. Just end here.
                wordStart = searchRange.lowerBound
                break
            }

            // Is the next lowercase letter more than 1 after the uppercase? If so, we encountered a group of uppercase letters that we should treat as its own word
            let nextCharacterAfterCapital = value.index(after: upperCaseRange.lowerBound)
            if lowerCaseRange.lowerBound == nextCharacterAfterCapital {
                // The next character after capital is a lower case character and therefore not a word boundary.
                // Continue searching for the next upper case for the boundary.
                wordStart = upperCaseRange.lowerBound
            } else {
                // There was a range of >1 capital letters. Turn those into a word, stopping at the capital before the lower case character.
                let beforeLowerIndex = value.index(before: lowerCaseRange.lowerBound)
                words.append(upperCaseRange.lowerBound..<beforeLowerIndex)

                // Next word starts at the capital before the lowercase we just found
                wordStart = beforeLowerIndex
            }
            searchRange = lowerCaseRange.upperBound..<searchRange.upperBound
        }
        words.append(wordStart..<searchRange.upperBound)
        let result = words.map({ (range) in
            return value[range].lowercased()
        }).joined(separator: "_")
        return result
    }
}

extension StringTransformer where Self == SnakeCaseTransformer {
    /// A string transformer that converts strings to snake-case representations.
    public static var snakeCase: SnakeCaseTransformer { .init() }
}

extension String {
    /// Returns a version of the string converted to a snake-case representation.
    public func snakeCased() -> String {
        SnakeCaseTransformer().transform(self)
    }
}
