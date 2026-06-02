//
//  SettingsRootScreen.swift
//  ExampleApp
//
//  Root of the **standalone Settings flow**, presented as `fullScreenCover`
//  from the Home tab.
//
//  Because Settings is NOT a tab, we wrap its content in our own
//  `NavigationStackView(routerManager:flow:isTabPage: false)`:
//
//  - it gives the flow its own `Router` (independent of the Home/Profile tabs);
//  - `isTabPage: false` makes the SDK *unregister* the router when the modal
//    is dismissed, and restore the previous flow as the active one.
//

import SwiftUI
import PharosNav

struct SettingsRootScreen: View {

    private let routerManager: AppRouterManager = .shared

    var body: some View {
        NavigationStackView(
            routerManager: routerManager,
            flow: .settings,
            isTabPage: false
        ) {
            content
        }
    }
}

private extension SettingsRootScreen {
    var content: some View {
        List {
            Section("Push inside the Settings stack") {
                AppNavigationButton(target: .push(.settings(.account))) {
                    Label("Account", systemImage: "person.crop.circle")
                }
                AppNavigationButton(target: .push(.settings(.notifications))) {
                    Label("Notifications", systemImage: "bell")
                }
            }

            Section("Dismiss the whole flow") {
                Text("The toolbar button uses `behavior: .auto` — at the root of a presentation it resolves to **dismiss**, closing the entire Settings flow.")
            }
        }
        .navigationTitle("Settings")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationDismissButton {
                    Label("Close", systemImage: "xmark")
                }
            }
        }
    }
}

#Preview {
    SettingsRootScreen()
}
