//
//  SettingsNotificationsScreen.swift
//  ExampleApp
//

import SwiftUI
import PharosNav

struct SettingsNotificationsScreen: View {

    @State private var pushEnabled: Bool = true
    @State private var emailEnabled: Bool = false

    var body: some View {
        Form {
            Toggle("Push notifications",  isOn: $pushEnabled)
            Toggle("Email notifications", isOn: $emailEnabled)
        }
        .navigationTitle("Notifications")
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
    SettingsNotificationsScreen()
}
