//
//  ProfileScreen.swift
//  ExampleApp
//
//  Tab #2 — demonstrates **sheet** presentations and the `Routable` pattern.
//
//  - `.sheet(.medium, .profile(.edit))` → present a medium-detent sheet
//  - `.push(.profile(.preferences))`    → push on the Profile stack
//  - A ViewModel conforming to `Routable` drives navigation from non-View code.
//

import SwiftUI
import PharosNav

struct ProfileScreen: View {

    @State private var viewModel: ViewModel = .init()

    var body: some View {
        List {
            Section("Sheet presentations") {
                AppNavigationButton(target: .sheet(.medium, .profile(.edit))) {
                    Label("Edit profile (medium sheet)", systemImage: "pencil")
                }
                AppNavigationButton(target: .sheet(.large, .profile(.edit))) {
                    Label("Edit profile (large sheet)", systemImage: "pencil.circle")
                }
                AppNavigationButton(target: .sheet(.canFullScreen, .profile(.edit))) {
                    Label("Edit profile (canFullScreen)", systemImage: "arrow.up.and.down")
                }
            }

            Section("Push") {
                AppNavigationButton(target: .push(.profile(.preferences))) {
                    Label("Preferences (pushed)", systemImage: "slider.horizontal.3")
                }
            }

            Section("Triggered from a ViewModel (Routable)") {
                Button {
                    viewModel.openPreferences()
                } label: {
                    Label("Open preferences via ViewModel", systemImage: "bolt")
                }
            }
        }
        .navigationTitle("Profile")
    }
}

// MARK: - Declaration
extension ProfileScreen {
    @Observable @MainActor final class ViewModel: Routable {}
}

// MARK: - Public methods
extension ProfileScreen.ViewModel {
    /// Demonstrates `Routable`: navigation triggered from non-View code.
    /// `router` is resolved through `AppRouterManager.shared.currentRouter`
    /// (defined in `Shared/Protocols/Routable.swift`).
    func openPreferences() {
        router?.push(.profile(.preferences))
    }
}

#Preview {
    ProfileScreen()
}
