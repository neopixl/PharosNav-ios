//
//  SettingsDestination.swift
//  ExampleApp
//
//  Destinations of the Settings flow.
//  `.root` is the entry-point screen of the standalone (non-tab) flow —
//  it's presented as `fullScreenCover` from any tab. The two other screens
//  are then *pushed* on top of `.root` inside the Settings stack.
//

import PharosNav

enum SettingsDestination: DestinationItem {
    case root
    case account
    case notifications
}
