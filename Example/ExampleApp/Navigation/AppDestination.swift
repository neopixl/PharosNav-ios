//
//  AppDestination.swift
//  ExampleApp
//
//  The single enum that aggregates **every feature's destinations**.
//
//  The `@RecursiveDestination` macro synthesises the conformance to
//  `RecursiveDestination` for you — never write the `unwrapped` switch by hand.
//
//  Each `case` here mirrors a feature. Note: an `AppFlow` does NOT need its own
//  destination case — destinations are per-feature, while flows are per-router.
//  The auxiliary `.nestedSheet` flow reuses `AdvancedDestination` cases inside
//  its stack.
//

import Foundation
import PharosNav

@RecursiveDestination
enum AppDestination: AppDestinationProtocol {
    case home(HomeDestination)
    case profile(ProfileDestination)
    case advanced(AdvancedDestination)
    case settings(SettingsDestination)
}
