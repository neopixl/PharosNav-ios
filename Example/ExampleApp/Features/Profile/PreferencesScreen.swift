//
//  PreferencesScreen.swift
//  ExampleApp
//
//  Reached via `.push(.profile(.preferences))` — from a button OR from the
//  `ProfileScreen.ViewModel` through `Routable`.
//

import SwiftUI
import PharosNav

struct PreferencesScreen: View {

    @State private var notificationsEnabled: Bool = true
    @State private var hapticsEnabled: Bool = false

    var body: some View {
        Form {
            Toggle("Enable notifications", isOn: $notificationsEnabled)
            Toggle("Enable haptics",       isOn: $hapticsEnabled)

            Section("How dismiss works here") {
                Text("This screen was *pushed*, so `NavigationDismissButton(behavior: .auto)` resolves to **pop** — going back one level on the Profile stack.")
            }
        }
        .navigationTitle("Preferences")
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
    PreferencesScreen()
}
