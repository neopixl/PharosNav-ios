# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
# Build package
swift build

# Run tests
swift test

# Run a single test
swift test --filter PharosNavTests/<TestName>

# Type-check all Swift sources against iOS 17.6 simulator
.claude/scripts/typecheck.sh

# Build Example app on simulator
.claude/scripts/build-simulator.sh
```

The Example app is in `Example/ExampleApp.xcodeproj` and demonstrates a full integration.

## Architecture

PharosNav is a Swift 6.2 SPM library (iOS 17+) providing a type-safe, router-based navigation layer over SwiftUI `NavigationStack`. The entire package defaults to `@MainActor` isolation (set in `Package.swift`).

### Core types and their responsibilities

| Type | Role |
|------|------|
| `Router<AppDestination>` | `@Observable` class. Owns `navigationPath`, `presentedSheet`, `presentedFullScreen`, and `selectedRoute`. Single source of truth for one navigation stack. |
| `RouterManager<Flow, AppDestination>` | `@MainActor @Observable` open class. Maps each `Flow` value to a `Router`. Tracks `selectedFlow` and `previousFlow`. Apps subclass this as a singleton. |
| `NavigationRegistry` | Singleton resolver. Maps `DestinationItem` types → `AnyView` closures registered at app startup. Used by `NavigationStackView` inside `navigationDestination`. |
| `NavigationStackView` | Root view for a flow. Wraps `NavigationStack`, wires up `sheet`/`fullScreenCover` from `Router` state, and registers/unregisters with `RouterManager` in `onAppear`/`onDisappear`. |
| `NavigationTabView` | Thin `TabView` wrapper bound to `routerManager.selectedFlow`. |

### Protocols

- **`DestinationItem`** — feature-level destination enum (e.g., `PersonDestination`). Registered in `NavigationRegistry`.
- **`AppDestinationProtocol: Identifiable, Hashable`** — app-wide destination wrapper (e.g., `AppDestination`). Used as the generic parameter for `Router` and `RouterManager`.
- **`AppFlowProtocol: Hashable`** — flow/tab enum (e.g., `AppFlow`). Keys the router registry inside `RouterManager`.
- **`RecursiveDestination`** — adopted by `AppDestination` to let `NavigationRegistry.resolve` unwrap nested destinations via `var unwrapped: AnyHashable`.

### Navigation flow (data path)

1. `NavigationRegistry.shared.register(SomeDestination.self) { ... }` at app launch.
2. A view or ViewModel calls `router.push(dst)`, `router.present(route:, dst)`, or `router.dismiss()`.
3. `NavigationStackView` reacts to `@Bindable router` state changes and renders the correct presentation style.
4. `RouterManager.currentRouter` gives any ViewModel access to the active router (typically via `AppRouterManager.shared.currentRouter`).

### `isTabPage` flag

`NavigationStackView(isTabPage:)` controls lifecycle cleanup:
- `true` (default) — persistent tab; router stays registered when the view disappears.
- `false` — temporary flow (modal, onboarding); on disappear the router is unregistered and the previous flow is restored.

### Sheet styles (`Route` / `SheetStyle`)

`.push`, `.sheet(style: .medium)`, `.sheet(style: .large)`, `.sheet(style: .canFullScreen)`, `.sheet(style: .fitContent(bgColor:))`, `.fullScreenCover`.

The `FittedPresentationDetentModifier` in `Utilities/ViewModifiers/` handles dynamic height for `.fitContent`.
