//
//  DestinationItem.swift
//  PharosNav
//
//  Created by Theo Sementa on 25/06/2025.
//

import Foundation

/// ### Example
/// ```swift
///  enum AppDestination: AppDestinationProtocol {
///     case person(PersonDestiation)
///  }
///
///  enum PersonDestination: DestinationItem {
///     case list
///     case add(name: String)
///  }
/// ```
public protocol DestinationItem: Equatable, Hashable { }
