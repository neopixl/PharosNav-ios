//
//  FirstSheetPushedScreen.swift
//  ExampleApp
//
//  Step 2 — pushed inside the *nested* stack of the outer sheet.
//  From here we present another `.large` sheet, which stacks on top because the
//  nested router's presentation slot was free.
//

import SwiftUI
import PharosNav

struct FirstSheetPushedScreen: View {
    var body: some View {
        List {
            Section {
                Text("You're now one push deep, **inside** the outer sheet's nested stack.")
                Text("The button below presents another sheet — because the nested router's slot is still empty, SwiftUI stacks the new sheet on top of this one instead of replacing the outer sheet.")
            }

            Section("Step 3 — stack a second sheet on top") {
                AppNavigationButton(target: .sheet(.large, .advanced(.stackedSheetRoot))) {
                    Label("Open stacked sheet", systemImage: "square.stack.3d.up")
                }
            }
        }
        .navigationTitle("Step 2")
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
    FirstSheetPushedScreen()
}
