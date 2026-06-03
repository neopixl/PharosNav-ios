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
    ///   - hidesTabBarOnPush: When `true` (default), each tab's tab bar is hidden as
    ///     soon as the corresponding `Router` has at least one destination on its
    ///     navigation path — and restored when popped back to the root. Set to `false`
    ///     to keep SwiftUI's native behaviour where the tab bar stays visible during
    ///     pushed navigation.
    ///   - tab: A closure mapping each `Tab` value to a `NavigationTabItem`, or `nil` to skip it.
    public init<Destination: AppDestinationProtocol>(
        routerManager: RouterManager<Tab, Destination>,
        flows: [Tab],
        hidesTabBarOnPush: Bool = true,
        tab: @escaping (Tab) -> NavigationTabItem?
    ) where Content == _RouterManagerTabBody<Tab, Destination> {
        self._selection = Binding(
            get: { routerManager.selectedFlow },
            set: { routerManager.selectedFlow = $0 }
        )
        let rm = routerManager
        self.content = {
            _RouterManagerTabBody(
                routerManager: rm,
                flows: flows,
                hidesTabBarOnPush: hidesTabBarOnPush,
                tab: tab
            )
        }
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
    ///   - hidesTabBarOnPush: See ``init(routerManager:flows:hidesTabBarOnPush:tab:)``.
    ///     Defaults to `true`.
    ///   - tab: A closure mapping each `Tab` value to a `NavigationTabItem`, or `nil` to skip it.
    public init<Destination: AppDestinationProtocol>(
        routerManager: RouterManager<Tab, Destination>,
        hidesTabBarOnPush: Bool = true,
        tab: @escaping (Tab) -> NavigationTabItem?
    ) where Tab: CaseIterable, Content == _RouterManagerTabBody<Tab, Destination> {
        self.init(
            routerManager: routerManager,
            flows: Array(Tab.allCases),
            hidesTabBarOnPush: hidesTabBarOnPush,
            tab: tab
        )
    }

}

// MARK: - _RouterManagerTabBody

/// Internal view that renders one `NavigationStackView` per listed flow, with tab labels.
/// Kept as a proper `View` struct so that `routerManager` is accessed on the main actor
/// inside `body`, satisfying Swift 6 strict concurrency.
public struct _RouterManagerTabBody<Tab: AppFlowProtocol, Destination: AppDestinationProtocol>: View {

    @Bindable var routerManager: RouterManager<Tab, Destination>
    let flows: [Tab]
    let hidesTabBarOnPush: Bool
    let tab: (Tab) -> NavigationTabItem?

    public var body: some View {
        ForEach(flows, id: \.self) { flow in
            if let item = tab(flow) {
                tabContent(for: flow, item: item)
            }
        }
    }

}

// MARK: - Private helpers

private extension _RouterManagerTabBody {

    /// Per-tab content with reactive tab-bar visibility.
    ///
    /// Hiding the tab bar **on the destination view** (the SwiftUI-stock workaround)
    /// produces a visible lag on back: the destination is torn down first, then the
    /// tab bar animates back in as a separate transition. Instead we bind the tab-bar
    /// visibility to the tab's own `Router.navigationPath` emptiness, *here at the
    /// root of the tab*. The toolbar visibility update is synchronous with the path
    /// change → it animates together with the push / pop, no flicker.
    ///
    /// Reactivity: `routerManager` is `@Bindable` and `Router` is `@Observable`, so
    /// reading `router.navigationPath.isEmpty` inside this view body registers as a
    /// dependency and re-evaluates on push / pop.
    @ViewBuilder
    func tabContent(for flow: Tab, item: NavigationTabItem) -> some View {
        let router = routerManager.getRouter(for: flow)
        NavigationStackView(
            routerManager: routerManager,
            flow: flow,
            initialContent: item.content
        )
        .tabItem { item.label }
        .toolbar(
            tabBarVisibility(for: router),
            for: .tabBar
        )
    }

    /// Resolves the desired tab-bar visibility for a given flow's router.
    ///
    /// When `hidesTabBarOnPush` is disabled, we return `.automatic` so SwiftUI keeps
    /// its native behaviour (tab bar stays visible during pushed navigation).
    func tabBarVisibility(for router: Router<Destination>) -> Visibility {
        guard hidesTabBarOnPush else { return .automatic }
        return router.navigationPath.isEmpty ? .visible : .hidden
    }

}
