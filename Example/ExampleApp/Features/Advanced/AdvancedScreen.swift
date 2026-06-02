//
//  AdvancedScreen.swift
//  ExampleApp
//
//  Tab #3 — **Sheet-stacking demo**.
//
//  Entry point of the scenario:
//     Advanced tab
//         └─ tap "Step 1" → .sheet(.large, .advanced(.firstSheetRoot))
//              └─ (inside FirstSheetRootScreen — see that file)
//                   ↳ wraps itself in a *nested* NavigationStackView using the
//                     auxiliary `.nestedSheet` flow → its own router, its own
//                     presentation slot.
//                   ↳ push inside the nested stack
//                   ↳ from the pushed screen, present ANOTHER .large sheet on
//                     top — *stacks* because the nested router's slot was free.
//

import SwiftUI
import PharosNav

struct AdvancedScreen: View {
    var body: some View {
        List {
            Section {
                Text("This tab walks you through the full sheet-stacking pattern: outer sheet → push → inner sheet on top.")
                Text("Why a separate `.nestedSheet` flow exists: **1 Router = 1 presentation slot**. The Advanced router's slot is already taken by the outer sheet — to stack another one we need a second router.")
            }

            Section("Step 1 — open the outer sheet") {
                AppNavigationButton(target: .sheet(.large, .advanced(.firstSheetRoot))) {
                    Label("Open Step 1 (large sheet)", systemImage: "rectangle.stack.badge.plus")
                }
            }
        }
        .navigationTitle("Advanced")
    }
}

#Preview {
    AdvancedScreen()
}
