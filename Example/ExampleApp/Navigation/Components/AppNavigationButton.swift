//
//  AppNavigationButton.swift
//  ExampleApp
//
//  Thin wrapper around `GenericNavigationButton` that **concretely binds**
//  the destination type to `AppDestination`.
//
//  This is the recommended pattern: it lets you write
//
//      AppNavigationButton(target: .push(.home(.about))) { Text("About") }
//
//  with leading-dot syntax (no `AppDestination.` prefix).
//

import SwiftUI
import PharosNav

struct AppNavigationButton<Label: View>: View {
    let target: NavigationTarget<AppDestination>
    @ViewBuilder let label: () -> Label

    var body: some View {
        GenericNavigationButton(target: target, label: label)
    }
}
