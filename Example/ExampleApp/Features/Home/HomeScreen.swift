//
//  HomeScreen.swift
//  ExampleApp
//
//  Tab #1 — demonstrates the simplest case: pushing destinations on the stack.
//
//  - `.push(.home(.detail(id:)))`    → push a screen with an associated value
//  - `.push(.home(.about))`          → push a parameter-less screen
//  - `.fullScreenCover(.settings(.root))` → present a *standalone flow*
//                                           (cross-flow navigation, see SettingsScreen).
//

import SwiftUI
import PharosNav

struct HomeScreen: View {
    var body: some View {
        List {
            Section("Push on the Home stack") {
                ForEach(1...3, id: \.self) { id in
                    AppNavigationButton(target: .push(.home(.detail(id: id)))) {
                        Label("Open item #\(id)", systemImage: "doc.text")
                    }
                }
                AppNavigationButton(target: .push(.home(.about))) {
                    Label("About this app", systemImage: "info.circle")
                }
            }

            Section("Open another flow") {
                AppNavigationButton(target: .fullScreenCover(.settings(.root))) {
                    Label("Open Settings (modal flow)", systemImage: "gearshape")
                }
            }
        }
        .navigationTitle("Home")
    }
}

#Preview {
    HomeScreen()
}
