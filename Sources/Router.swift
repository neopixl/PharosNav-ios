//
//  Router.swift
//  PharosNav
//
//  Created by Theo Sementa on 24/06/2025.
//

import Foundation
import SwiftUI

// MARK: - RouterPresentation

/// Encapsulates the active modal presentation state of a `Router` as a single source of truth.
///
/// Using a single `presentation` property instead of separate `presentedSheet` /
/// `presentedFullScreen` / `selectedRoute` properties prevents the three values from
/// diverging and makes it impossible to express inconsistent states (e.g., a sheet
/// destination set while `selectedRoute` is `.fullScreenCover`).
///
/// ### Equatable note
/// The `onDismiss` closure is intentionally excluded from the `==` comparison because
/// closures are not `Equatable`. Two presentations are considered equal when their
/// *structural* content (style + destination) is equal, regardless of the closure.
public enum RouterPresentation<Destination: Equatable> {
    case sheet(style: SheetStyle, destination: Destination, onDismiss: (() -> Void)? = nil)
    case fullScreenCover(destination: Destination, onDismiss: (() -> Void)? = nil)
}

extension RouterPresentation: Equatable {
    public static func == (lhs: RouterPresentation, rhs: RouterPresentation) -> Bool {
        switch (lhs, rhs) {
        case (.sheet(let ls, let ld, _), .sheet(let rs, let rd, _)):
            return ls == rs && ld == rd
        case (.fullScreenCover(let ld, _), .fullScreenCover(let rd, _)):
            return ld == rd
        default:
            return false
        }
    }
}

// MARK: - Router

/// A generic router for managing navigation and presentation within a SwiftUI app.
///
/// `Router` tracks the navigation path and the active modal presentation via the
/// unified `presentation` property. Legacy computed properties (`presentedSheet`,
/// `presentedFullScreen`, `selectedRoute`) are still available for backward compatibility
/// but are deprecated — prefer `presentation` for new code.
///
/// - Note: `AppDestination` must conform to `AppDestinationProtocol`.
@Observable
public class Router<AppDestination: AppDestinationProtocol> {

    /// The current stack of destinations in the navigation path.
    public var navigationPath: [AppDestination] = []

    /// The active modal presentation (sheet or fullScreenCover), or `nil` when none is shown.
    public internal(set) var presentation: RouterPresentation<AppDestination>?

    /// Creates a new instance of `Router`.
    public init() {}

}

// MARK: - Deprecated computed properties (backward compatibility)

public extension Router {

    /// The currently presented sheet destination.
    ///
    /// - Important: Derived from `presentation`. Prefer using `presentation` directly.
    @available(*, deprecated, message: "Use `presentation` instead.")
    var presentedSheet: AppDestination? {
        get { sheetDestination }
        set {
            if let value = newValue {
                let style: SheetStyle
                if case .sheet(let s, _, _) = presentation { style = s } else { style = .large }
                let onDismiss: (() -> Void)?
                if case .sheet(_, _, let a) = presentation { onDismiss = a } else { onDismiss = nil }
                presentation = .sheet(style: style, destination: value, onDismiss: onDismiss)
            } else if case .sheet = presentation {
                presentation = nil
            }
        }
    }

    /// The currently presented full screen cover destination.
    ///
    /// - Important: Derived from `presentation`. Prefer using `presentation` directly.
    @available(*, deprecated, message: "Use `presentation` instead.")
    var presentedFullScreen: AppDestination? {
        get { fullScreenDestination }
        set {
            if let value = newValue {
                let onDismiss: (() -> Void)?
                if case .fullScreenCover(_, let a) = presentation { onDismiss = a } else { onDismiss = nil }
                presentation = .fullScreenCover(destination: value, onDismiss: onDismiss)
            } else if case .fullScreenCover = presentation {
                presentation = nil
            }
        }
    }

    /// The currently active route type.
    ///
    /// - Important: Derived from `presentation`. Prefer using `presentation` directly.
    @available(*, deprecated, message: "Use `presentation` instead.")
    var selectedRoute: Route? {
        get {
            switch presentation {
            case .sheet(let style, _, _): return .sheet(style: style)
            case .fullScreenCover: return .fullScreenCover
            case nil: return nil
            }
        }
        set {
            switch newValue {
            case .sheet(let style):
                switch presentation {
                case .sheet(_, let dest, let action):
                    presentation = .sheet(style: style, destination: dest, onDismiss: action)
                default:
                    break
                }
            default:
                break
            }
        }
    }

