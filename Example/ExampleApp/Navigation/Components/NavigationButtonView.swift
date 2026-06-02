//
//  NavigationButtonView.swift
//  PharosNav
//
//  Created by Theo Sementa on 24/06/2025.
//
//  Wrapper Example — concretely binds `AppDestination` so call-sites can use
//  the leading-dot syntax (`.person(.home)`) without having to prefix the enum.
//

import SwiftUI
import PharosNav

struct NavigationButtonView<Label: View>: View {

    // MARK: Dependencies
    private let target: NavigationTarget<AppDestination>
    private let onNavigate: (() -> Void)?
    private let label: () -> Label

    // MARK: Init
    init(
        target: NavigationTarget<AppDestination>,
        onNavigate: (() -> Void)? = nil,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.target = target
        self.onNavigate = onNavigate
        self.label = label
    }

    // MARK: - View
    var body: some View {
        GenericNavigationButton(
            target: target,
            onNavigate: onNavigate,
            label: label
        )
    }
}
