//
//  HomeDestination.swift
//  ExampleApp
//
//  Every feature owns a small enum conforming to `DestinationItem`.
//  Each case is a screen reachable inside the Home flow.
//

import PharosNav

enum HomeDestination: DestinationItem {
    case detail(id: Int)
    case about
}
