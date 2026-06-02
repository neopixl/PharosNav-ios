//
//  StackedSheetRootScreen.swift
//  ExampleApp
//
//  Step 3 — the *second* sheet, stacked directly on top of the first.
//
//  You're now in: outer sheet → push → inner sheet. Three presentation levels
//  visible at once. Closing this sheet returns you to Step 2 (still inside the
//  outer sheet); closing the outer sheet returns you to the Advanced tab.
//

import SwiftUI
import PharosNav

struct StackedSheetRootScreen: View {
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Text("This is a brand-new `.large` sheet, presented on top of the first one.")
                    Text("Behind the scenes: the Advanced router holds the outer sheet, and the `.nestedSheet` router holds *this* sheet. Two routers → two slots → two visible sheets.")
                }
            }
            .navigationTitle("Stacked sheet")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationDismissButton(behavior: .dismiss) {
                        Label("Close", systemImage: "xmark")
                    }
                }
            }
        }
    }
}

#Preview {
    StackedSheetRootScreen()
}
