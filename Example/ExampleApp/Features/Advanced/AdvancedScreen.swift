//
//  AdvancedScreen.swift
//  ExampleApp
//
//  Tab #3 — two advanced navigation demos:
//
//  • **Sheet stacking** — outer sheet → push inside → second sheet stacked on top
//  • **Push → Modal → Push** — push on the tab stack → present a modal →
//    push again inside the modal's own stack
//
//  Both scenarios share the same key idea: **1 Router = 1 presentation slot**.
//  To go beyond the simple cases, you give the inner content its own router by
//  wrapping it in a nested `NavigationStackView(isTabPage: false)` bound to an
//  auxiliary flow.
//

import SwiftUI
import PharosNav

struct AdvancedScreen: View {
    var body: some View {
        List {
            Section("Scenario A — Sheet stacking") {
                Text("Open a large sheet, push inside it, then present a second sheet that **stacks on top** of the first one.")
                AppNavigationButton(target: .sheet(.large, .advanced(.firstSheetRoot))) {
                    Label("Start scenario A", systemImage: "rectangle.stack.badge.plus")
                }
            }

            Section("Scenario B — Push → Modal → Push") {
                Text("Push a screen on the Advanced tab's stack, then from that pushed screen present a sheet, then push again **inside** the sheet.")
                AppNavigationButton(target: .push(.advanced(.chainPushed))) {
                    Label("Start scenario B", systemImage: "arrow.triangle.branch")
                }
            }
        }
        .navigationTitle("Advanced")
    }
}

#Preview {
    AdvancedScreen()
}
