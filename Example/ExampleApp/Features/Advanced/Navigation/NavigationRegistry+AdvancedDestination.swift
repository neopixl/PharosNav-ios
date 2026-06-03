//
//  NavigationRegistry+AdvancedDestination.swift
//  ExampleApp
//

import SwiftUI
import PharosNav

extension NavigationRegistry {
    func registerAdvancedDestination() {
        register(AdvancedDestination.self) { destination in
            switch destination {
            // Scenario A — sheet stacking
            case .firstSheetRoot:   FirstSheetRootScreen()
            case .firstSheetPushed: FirstSheetPushedScreen()
            case .stackedSheetRoot: StackedSheetRootScreen()

            // Scenario B — push → modal → push
            case .chainPushed:       ChainPushedScreen()
            case .chainModalRoot:    ChainModalRootScreen()
            case .chainModalPushed:  ChainModalPushedScreen()
            }
        }
    }
}
