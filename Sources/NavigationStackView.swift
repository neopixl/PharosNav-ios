//
//  NavigationStackView.swift
//  PharosNav
//
//  Created by Theo Sementa on 25/06/2025.
//

import SwiftUI

/// A generic SwiftUI view that manages navigation and modal presentation using a `Router`.
///
/// `NavigationStackView` acts as the root of a navigation flow. It wraps a standard SwiftUI `NavigationStack`
/// and connects it to the provided `Router` and `RouterManager`.
///
/// It handles:
/// - Pushing destinations via `navigationDestination`.
/// - Presenting sheets and full-screen covers based on the `Router` state.
/// - Registering and unregistering the flow with the `RouterManager`.
///
/// - Important: Managing the **`isTabPage`** parameter is critical for flow lifecycle.
///   If you are presenting a new isolated flow (e.g., a FullScreenCover for Onboarding), you **must** set `isTabPage` to `false`.
///   This ensures that `onDisappear` correctly reverts the `currentFlow` in the manager and unregisters the temporary router.
///
/// - Parameters:
///   - InitialContent: The root view displayed at the base of the navigation stack.
///   - Flow: The enum or type conforming to `AppFlowProtocol` that identifies the context (e.g., .home, .login).
///   - Destination: The enum or type conforming to `AppDestinationProtocol`.
public struct NavigationStackView<
    InitialContent: View,
    Flow: AppFlowProtocol,
    Destination: AppDestinationProtocol
>: View {

    /// The router managing the navigation path and presentation state.
    @Bindable private var router: Router<Destination>

    /// The central manager responsible for coordinating flows and registering routers.
    @Bindable private var routerManager: RouterManager<Flow, Destination>

    /// The unique identifier for the application flow represented by this stack.
    private let flow: Flow

    /// A Boolean value indicating whether this stack represents a persistent tab page.
    ///
    /// - `true` (Default): Use this for main tab views. The router remains registered even when the view disappears (e.g., switching tabs).
    /// - `false`: Use this for temporary flows (Modals, Onboarding, Login). When the view disappears, the router is unregistered and the flow context is reverted.
    private let isTabPage: Bool

    /// The initial content view displayed at the root of the stack.
    private let initialContent: () -> InitialContent

    /// Resolve view for a given destination.
    private let registry: NavigationRegistry = .shared

    /// Creates a `NavigationStackView` with an explicitly provided `Router`.
    ///
    /// Most code should **prefer** the convenience init
    /// ``init(routerManager:flow:isTabPage:initialContent:)`` which delegates to
    /// `routerManager.getRouter(for:)`. The convenience init guarantees that a single
    /// `Router` instance is reused across all `View` rebuilds for the same flow.
    ///
    /// Reach for this explicit init only when you genuinely need to build the router
    /// outside the manager (e.g., unit tests, custom container hierarchy).
    ///
    /// > Pitfall: declaring `private let router: Router<…> = .init()` at struct scope
    /// > and passing it here recreates the router on every SwiftUI rebuild — and only
    /// > the first one is stored in the manager. `currentRouter` and the
    /// > `NavigationStackView` bindings then point to **different** instances, breaking
    /// > ViewModel-driven navigation. In `DEBUG` an `assertionFailure` is raised when
    /// > this pattern is detected.
    ///
    /// - Parameters:
    ///   - router: A `Router` instance that manages the navigation stack and presentation state.
    ///   - routerManager: The manager that coordinates active flows.
    ///   - flow: The specific flow identifier for this stack.
    ///   - isTabPage: Indicates if this stack is part of the main tab bar.
    ///     **Set to `false` if creating a new flow** (like a modal sheet) to enable automatic cleanup in `onDisappear`. Defaults to `true`.
    ///   - initialContent: A closure that returns the initial root view of the navigation stack.
    public init(
        router: Router<Destination>,
        routerManager: RouterManager<Flow, Destination>,
        flow: Flow,
        isTabPage: Bool = true,
        initialContent: @escaping () -> InitialContent
    ) {
        self.router = router
        self.routerManager = routerManager
        self.flow = flow
        self.isTabPage = isTabPage
        self.initialContent = initialContent
    }

    /// Convenience init that auto-resolves (or lazily creates) the router from the manager.
    ///
    /// Use this when you don't need to hold a reference to the router yourself.
    /// The router is resolved via `routerManager.getRouter(for: flow)`, which creates
    /// one on first access if none exists yet.
    ///
    /// - Parameters:
    ///   - routerManager: The manager that coordinates active flows.
    ///   - flow: The specific flow identifier for this stack.
    ///   - isTabPage: Indicates if this stack is part of the main tab bar. Defaults to `true`.
    ///   - initialContent: A closure that returns the initial root view of the navigation stack.
    public init(
        routerManager: RouterManager<Flow, Destination>,
        flow: Flow,
        isTabPage: Bool = true,
        initialContent: @escaping () -> InitialContent
    ) {
        self.router = routerManager.getRouter(for: flow)
        self.routerManager = routerManager
        self.flow = flow
        self.isTabPage = isTabPage
        self.initialContent = initialContent
    }

    public var body: some View {
        NavigationStack(path: $router.navigationPath) {
            initialContent()
                .navigationDestination(for: Destination.self) { destination in
                    registry.resolve(destination)
                }
                .sheet(
                    item: Binding(
                        get: { router.sheetDestination },
                        set: { if $0 == nil { router.presentation = nil } }
                    ),
                    onDismiss: router.presentationDismissAction
                ) { destination in
                    sheetContent(for: destination)
                }
                .fullScreenCover(
                    item: Binding(
                        get: { router.fullScreenDestination },
                        set: { if $0 == nil { router.presentation = nil } }
                    ),
                    onDismiss: router.presentationDismissAction
                ) { destination in
                    registry.resolve(destination)
                }
        }
        .tag(flow)
        .environment(router)
        .environment(\.dismissibleRouter, router)
        .onAppear {
            routerManager.register(router: router, for: flow)
            if isTabPage {
                // Tab flows update `selectedFlow` so the TabView stays in sync.
                routerManager.setCurrentFlow(flow)
            } else {
                // Non-tab (modal) flows only update `activeFlow` so the TabView
                // binding is not disturbed, preventing the host sheet from being dismissed.
                routerManager.setActiveFlow(flow)
            }
        }
        .onDisappear {
            if isTabPage == false {
                // Restore `activeFlow` (not `selectedFlow`, which never changed) and
                // unregister the temporary router to avoid memory leaks or state conflicts.
                routerManager.restoreActiveFlow()
                routerManager.unregister(for: flow)
            }
        }
    }
}

// MARK: - Private helpers

private extension NavigationStackView {

    @ViewBuilder
    func sheetContent(for destination: Destination) -> some View {
        switch router.activeSheetStyle {
        case .medium:
            registry.resolve(destination)
                .presentationDetents([.medium])
        case .canFullScreen:
            registry.resolve(destination)
                .presentationDetents([.medium, .large])
        case .fitContent(let bgColor):
            registry.resolve(destination)
                .fittedPresentationDetent()
                .presentationBackground(bgColor ?? .clear)
        case .large, nil:
            registry.resolve(destination)
        }
    }

}
