//
//  FittedPresentationDetentModifier.swift
//  PharosNav
//
//  Created by Theo Sementa on 25/06/2025.
//

import SwiftUI

/// A view modifier that automatically adjusts the sheet presentation height
/// to fit the content's intrinsic height.
///
/// This modifier is useful when you want a `.sheet` in SwiftUI to match its content's size
/// rather than using a fixed `.medium` or `.large` detent.
///
/// Internally, it uses a custom geometry reader to track the view's height and sets a presentation detent accordingly.
struct FittedPresentationDetentModifier: ViewModifier {
    
    /// The dynamically measured size of the content.
    @State private var contentSize: CGSize = .zero

    /// Modifies the content view by applying a fitted presentation detent based on its height.
    ///
    /// - Parameter content: The original content view.
    /// - Returns: A view with a custom presentation height matching its content.
    func body(content: Content) -> some View {
        content
            .onGeometryChange(for: CGSize.self, of: \.size) { newSize in
                guard newSize != .zero else { return }
                contentSize = newSize
            }
            .presentationDetents([.height(contentSize.height)])
            .fixedSize(horizontal: false, vertical: true)
    }
}

extension View {
    /// Applies a presentation detent that fits the height of the view’s content.
    ///
    /// Use this modifier in `.sheet` or modal presentations to ensure the height matches the content's
    /// natural size.
    ///
    /// - Returns: A modified view with a height-based presentation detent.
    ///
    /// ### Example:
    /// ```swift
    /// .sheet(isPresented: $isPresented) {
    ///     YourView()
    ///         .fittedPresentationDetent()
    /// }
    /// ```
    public func fittedPresentationDetent() -> some View {
        modifier(FittedPresentationDetentModifier())
    }
}
