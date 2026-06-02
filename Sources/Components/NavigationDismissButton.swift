//
//  NavigationDismissButton.swift
//  PharosNav
//
//  Created by Theo Sementa on 25/06/2025.
//

import SwiftUI

/// Controls how `NavigationDismissButton` resolves the correct dismissal action.
public enum DismissBehavior {
    /// Auto-detect: pop if the view was pushed onto a stack, dismiss the presentation otherwise.
    /// This is the default behavior.
    case auto
    /// Always pop the last destination from the navigation stack (no-op if the stack is empty).
    case pop
    /// Always dismiss the current presentation (sheet or fullScreenCover).
    case dismiss
    /// Pop to the root of the current navigation stack.
    case popToRoot
}

/// A generic SwiftUI button that dismisses or pops the current view when tapped.
///
/// By default (`behavior: .auto`) the button adapts to its context:
/// - If the view was **pushed** onto a navigation stack, it calls `router.pop()`.
/// - If the view is at the root of a sheet or fullScreenCover, it falls back to
///   SwiftUI's `@Environment(\.dismiss)`.
///
/// Supply a `dismissAction` closure to override all automatic behavior.
///
/// - Parameter Label: The view used as the button's content.
public struct NavigationDismissButton<Label: View>: View {

    private let behavior: DismissBehavior
    private let dismissAction: (() -> Void)?
    private let label: () -> Label

    @Environment(\.dismiss) private var dismiss
    @Environment(\.dismissibleRouter) private var dismissibleRouter

    /// Creates a new dismiss button with a custom label.
    ///
    /// - Parameters:
    ///   - behavior: Determines how the button resolves the correct dismissal action. Defaults to `.auto`.
    ///   - dismissAction: When provided, this closure is called instead of any automatic behavior.
    ///   - label: A view builder that provides the button label.
    public init(
        behavior: DismissBehavior = .auto,
        dismissAction: (() -> Void)? = nil,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.behavior = behavior
        self.dismissAction = dismissAction
        self.label = label
    }

    public var body: some View {
        Button(
            action: { handleTap() },
            label: label
        )
    }
}

// MARK: - Private methods

private extension NavigationDismissButton {
    func handleTap() {
        if let dismissAction {
            dismissAction()
            return
        }

        switch behavior {
        case .auto:
            if let router = dismissibleRouter, router.navigationPathCount > 0 {
                router.pop()
            } else {
                dismiss()
            }
        case .pop:
            dismissibleRouter?.pop()
        case .dismiss:
            dismiss()
        case .popToRoot:
            dismissibleRouter?.popToRoot()
        }
    }
}
