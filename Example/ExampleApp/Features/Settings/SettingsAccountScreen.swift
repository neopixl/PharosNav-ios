//
//  SettingsAccountScreen.swift
//  ExampleApp
//
//  Pushed inside the Settings flow.
//
//  Important nuance about `behavior: .dismiss` from a *pushed* screen:
//  SwiftUI's `@Environment(\.dismiss)` resolves to the **closest** dismissible
//  context. Inside a pushed view of a `NavigationStack`, that is the push
//  itself (back action), NOT the fullScreenCover that hosts the whole flow.
//
//  To actually close the **entire** modal flow from here, target the router
//  that owns the cover — i.e. the *previous* flow's router (Home in our case).
//  We use `dismissAction:` on `NavigationDismissButton` for that.
//

import SwiftUI
import PharosNav

struct SettingsAccountScreen: View {

    private let routerManager: AppRouterManager = .shared

    var body: some View {
        Form {
            LabeledContent("Username", value: "ada.lovelace")
            LabeledContent("Email",    value: "ada@example.com")

            Section("In-stack dismiss behaviours") {
                NavigationDismissButton(behavior: .pop) {
                    Label("Pop one level (back)", systemImage: "chevron.left")
                }
                NavigationDismissButton(behavior: .popToRoot) {
                    Label("Pop to Settings root", systemImage: "arrow.uturn.left")
                }
            }

            Section("Close the entire Settings flow") {
                NavigationDismissButton(dismissAction: closeWholeFlow) {
                    Label("Back to Home", systemImage: "xmark.circle.fill")
                }
            }
        }
        .navigationTitle("Account")
    }
}

// MARK: - Private methods
private extension SettingsAccountScreen {
    /// Closes the host `fullScreenCover` of the Settings flow by dismissing the
    /// presentation owned by the *previous* flow's router (Home).
    func closeWholeFlow() {
        guard let previousFlow = routerManager.previousFlow else { return }
        routerManager.existingRouter(for: previousFlow)?.dismiss()
    }
}

#Preview {
    SettingsAccountScreen()
}
