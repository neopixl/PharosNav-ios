//
//  RecursiveDestinationMacro.swift
//  PharosNavMacros
//

/// Synthesises `RecursiveDestination` conformance for an enum.
///
/// Each case must carry exactly one associated value conforming to `Hashable`.
/// The macro generates a `var unwrapped: AnyHashable` computed property that
/// unwraps the inner destination so `NavigationRegistry` can resolve it.
///
/// Usage:
/// ```swift
/// @RecursiveDestination
/// enum AppDestination: AppDestinationProtocol {
///     case cat(CatDestination)
///     case fruit(FruitDestination)
///     case person(PersonDestination)
/// }
/// ```
@attached(extension, conformances: RecursiveDestination, names: named(unwrapped))
public macro RecursiveDestination() = #externalMacro(
    module: "PharosNavMacrosPlugin",
    type: "RecursiveDestinationMacro"
)
