//
//  NavigationRegistry.swift
//  PharosNav
//
//  Created by Theo Sementa on 09/02/2026.
//

import SwiftUI
import OSLog

/// A singleton that maps destination types to their SwiftUI views at runtime.
///
/// ## Why `AnyView` is used internally
/// `NavigationRegistry` is a heterogeneous registry: it stores resolvers for many
/// unrelated destination types under a single dictionary. Swift's type system cannot
/// express a statically-typed heterogeneous collection, so type erasure via `AnyView`
/// is the only viable approach at this layer.
///
/// The SDK encapsulates this cost so that call-sites never have to write `AnyView(...)`.
/// The `register(_:resolver:)` method accepts a `@ViewBuilder` returning `some View`,
/// and wraps it in `AnyView` once — internally — before storing it.
public class NavigationRegistry {
    @MainActor public static let shared = NavigationRegistry()

    // `ObjectIdentifier` is stable within a process lifetime and immune to
    // module-path or type-name changes that would silently break `String(reflecting:)` keys.
    private var resolvers: [ObjectIdentifier: (Any) -> AnyView] = [:]

    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "PharosNav",
        category: "PharosNav"
    )

    private init() {}

    /// Registers a view resolver for a destination type.
    ///
    /// Use a `@ViewBuilder` closure — no `AnyView` wrapping required at the call-site:
    /// ```swift
    /// NavigationRegistry.shared.register(PersonDestination.self) { destination in
    ///     switch destination {
    ///     case .list:           PersonListScreen()
    ///     case .add(let name):  AddPersonScreen(name: name)
    ///     }
    /// }
    /// ```
    public func register<D: Hashable, V: View>(
        _ type: D.Type,
        @ViewBuilder resolver: @escaping (D) -> V
    ) {
        let key = ObjectIdentifier(type)
        // Wrap `AnyView` once here so call-sites stay clean.
        resolvers[key] = { destination in
            guard let typedDestination = destination as? D else {
                return AnyView(Text("Type error for \(String(describing: type))"))
            }
            return AnyView(resolver(typedDestination))
        }
    }

    public func resolve(_ destination: Any) -> AnyView {
        let base: Any = (destination as? AnyHashable)?.base ?? destination

        if let view = base as? AnyView { return view }

        let key = ObjectIdentifier(type(of: base))

        if let resolver = resolvers[key] {
            return resolver(base)
        }

        if let recursive = base as? RecursiveDestination {
            let unwrappedValue = recursive.unwrapped
            if ObjectIdentifier(type(of: unwrappedValue.base)) != key {
                return resolve(unwrappedValue)
            }
        }

        let typeName = String(describing: type(of: base))
        let message = "NavigationRegistry: no resolver registered for \(typeName). Did you forget to call NavigationRegistry.shared.register(...)?"

        #if DEBUG
        assertionFailure(message)
        #else
        logger.error("\(message)")
        #endif

        return AnyView(
            VStack {
                Text("Destination not found").bold()
                Text(typeName).font(.caption)
            }.foregroundStyle(.red)
        )
    }
}
