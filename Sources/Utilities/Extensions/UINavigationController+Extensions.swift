//
//  UINavigationController+InteractivePop.swift
//  RoutedNavigation
//
//  Created by Theo Sementa on 05/04/2025.
//

import Foundation
import UIKit

/// Extends `UINavigationController` to enable interactive pop gestures (swipe-to-go-back),
/// even when using custom navigation logic.
///
/// This extension sets the navigation controller as the delegate of its `interactivePopGestureRecognizer`
/// and restricts gesture activation to when there's more than one view controller in the stack.
extension UINavigationController: @retroactive UIGestureRecognizerDelegate {

    /// Called after the controller's view is loaded into memory.
    ///
    /// Sets the interactive pop gesture recognizer's delegate to the navigation controller
    /// to enable custom handling of the swipe-back gesture.
    override open func viewDidLoad() {
        super.viewDidLoad()
        /// Block swipe gesture to go back because it freezes the app for iOS17 and lower
        if #available(iOS 18.0, *) {
            interactivePopGestureRecognizer?.delegate = self
        }
    }

    /// Determines whether the gesture recognizer should begin recognizing.
    ///
    /// - Parameter gestureRecognizer: The gesture recognizer to evaluate.
    /// - Returns: `true` if there is more than one view controller on the stack, allowing the gesture to begin.
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
