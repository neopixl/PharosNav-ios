//
//  ContentView.swift
//  ExampleApp
//
//  Root view of the app.
//
//  `NavigationTabView(routerManager:flows:)` is the SDK component that:
//  - renders a `TabView` bound to `routerManager.selectedFlow`;
//  - wraps each tab's root view in its own `NavigationStackView` automatically;
//  - lazily creates a `Router` per tab on demand.
//
//  The `flows:` array declares exactly **which** flows are tabs.
//  `.settings` and `.nestedSheet` are intentionally excluded:
//   - `.settings`    is opened modally from Home as a `fullScreenCover`.
//   - `.nestedSheet` is an auxiliary flow used inside the Advanced tab's sheet
//                    to provide a second presentation slot (stacking demo).
//

import SwiftUI
import PharosNav

struct ContentView: View {

    @State private var appRouterManager: AppRouterManager = .shared

    var body: some View {
        NavigationTabView(
            routerManager: appRouterManager,
            flows: [.home, .profile, .advanced]
        ) { flow in
            switch flow {
            case .home:
                NavigationTabItem {
                    Label("Home", systemImage: "house")
                } content: {
                    HomeScreen()
                }
            case .profile:
                NavigationTabItem {
                    Label("Profile", systemImage: "person.crop.circle")
                } content: {
                    ProfileScreen()
                }
            case .advanced:
                NavigationTabItem {
                    Label("Advanced", systemImage: "square.stack.3d.up")
                } content: {
                    AdvancedScreen()
                }
            case .settings, .nestedSheet, .chainModal:
                // Non-tab flows.
                nil
            }
        }
    }
}

#Preview {
    ContentView()
}
