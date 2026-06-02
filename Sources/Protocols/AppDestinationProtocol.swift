//
//  AppDestinationProtocol.swift
//  PharosNav
//
//  Created by Theo Sementa on 24/06/2025.
//

import Foundation

/// A protocol that represents a navigable destination in a SwiftUI application.
///
/// Conform types (typically enums) to `AppDestinationProtocol` to describe all possible navigation
/// targets in a modular and type-safe way. This is used by the `Router` and `NavigationStackView`
/// to handle navigation paths and modal presentations.
///
/// Conforming to `AppDestinationProtocol` requires `Identifiable` and `Hashable`,
/// allowing use with SwiftUI navigation APIs.
public protocol AppDestinationProtocol: Identifiable, Hashable { }

/// Default implementation of `Identifiable` for `AppDestinationProtocol` using the `hashValue` as `id`.
///
/// This allows enums or structs conforming to `AppDestinationProtocol` to automatically be used
/// in `ForEach`, `.sheet(item:)`, and other SwiftUI constructs that rely on identity.
///
/// ### Value-identity semantics
/// The default `id` is derived from `hashValue`, which means two enum cases with identical
/// associated values will produce the same `id`. This is intentional and works correctly
/// for navigation: SwiftUI's `.sheet(item:)` and `ForEach` treat them as the *same* destination.
///
/// ### When to override
/// Override `id` with a stable `UUID` when you need *instance* identity rather than
/// *value* identity — for example, if you want to present the same destination twice
/// simultaneously with different state, or if the destination must survive serialisation
/// across app launches:
/// ```swift
/// enum MyDestination: AppDestinationProtocol {
///     case detail(itemID: UUID)
///     // hashValue already differs per UUID, so the default is fine here.
///
///     // Override only if you need a stable identifier independent of associated values:
///     // public var id: UUID { UUID() }  // ← instance identity (rare)
/// }
/// ```
extension AppDestinationProtocol {
    /// A default `id` based on the `hashValue`.
    ///
    /// - Note: Override this if you need stable identifiers across sessions.
    public var id: Int { hashValue }
}
