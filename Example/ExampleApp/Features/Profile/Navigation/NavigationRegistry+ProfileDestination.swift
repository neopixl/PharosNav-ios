//
//  NavigationRegistry+ProfileDestination.swift
//  ExampleApp
//

import SwiftUI
import PharosNav

extension NavigationRegistry {
    func registerProfileDestination() {
        register(ProfileDestination.self) { destination in
            switch destination {
            case .edit:        EditProfileScreen()
            case .preferences: PreferencesScreen()
            }
        }
    }
}
