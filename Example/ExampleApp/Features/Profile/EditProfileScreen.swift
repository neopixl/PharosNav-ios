//
//  EditProfileScreen.swift
//  ExampleApp
//
//  Presented via `.sheet(...)` from `ProfileScreen`. Demonstrates that the
//  `NavigationDismissButton(behavior: .auto)` automatically *dismisses* the
//  sheet when used at the root of a presentation (instead of popping).
//

import SwiftUI
import PharosNav

struct EditProfileScreen: View {

    @State private var displayName: String = "Ada Lovelace"

    var body: some View {
        NavigationStack {
            Form {
                Section("Displayed name") {
                    TextField("Name", text: $displayName)
                }

                Section("How dismiss works here") {
                    Text("This screen was *presented* (not pushed), so `NavigationDismissButton(behavior: .auto)` resolves to **dismiss** — closing the sheet.")
                }
            }
            .navigationTitle("Edit profile")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationDismissButton {
                        Label("Close", systemImage: "xmark")
                    }
                }
            }
        }
    }
}

#Preview {
    EditProfileScreen()
}
