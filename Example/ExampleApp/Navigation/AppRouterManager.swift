//
//  AppRouterManager.swift
//  ExampleApp
//
//  Created by Theo Sementa on 09/02/2026.
//

import PharosNav

@MainActor
final class AppRouterManager: RouterManager<AppFlow, AppDestination> {
    static let shared: AppRouterManager = .init()

    init() {
        super.init(selectedFlow: .library)
    }
}
