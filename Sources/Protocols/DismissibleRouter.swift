//
//  DismissibleRouter.swift
//  PharosNav
//
//  Created by Theo Sementa on 01/06/2026.
//

import Foundation
import SwiftUI

/// A non-generic abstraction over `Router` that exposes only what is needed
/// to implement context-aware dismissal, without leaking the `AppDestination` generic.
public protocol DismissibleRouter: AnyObject {
    /// The current stack depth. `> 0` means the view was pushed.
    var navigationPathCount: Int { get }
    /// Pops the last destination from the navigation stack.
    func pop()
    /// Pops all destinations back to the root of the navigation stack.
    func popToRoot()
}

// MARK: - Environment key

struct DismissibleRouterKey: EnvironmentKey {
    static var defaultValue: (any DismissibleRouter)? { nil }
}

public extension EnvironmentValues {
    var dismissibleRouter: (any DismissibleRouter)? {
        get { self[DismissibleRouterKey.self] }
        set { self[DismissibleRouterKey.self] = newValue }
    }
}
