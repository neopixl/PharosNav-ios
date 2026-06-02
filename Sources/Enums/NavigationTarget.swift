//
//  NavigationTarget.swift
//  PharosNav
//
//  Created by Theo Sementa on 01/06/2026.
//

import Foundation

/// Encodes all valid navigation actions in a type-safe way,
/// making invalid combinations (e.g. pushMany with a sheet) inexpressible at compile time.
public enum NavigationTarget<D: AppDestinationProtocol> {
    /// Push a single destination onto the navigation stack.
    case push(D)
    /// Push multiple destinations sequentially onto the navigation stack.
    case pushMany([D])
    /// Present a destination as a sheet with the given style.
    case sheet(SheetStyle, D, onDismiss: (() -> Void)? = nil)
    /// Present a destination as a full-screen cover.
    case fullScreenCover(D, onDismiss: (() -> Void)? = nil)
}
