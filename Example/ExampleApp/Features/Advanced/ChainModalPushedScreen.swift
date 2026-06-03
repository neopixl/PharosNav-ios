//
//  ChainModalPushedScreen.swift
//  ExampleApp
//
//  Scenario B — Step 3 of 3.
//
//  Pushed inside the modal's nested stack (`.chainModal` router).
//  At this point three navigation levels are alive simultaneously:
//   1. Advanced tab stack: [.chainPushed]
//   2. Modal sheet presented from `.chainPushed`
//   3. ChainModal stack: [.chainModalPushed]  ← you are here
//

import SwiftUI
import PharosNav

struct ChainModalPushedScreen: View {

    private let routerManager: AppRouterManager = .shared

    var body: some View {
        List {
            Section {
                Text("You're now **two pushes deep**, but the second push is inside the modal — not on the Advanced tab.")
                Text("Closing the modal returns you to *Step 1 — pushed*, still on the Advanced tab. From there, the back chevron pops back to the Advanced root.")
            }

            Section("Dismiss buttons") {
                NavigationDismissButton(behavior: .auto) {
                    Label("Auto (pops one level inside modal)", systemImage: "chevron.left")
                }
                NavigationDismissButton(dismissAction: closeWholeModal) {
                    Label("Close the entire modal", systemImage: "xmark.circle.fill")
                }
            }
        }
        .navigationTitle("Step 3 — pushed in modal")
    }
}

// MARK: - Private methods
private extension ChainModalPushedScreen {
    /// Closes the host sheet by dismissing the presentation on the **previous**
    /// flow's router — same trick as `SettingsAccountScreen`.
    func closeWholeModal() {
        guard let previousFlow = routerManager.previousFlow else { return }
        routerManager.existingRouter(for: previousFlow)?.dismiss()
    }
}

#Preview {
    ChainModalPushedScreen()
}