    /// The dismiss action stored in the active presentation.
    @available(*, deprecated, message: "Pass the dismiss action directly to present(route:_:dismissAction:). The closure is now stored inside `presentation`.")
    var dismissAction: (() -> Void)? {
        get { presentationDismissAction }
        set {
            switch presentation {
            case .sheet(let style, let destination, _):
                presentation = .sheet(style: style, destination: destination, onDismiss: newValue)
            case .fullScreenCover(let destination, _):
                presentation = .fullScreenCover(destination: destination, onDismiss: newValue)
            case nil:
                break
            }
        }
    }

}

// MARK: - Computed helpers

extension Router {

    /// The typed sheet destination extracted from `presentation`.
    var sheetDestination: AppDestination? {
        guard case .sheet(_, let dest, _) = presentation else { return nil }
        return dest
    }

    /// The typed full-screen-cover destination extracted from `presentation`.
    var fullScreenDestination: AppDestination? {
        guard case .fullScreenCover(let dest, _) = presentation else { return nil }
        return dest
    }

    /// The dismiss closure stored in the active presentation.
    var presentationDismissAction: (() -> Void)? {
        switch presentation {
        case .sheet(_, _, let action): return action
        case .fullScreenCover(_, let action): return action
        case nil: return nil
        }
    }

    /// The `SheetStyle` when the active presentation is a sheet.
    var activeSheetStyle: SheetStyle? {
        guard case .sheet(let style, _, _) = presentation else { return nil }
        return style
    }

}

// MARK: - Navigation actions

public extension Router {

    /// Removes all destinations and pops to the root of the navigation stack.
    func popToRoot() {
        navigationPath.removeAll()
        presentation = nil
    }

    /// Removes the last destination from the navigation stack.
    func pop() {
        guard navigationPath.isEmpty == false else { return }
        navigationPath.removeLast()
    }

    /// Pushes a single destination onto the navigation stack.
    func push(_ destination: AppDestination) {
        navigationPath.append(destination)
    }

    /// Pushes multiple destinations onto the navigation stack.
    func push(_ destinations: [AppDestination]) {
        navigationPath.append(contentsOf: destinations)
    }

}

// MARK: - Presentation actions

public extension Router {

    /// Presents a destination using the specified route type.
    ///
    /// - Parameters:
    ///   - route: The presentation route type (e.g., sheet, fullScreenCover).
    ///   - destination: The destination to present.
    ///   - dismissAction: An optional action to perform when the presentation is dismissed.
    func present(route: Route, _ destination: AppDestination, _ dismissAction: (() -> Void)? = nil) {
        precondition(route != .push, "Push route is not supported in this presentation method")
        guard route.isPresentable else { return }

        switch route {
        case .push:
            break
        case .sheet(let style):
            presentation = .sheet(style: style, destination: destination, onDismiss: dismissAction)
        case .fullScreenCover:
            presentation = .fullScreenCover(destination: destination, onDismiss: dismissAction)
        }
    }

    /// Dismisses any currently presented destination.
    func dismiss() {
        if isPagePresented { pop() }
        if isSheetPresented { presentation = nil }
        if isFullScreenPresented { presentation = nil }
    }

}

// MARK: - DismissibleRouter conformance

extension Router: DismissibleRouter {
    public var navigationPathCount: Int { navigationPath.count }
}

// MARK: - State predicates

public extension Router {

    /// Returns `true` when only the navigation stack is active (no modal or sheet presented).
    var isPagePresented: Bool {
        return !isSheetPresented && !isFullScreenPresented
    }

    /// Returns `true` if a sheet is currently presented.
    var isSheetPresented: Bool {
        if case .sheet = presentation { return true }
        return false
    }

    /// Returns `true` if a full screen cover is currently presented.
    var isFullScreenPresented: Bool {
        if case .fullScreenCover = presentation { return true }
        return false
    }

}
