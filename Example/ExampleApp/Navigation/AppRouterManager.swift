//
//  AppRouterManager.swift
//  ExampleApp
//
//  Single subclass of `RouterManager`, kept as a `shared` singleton.
//
//  - You never instantiate `Router` manually — `RouterManager` allocates one
//    per flow on demand the first time someone reads it.
//  - `selectedFlow` here is the initial tab shown on launch.
//  - Anywhere in the app, read the current router via:
//        AppRouterManager.shared.currentRouter
//    (and in non-View code, prefer the `Routable` protocol — see Shared/).
//

import PharosNav

@MainActor
final class AppRouterManager: RouterManager<AppFlow, AppDestination> {
    static let shared: AppRouterManager = .init()

    init() {
        super.init(selectedFlow: .home)
    }
}
