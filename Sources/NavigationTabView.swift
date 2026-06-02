//
//  NavigationTabView.swift
//  PharosNav
//
//  Created by Theo Sementa on 09/02/2026.
//

import SwiftUI

// MARK: - NavigationTabItem

/// A descriptor for a single tab: a label view and a content factory.
///
/// Use this with the `NavigationTabView(routerManager:tab:)` convenience initializer
/// to reduce per-tab boilerplate — the SDK wraps the content in a `NavigationStackView`
/// and applies the `.tabItem` modifier automatically.
///
/// ```swift
/// NavigationTabView(routerManager: appRouterManager) { flow in
///     switch flow {
///     case .home:
///         NavigationTabItem {
///             Label("Home", systemImage: "house")
///         } content: {
///             HomeScreen()
///         }
///     }
/// }
/// ```
public struct NavigationTabItem {
    let label: AnyView
    let content: () -> AnyView

    /// Creates a tab descriptor with a label view and a content factory.
    ///
    /// - Parameters:
    ///   - label: The tab bar label (e.g., `Label("Home", systemImage: "house")`).
    ///   - content: The root view displayed inside the tab's navigation stack.
    public init(
        @ViewBuilder label: () -> some View,
        @ViewBuilder content: @escaping () -> some View
    ) {
        self.label = AnyView(label())
        // Wrap in AnyView internally so the SDK can store items in a homogeneous
        // collection without surfacing AnyView to call-sites.
        let captured = content
        self.content = { AnyView(captured()) }
    }
}

// MARK: - NavigationTabView

/// A `TabView` wrapper bound to a `RouterManager`'s `selectedFlow`.
///
/// Two initializers are available:
/// - **Legacy** `init(selection:content:)` — keeps full manual control over each tab's content.
/// - **Convenience** `init(routerManager:tab:)` — reduces boilerplate by auto-wrapping each
///   `NavigationTabItem` in a `NavigationStackView` with the correct `routerManager` and `flow`.
public struct NavigationTabView<Tab: AppFlowProtocol, Content: View>: View {

    @Binding private var selection: Tab
    private let content: () -> Content

    // MARK: Init — legacy

    /// Creates a `NavigationTabView` with manual tab content.
    ///
    /// Use this when you need full control over each tab's view hierarchy.
    ///
    /// - Parameters:
    ///   - selection: A binding to the currently selected tab.
    ///   - content: A view builder providing all tab views (each wrapped in `NavigationStackView` + `.tabItem`).
    public init(
        selection: Binding<Tab>,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self._selection = selection
        self.content = content
    }

    // MARK: - View

    public var body: some View {
        TabView(selection: $selection) {
            content()
        }
    }

}

// MARK: - Convenience inits using RouterManagerTabView

extension NavigationTabView {

    /// Creates a `NavigationTabView` driven by a `RouterManager`, exposing only the
    /// explicitly listed `flows` as tabs.
    ///
    /// Use this initializer when some flows in your `Tab` enum are **not** tabs but
    /// must remain routable (e.g., an onboarding or profile flow presented modally
    /// from one of the tabs with `isTabPage: false`). Only the flows passed in
    /// `flows` get rendered as tab bar items; other flows still work for
    /// programmatic / modal navigation via the same `RouterManager`.
    ///
    /// Return `nil` from `tab` to skip a flow that you don't want as a visible tab —
    /// useful when keeping an exhaustive `switch` over `Tab`:
    ///
    /// ```swift
    /// NavigationTabView(routerManager: routerManager, flows: [.cat, .fruit]) { flow in
    ///     switch flow {
    ///     case .cat:    NavigationTabItem { Label("Cats", systemImage: "cat.fill") }   content: { CatsListScreen() }
    ///     case .fruit:  NavigationTabItem { Label("Fruits", systemImage: "apple.logo") } content: { FruitsListScreen() }
    ///     case .person: nil
    ///     }
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - routerManager: The shared router manager that owns a `Router` per flow.
    ///   - flows: The flows exposed as tabs, in display order.
    ///   - tab: A closure mapping each `Tab` value to a `NavigationTabItem`, or `nil` to skip it.
    public init<Destination: AppDestinationProtocol>(
        routerManager: RouterManager<Tab, Destination>,
        flows: [Tab],
        tab: @escaping (Tab) -> NavigationTabItem?
    ) where Content == _RouterManagerTabBody<Tab, Destination> {
        self._selection = Binding(
            get: { routerManager.selectedFlow },
            set: { routerManager.selectedFlow = $0 }
        )
        let rm = routerManager
        self.content = { _RouterManagerTabBody(routerManager: rm, flows: flows, tab: tab) }
    }

    /// Creates a `NavigationTabView` driven by a `RouterManager`, with every case
    /// in `Tab.allCases` rendered as a tab (unless the closure returns `nil`).
    ///
    /// Shortcut for the common case where all flows are tabs. If some flows should
    /// **not** be tabs, prefer ``init(routerManager:flows:tab:)`` and pass the
    /// explicit subset.
    ///
    /// - Parameters:
    ///   - routerManager: The shared router manager that owns a `Router` per flow.
    ///   - tab: A closure mapping each `Tab` value to a `NavigationTabItem`, or `nil` to skip it.
    public init<Destination: AppDestinationProtocol>(
        routerManager: RouterManager<Tab, Destination>,
        tab: @escaping (Tab) -> NavigationTabItem?
    ) where Tab: CaseIterable, Content == _RouterManagerTabBody<Tab, Destination> {
        self.init(routerManager: routerManager, flows: Array(Tab.allCases), tab: tab)
    }

}

// MARK: - _RouterManagerTabBody

/// Internal view that renders one `NavigationStackView` per listed flow, with tab labels.
/// Kept as a proper `View` struct so that `routerManager` is accessed on the main actor
/// inside `body`, satisfying Swift 6 strict concurrency.
public struct _RouterManagerTabBody<Tab: AppFlowProtocol, Destination: AppDestinationProtocol>: View {

    @Bindable var routerManager: RouterManager<Tab, Destination>
    let flows: [Tab]
    let tab: (Tab) -> NavigationTabItem?

    public var body: some View {
        ForEach(flows, id: \.self) { flow in
            if let item = tab(flow) {
                NavigationStackView(
                    routerManager: routerManager,
                    flow: flow,
                    initialContent: item.content
                )
                .tabItem { item.label }
            }
        }
    }

}
