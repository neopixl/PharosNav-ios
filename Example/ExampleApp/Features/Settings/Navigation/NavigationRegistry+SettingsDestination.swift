//
//  NavigationRegistry+SettingsDestination.swift
//  ExampleApp
//

import SwiftUI
import PharosNav

extension NavigationRegistry {
    func registerSettingsDestination() {
        register(SettingsDestination.self) { destination in
            switch destination {
            case .root:          SettingsRootScreen()
            case .account:       SettingsAccountScreen()
            case .notifications: SettingsNotificationsScreen()
            }
        }
    }
}
