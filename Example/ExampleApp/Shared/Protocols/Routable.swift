//
//  Routable.swift
//  ExampleApp
//
//  Created by Theo Sementa on 09/02/2026.
//

import PharosNav

/// Grants access to the current `Router` from any type that needs to trigger navigation.
///
/// Adopt `Routable` on **anything** that drives navigation — architecture-agnostic:
/// - MVVM `ViewModel`
/// - TCA `Reducer` / `Effect`
/// - MVI `Intent` / `Store`
/// - Plain Coordinator or Service
///
/// The default implementation reads the active router from `AppRouterManager.shared`.
/// Because `currentRouter` follows `activeFlow` (not `selectedFlow`), this works
/// correctly even from inside modal flows presented over the tab bar.
protocol Routable {}

extension Routable {

    @MainActor
    var router: Router<AppDestination>? {
        AppRouterManager.shared.currentRouter
    }

}
