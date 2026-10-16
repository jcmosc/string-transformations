/// The strategy a case transformer uses to split a string into words, based on the case the string
/// is assumed to be in.
///
/// By default, transformers make no assumption about the source case, and split strings at every
/// separator and case change. When the source case is known, assuming it splits only at that
/// case's boundaries, so words keep their original case and the separators of other cases are
/// left alone:
///
///     let transformer = SnakeCaseTransformer(strategy: .convertFromKebabCase)
///     print(transformer.transform("McDonald-my_var"))
///     // Prints "mcdonald_my_var"
public enum WordSplittingStrategy: Codable, Hashable, Sendable {
    /// Splits strings at separators (underscores, hyphens, periods and whitespace) and at case
    /// changes.
    case useDefaultBoundaries

    /// Assumes strings are in snake case, and splits them only at underscores.
    case convertFromSnakeCase

    /// Assumes strings are in constant case, and splits them only at underscores.
    case convertFromConstantCase

    /// Assumes strings are in kebab case, and splits them only at hyphens.
    case convertFromKebabCase

    /// Assumes strings are in Train case, and splits them only at hyphens.
    case convertFromTrainCase

    /// Assumes strings are in dot case, and splits them only at periods.
    case convertFromDotCase

    /// Assumes strings are in camel case, and splits them only at case changes.
    case convertFromCamelCase

    /// Assumes strings are in Pascal case, and splits them only at case changes.
    case convertFromPascalCase
}

extension WordSplittingStrategy {
    /// Returns whether a character is a separator under this strategy.
    func isSeparator(_ character: Character) -> Bool {
        switch self {
        case .useDefaultBoundaries:
            character == "_" || character == "-" || character == "." || character.isWhitespace
        case .convertFromSnakeCase, .convertFromConstantCase:
            character == "_"
        case .convertFromKebabCase, .convertFromTrainCase:
            character == "-"
        case .convertFromDotCase:
            character == "."
        case .convertFromCamelCase, .convertFromPascalCase:
            false
        }
    }

    /// Whether words are split at case changes under this strategy.
    var splitsAtCaseChanges: Bool {
        switch self {
        case .useDefaultBoundaries, .convertFromCamelCase, .convertFromPascalCase:
            true
        case .convertFromSnakeCase, .convertFromConstantCase, .convertFromKebabCase,
            .convertFromTrainCase, .convertFromDotCase:
            false
        }
    }
}
