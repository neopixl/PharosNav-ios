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
            case .firstSheetRoot:   FirstSheetRootScreen()
            case .firstSheetPushed: FirstSheetPushedScreen()
            case .stackedSheetRoot: StackedSheetRootScreen()
            }
        }
    }
}
