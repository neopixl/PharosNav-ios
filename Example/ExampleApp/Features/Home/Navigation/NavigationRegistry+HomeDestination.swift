//
//  NavigationRegistry+HomeDestination.swift
//  ExampleApp
//
//  Each feature owns its **own** extension on `NavigationRegistry`.
//  No central switch — the Home feature is the only place that knows how
//  to map a `HomeDestination` to a SwiftUI view.
//
//  This method is called once at launch from `App.init`.
//

import SwiftUI
import PharosNav

extension NavigationRegistry {
    func registerHomeDestination() {
        register(HomeDestination.self) { destination in
            switch destination {
            case .detail(let id): HomeDetailScreen(id: id)
            case .about:          HomeAboutScreen()
            }
        }
    }
}
