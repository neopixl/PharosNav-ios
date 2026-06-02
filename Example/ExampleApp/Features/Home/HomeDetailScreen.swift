//
//  HomeDetailScreen.swift
//  ExampleApp
//
//  Reached via `.push(.home(.detail(id:)))`.
//  Demonstrates the back button (provided by `NavigationStack`) and
//  pushing yet another screen from a pushed screen (stack > 1).
//

import SwiftUI
import PharosNav

struct HomeDetailScreen: View {
    let id: Int

    var body: some View {
        List {
            Section("This screen was *pushed*") {
                Text("Item ID: \(id)")
                Text("Tap the back chevron in the navigation bar to pop, or use the toolbar button below.")
            }

            Section("Push another screen on top") {
                AppNavigationButton(target: .push(.home(.about))) {
                    Label("Push About", systemImage: "info.circle")
                }
            }
        }
        .navigationTitle("Detail #\(id)")
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
    HomeDetailScreen(id: 1)
}
