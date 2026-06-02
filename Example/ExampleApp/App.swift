//
//  App.swift
//  ExampleApp
//
//  The single place where every feature module *registers itself* with the
//  shared `NavigationRegistry`. Each `register…Destination()` call lives in
//  its own feature folder — there is no central switch statement.
//
//  Adding a new flow = create the feature + call its `register…` here. Done.
//

import SwiftUI
import PharosNav

@main
struct ExampleAppApp: App {

    init() {
        NavigationRegistry.shared.registerHomeDestination()
        NavigationRegistry.shared.registerProfileDestination()
        NavigationRegistry.shared.registerAdvancedDestination()
        NavigationRegistry.shared.registerSettingsDestination()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
