//
//  ChainModalRootScreen.swift
//  ExampleApp
//
//  Scenario B — Step 2 of 3.
//
//  Root of the modal sheet, presented from `ChainPushedScreen`.
//
//  KEY POINT: like the sheet-stacking demo, we wrap our content in a nested
//  `NavigationStackView` bound to the auxiliary `.chainModal` flow:
//   • it gives the modal its OWN `navigationPath` (independent from the
//     Advanced tab's stack), so the next push happens INSIDE the modal;
//   • `isTabPage: false` makes the SDK unregister this router on dismiss and
//     restore the previous flow as the active one.
//

import SwiftUI
import PharosNav

struct ChainModalRootScreen: View {

    private let routerManager: AppRouterManager = .shared

    var body: some View {
        NavigationStackView(
            routerManager: routerManager,
            flow: .chainModal,
            isTabPage: false
        ) {
            content
        }
    }
}

private extension ChainModalRootScreen {
    var content: some View {
        List {
            Section {
                Text("You're inside a **modal** sheet, which was opened from a *pushed* screen on the Advanced tab.")
                Text("This content lives in its own NavigationStackView (flow: `.chainModal`), so the push below acts on the modal's nested router — not on the Advanced tab's stack.")
            }

            Section("Step 3 — push inside the modal") {
                AppNavigationButton(target: .push(.advanced(.chainModalPushed))) {
                    Label("Push to the next screen", systemImage: "arrow.right")
                }
            }
        }
        .navigationTitle("Step 2 — modal")
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
    ChainModalRootScreen()
}
