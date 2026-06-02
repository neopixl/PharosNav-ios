//
//  HomeAboutScreen.swift
//  ExampleApp
//
//  Plain pushed screen — no associated value.
//

import SwiftUI
import PharosNav

struct HomeAboutScreen: View {
    var body: some View {
        List {
            Section {
                Text("This screen demonstrates a parameter-less push destination — `.push(.home(.about))`.")
                Text("Use the toolbar button to dismiss (here `.auto` resolves to *pop*, because the screen was pushed).")
            }
        }
        .navigationTitle("About")
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
    HomeAboutScreen()
}
