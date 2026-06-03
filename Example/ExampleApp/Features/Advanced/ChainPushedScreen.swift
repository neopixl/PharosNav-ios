//
//  ChainPushedScreen.swift
//  ExampleApp
//
//  Scenario B — Step 1 of 3.
//
//  Pushed on the Advanced tab's stack via `.push(.advanced(.chainPushed))`.
//  From here we present a modal (sheet) — that's Step 2.
//

import SwiftUI
import PharosNav

struct ChainPushedScreen: View {
    var body: some View {
        List {
            Section {
                Text("You are now **pushed** on the Advanced tab's stack.")
                Text("Next: from this pushed screen, present a modal sheet. The sheet will host its own nested stack so you can push deeper inside it.")
            }

            Section("Step 2 — present the modal") {
                AppNavigationButton(target: .sheet(.large, .advanced(.chainModalRoot))) {
                    Label("Open modal (large sheet)", systemImage: "rectangle.portrait.on.rectangle.portrait")
                }
            }
        }
        .navigationTitle("Step 1 — pushed")
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
    ChainPushedScreen()
}
