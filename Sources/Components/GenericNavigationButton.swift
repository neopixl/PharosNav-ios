//
//  GenericNavigationButton.swift
//  PharosNav
//
//  Created by Theo Sementa on 24/06/2025.
//

import SwiftUI

/// A configurable navigation button that triggers navigation or presentation
/// based on a `NavigationTarget`, fully enforced at compile time.
///
/// - Parameters:
///   - Destination: The type representing navigation destinations. Must conform to `AppDestinationProtocol`.
///   - Label: A SwiftUI view used as the button's label.
public struct GenericNavigationButton<Destination: AppDestinationProtocol, Label: View>: View {

    private let target: NavigationTarget<Destination>
    private let onNavigate: (() -> Void)?
    private let label: () -> Label

    @Environment(Router<Destination>.self) private var router

    /// Creates a navigation button driven by a `NavigationTarget`.
    ///
    /// This is the preferred initializer. The valid navigation action is encoded
    /// structurally in the `target` value, making invalid combinations inexpressible.
    ///
    /// - Parameters:
    ///   - target: The navigation target describing what action to perform.
    ///   - onNavigate: An optional action called before navigation occurs.
    ///   - label: A view builder that returns the button label.
    public init(
        target: NavigationTarget<Destination>,
        onNavigate: (() -> Void)? = nil,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.target = target
        self.onNavigate = onNavigate
        self.label = label
    }

    public var body: some View {
        Button(action: {
            onNavigate?()

            switch target {
            case .push(let destination):
                router.push(destination)
            case .pushMany(let destinations):
                router.push(destinations)
            case .sheet(let style, let destination, let onDismiss):
                router.present(route: .sheet(style: style), destination, onDismiss)
            case .fullScreenCover(let destination, let onDismiss):
                router.present(route: .fullScreenCover, destination, onDismiss)
            }
        }, label: label)
    }
}

// MARK: - Deprecated inits (backward compatibility)

extension GenericNavigationButton {

    /// Creates a navigation button for a single destination and any route type.
    @available(*, deprecated, message: "Use init(target:onNavigate:label:) with NavigationTarget instead.")
    public init(
        route: Route,
        destination: Destination,
        onDismiss: (() -> Void)? = nil,
        onNavigate: (() -> Void)? = nil,
        @ViewBuilder label: @escaping () -> Label
    ) {
        switch route {
        case .push:
            self.target = .push(destination)
        case .sheet(let style):
            self.target = .sheet(style, destination, onDismiss: onDismiss)
        case .fullScreenCover:
            self.target = .fullScreenCover(destination, onDismiss: onDismiss)
        }
        self.onNavigate = onNavigate
        self.label = label
    }

    /// Creates a navigation button for pushing multiple destinations onto the navigation stack.
    ///
    /// - Important: This initializer must only be used with `.push` routes.
    @available(*, deprecated, message: "Use init(target: .pushMany(destinations)) instead.")
    public init(
        route: Route,
        destinations: [Destination],
        onDismiss: (() -> Void)? = nil,
        onNavigate: (() -> Void)? = nil,
        @ViewBuilder label: @escaping () -> Label
    ) {
        precondition(route == .push, "This init can only be used with route == .push")
        self.target = .pushMany(destinations)
        self.onNavigate = onNavigate
        self.label = label
    }
}
