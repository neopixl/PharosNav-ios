//
//  Route.swift
//  PharosNav
//
//  Created by Theo Sementa on 24/06/2025.
//

import Foundation
import SwiftUI

public enum SheetStyle: Equatable {
    case medium
    case large
    case canFullScreen
    case fitContent(bgColor: Color? = nil)
}

/// Enumeration of all type of navigation available
public enum Route: Equatable {
    case push
    case sheet(style: SheetStyle)
    case fullScreenCover
}

extension Route {
    var isPresentable: Bool {
        self != .push
    }
}
