//
//  RouterManager.swift
//  PharosNav
//
//  Created by Theo Sementa on 29/12/2025.
//

import Foundation

/// A central object responsible for managing the application's global navigation state and coordinating multiple routers.
///
/// `RouterManager` acts as the source of truth for the currently active `Flow` (e.g., a specific Tab or app section)
/// and maintains a registry of `Router` instances associated with each flow.
///
/// Usage implies injecting this object into the environment or passing it to the root view (like a `TabView`)
/// to control switching between major application sections.
@MainActor @Observable
open class RouterManager<Flow: AppFlowProtocol, Destination: AppDestinationProtocol> {

    /// The currently active application flow.
    public var selectedFlow: Flow

    /// The previously active flow, if any.
    public var previousFlow: Flow?

    /// The flow whose router should be treated as the active router.
    ///
    /// This is distinct from `selectedFlow` so that a modal (non-tab) flow can become
    /// the active router without touching the `TabView` binding. `currentRouter` reads
    /// from this property.
    public internal(set) var activeFlow: Flow

    /// A dictionary storing the active router instance for each registered flow.
    public var routers: [Flow: Router<Destination>] = [:]

    // MARK: Init
    public init(
        selectedFlow: Flow,
        previousFlow: Flow? = nil,
        routers: [Flow : Router<Destination>] = [:]
    ) {
        self.selectedFlow = selectedFlow
        self.activeFlow = selectedFlow
        self.previousFlow = previousFlow
        self.routers = routers
    }

}

// MARK: - Computed variables
extension RouterManager {

    /// The active router for the current flow.
    ///
    /// Returns the router for `activeFlow`, which may differ from `selectedFlow` when a
    /// modal (non-tab) flow is on screen. Returns `nil` if no router has been registered
    /// yet for the active flow.
    public var currentRouter: Router<Destination>? {
        return existingRouter(for: activeFlow)
    }

}

// MARK: - Public functions
extension RouterManager {

    /// Retrieves the registered router for a specific flow.
    /// If no router has been registered yet, one is lazily created and stored.
    /// Use this overload when you want auto-instantiation (e.g. convenience NavigationStackView init).
    @discardableResult
    public func getRouter(for flow: Flow) -> Router<Destination> {
        if let existing = routers[flow] { return existing }
        let router = Router<Destination>()
        routers[flow] = router
        return router
    }

    /// Retrieves the router for a specific flow only if one has already been registered.
    /// Returns `nil` when no router is associated with the given flow.
    public func existingRouter(for flow: Flow) -> Router<Destination>? {
        return routers[flow]
    }
    
    /// Navigate to a specific flow and execute an action
    @MainActor
    public func navigateToFlow(_ flow: Flow, then: @escaping () -> Void) {
        self.selectedFlow = flow
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            then()
        }
    }
    
}

// MARK: - Internal functions

internal extension RouterManager {

    /// Registers a router for a specific flow.
    ///
    /// Idempotent: a second call with the **same** router instance is a no-op.
    ///
    /// In `DEBUG` builds, a second call with a **different** router instance triggers an
    /// `assertionFailure`. This catches a common pitfall where a SwiftUI `View` declares
    /// `private let router: Router<…> = .init()` at struct scope, causing a fresh router
    /// to be created on every body rebuild. Only the first one is stored; subsequent
    /// instances are silently disconnected from the manager (their `currentRouter`
    /// resolves to the original, while their `NavigationStackView` binds to the fresh
    /// local). The assertion makes this split-brain visible early.
    ///
    /// In release builds the call is a no-op (existing router wins) — same behaviour as before.
    func register(router: Router<Destination>, for flow: Flow) {
        if let existing = routers[flow] {
            #if DEBUG
            if existing !== router {
                assertionFailure(
                    """
                    RouterManager: a different Router instance is being registered for flow \(flow).
                    This usually means a SwiftUI View declares `private let router: Router = .init()` \
                    at struct scope — SwiftUI may recreate the View struct on rebuild, producing a \
                    new Router each time, while the manager keeps only the first one. The result is \
                    a split-brain between `currentRouter` (returns the original) and the \
                    NavigationStackView (binds to the fresh local).
                    Fix: use `NavigationStackView(routerManager:flow:isTabPage:initialContent:)` \
                    (convenience init) which delegates to `routerManager.getRouter(for:)` and \
                    guarantees a single shared instance.
                    """
                )
            }
            #endif
            return
        }
        routers[flow] = router
    }

    /// Unregisters the router associated with a specific flow.
    func unregister(for flow: Flow) {
        return routers[flow] = nil
    }

    /// Updates `activeFlow` only, without touching `selectedFlow`.
    ///
    /// Use this for non-tab (modal) flows so the `TabView` binding is not disturbed.
    func setActiveFlow(_ flow: Flow) {
        previousFlow = activeFlow
        activeFlow = flow
    }

    /// Restores `activeFlow` to `previousFlow`.
    ///
    /// Mirror of `setPreviousFlow()` but only touches `activeFlow`, leaving `selectedFlow`
    /// (and therefore the `TabView`) unchanged.
    func restoreActiveFlow() {
        guard let previousFlow else { return }
        activeFlow = previousFlow
    }

}

// MARK: - Public flow management

public extension RouterManager {

    /// Updates `selectedFlow` (and therefore the `TabView`) to `flow` and archives the current
    /// value as `previousFlow`. Also synchronises `activeFlow`.
    ///
    /// The normal way to switch flows is to assign `selectedFlow` directly (which the
    /// `NavigationTabView` binding does automatically). Call `setCurrentFlow(_:)` when you
    /// need explicit control over `previousFlow` bookkeeping — for example, when programmatically
    /// pushing a temporary flow from a ViewModel without going through a tab transition.
    func setCurrentFlow(_ flow: Flow) {
        previousFlow = self.selectedFlow
        self.selectedFlow = flow
        self.activeFlow = flow
    }

    /// Reverts `selectedFlow` to `previousFlow`.
    ///
    /// Primarily useful for tearing down a temporary flow (modal onboarding, full-screen login)
    /// that sits above the main `TabView`. `NavigationStackView(isTabPage: false)` calls this
    /// automatically on disappear; call it manually only for advanced custom flow management.
    func setPreviousFlow() {
        guard let previousFlow else { return }
        self.selectedFlow = previousFlow
        self.activeFlow = previousFlow
    }

}
