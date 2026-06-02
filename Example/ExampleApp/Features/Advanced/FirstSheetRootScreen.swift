//
//  FirstSheetRootScreen.swift
//  ExampleApp
//
//  Step 1 — content of the outer `.large` sheet, presented by the Advanced tab.
//
//  KEY POINT: we wrap our content in a nested `NavigationStackView` using a
//  **different** flow (`.nestedSheet`). This gives the inner navigation:
//    • its own `navigationPath` (so we can push without affecting the tab's stack)
//    • its own presentation slot (so we can stack another sheet on top later)
//
//  `isTabPage: false` is critical — see the rule in NavigationStackView's docs.
//

import SwiftUI
import PharosNav

struct FirstSheetRootScreen: View {

    private let routerManager: AppRouterManager = .shared

    var body: some View {
        NavigationStackView(
            routerManager: routerManager,
            flow: .nestedSheet,
            isTabPage: false
        ) {
            content
        }
    }
}

private extension FirstSheetRootScreen {
    var content: some View {
        List {
            Section {
                Text("You're inside the outer sheet. This content lives in its own NavigationStackView (flow: `.nestedSheet`), so the buttons below act on the **nested** router, not the Advanced tab's.")
            }

            Section("Step 2 — push inside this sheet") {
                AppNavigationButton(target: .push(.advanced(.firstSheetPushed))) {
                    Label("Push to the next screen", systemImage: "arrow.right")
                }
            }
        }
        .navigationTitle("Outer sheet")
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
    FirstSheetRootScreen()
}
