# PharosNav

Type-safe, router-based SwiftUI navigation with modular destination registration.

![Swift](https://img.shields.io/badge/Swift-6.2-orange?logo=swift)
![iOS](https://img.shields.io/badge/iOS-17%2B-blue)
![SPM](https://img.shields.io/badge/SPM-compatible-brightgreen)

---

## Table of contents

- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
- [Quick start](#quick-start)
  - [1. Define your feature destinations](#1-define-your-feature-destinations)
  - [2. Define your app flows (tabs)](#2-define-your-app-flows-tabs)
  - [3. Define the app destination wrapper](#3-define-the-app-destination-wrapper)
  - [4. Register your destinations](#4-register-your-destinations)
  - [5. Create the app router manager](#5-create-the-app-router-manager)
  - [6. Build the root view](#6-build-the-root-view)
  - [7. Navigate from anywhere](#7-navigate-from-anywhere)
- [API guide](#api-guide)
- [Modularity](#modularity)
- [Advanced](#advanced)
- [Example app](#example-app)
- [Credits](#credits)

---

## Features

- **Multiple presentation styles** — `push`, `sheet` (with custom detents), `fullScreenCover`.
- **Multi-flow / tab navigation** — one independent navigation stack per tab, coordinated by a single `RouterManager`.
- **Modular destination registration** — each feature registers its own destinations through `NavigationRegistry`. No central switch statement, no cross-feature coupling.
- **Compile-time-safe navigation targets** — `NavigationTarget<D>` makes invalid combinations *inexpressible*.
- **Contextual dismiss button** — `NavigationDismissButton` automatically pops the stack or dismisses the presentation depending on where it sits.
- **`@RecursiveDestination` Swift macro** — synthesises destination unwrapping. No more handwritten `switch unwrapped` boilerplate.
- **Lazy router allocation** — `RouterManager` creates a `Router` per flow on demand. No manual instantiation in `ContentView`.

---

## Requirements

| | |
|---|---|
| Swift | 6.2 |
| iOS | 17.0+ |
| Xcode | 16+ |

The package defaults to `@MainActor` isolation (set in `Package.swift`).

---

## Installation

### Via Xcode

1. **File** → **Add Package Dependencies…**
2. Enter the repository URL:
   ```
   https://git.smile.fr/neopixl/r-and-d/PharosNav.git
   ```
3. Pick a version (≥ 2.0.0) or a branch.
4. Add the `PharosNav` library to your app target.

### Via `Package.swift`

```swift
dependencies: [
    .package(
        url: "https://git.smile.fr/neopixl/r-and-d/PharosNav.git",
        from: "2.0.0"
    )
],
targets: [
    .target(
        name: "MyApp",
        dependencies: ["PharosNav"]
    )
]
```

Then in your code:

```swift
import PharosNav
```

A single import gives you the macro (`@RecursiveDestination`), the protocols, the router, and all the components.

---

## Quick start

The full pattern in **7 steps**. Each step is a small file you write once per feature or once per app.

### 1. Define your feature destinations

Each feature declares its own destination enum conforming to `DestinationItem`:

```swift
// Features/Persons/PersonDestination.swift
import PharosNav

enum PersonDestination: DestinationItem {
    case home
    case details
    case add(name: String)
}
```

### 2. Define your app flows

A *flow* is any independent navigation context — a tab, an onboarding stack, a modal flow presented on top of the tab bar, etc. Declare them all in a single enum:

```swift
// Navigation/AppFlow.swift
import PharosNav

enum AppFlow: AppFlowProtocol, CaseIterable {
    case cat       // tab
    case fruit     // tab
    case person    // standalone flow — presented modally, not a tab
}
```

> `CaseIterable` is optional. It is only needed if you intend to use the shortcut `NavigationTabView(routerManager:tab:)` init that turns *every* flow into a tab. When some flows are not tabs (as in the example above), use the explicit `flows:` init in step 6.

### 3. Define the app destination wrapper

A single enum that aggregates every feature's destinations. The `@RecursiveDestination` macro synthesises the conformance to `RecursiveDestination` for you — no manual `switch unwrapped` to write.

```swift
// Navigation/AppDestination.swift
import PharosNav

@RecursiveDestination
enum AppDestination: AppDestinationProtocol {
    case cat(CatDestination)
    case fruit(FruitDestination)
    case person(PersonDestination)
}
```

### 4. Register your destinations

Each feature registers its own destinations in its own extension of `NavigationRegistry` — there is no central switch:

```swift
// Features/Persons/Navigation/NavigationRegistry+PersonDestination.swift
import SwiftUI
import PharosNav

extension NavigationRegistry {
    func registerPersonDestination() {
        self.register(PersonDestination.self) { destination in
            switch destination {
            case .home:           PersonScreen()
            case .details:        PersonDetailsScreen()
            case .add(let name):  AddPersonScreen(name: name)
            }
        }
    }
}
```

Then call every registration once at app launch:

```swift
// App.swift
import SwiftUI
import PharosNav

@main
struct MyApp: App {
    init() {
        NavigationRegistry.shared.registerPersonDestination()
        NavigationRegistry.shared.registerCatDestination()
        NavigationRegistry.shared.registerFruitDestination()
    }

    var body: some Scene {
        WindowGroup { ContentView() }
    }
}
```

> **No `AnyView`** at the call-site. The SDK wraps your view once internally.

### 5. Create the app router manager

A single subclass of `RouterManager`, kept as a singleton, drives the whole app:

```swift
// Navigation/AppRouterManager.swift
import PharosNav

@MainActor
final class AppRouterManager: RouterManager<AppFlow, AppDestination> {
    static let shared = AppRouterManager()

    init() {
        super.init(selectedFlow: .cat)
    }
}
```

You do **not** need to manually create `Router` instances — `RouterManager` allocates one per flow on demand.

### 6. Build the root view

Pass `flows:` to declare exactly **which** flows are tabs. The SDK wraps each tab's content in a `NavigationStackView` automatically. Other flows (like `.person` below) remain routable for modal/programmatic navigation but never appear in the tab bar:

```swift
// ContentView.swift
import SwiftUI
import PharosNav

struct ContentView: View {
    @State private var routerManager = AppRouterManager.shared

    var body: some View {
        NavigationTabView(
            routerManager: routerManager,
            flows: [.cat, .fruit]   // .person is intentionally excluded
        ) { flow in
            switch flow {
            case .cat:
                NavigationTabItem {
                    Label("Cats", systemImage: "cat.fill")
                } content: {
                    CatsListScreen()
                }
            case .fruit:
                NavigationTabItem {
                    Label("Fruits", systemImage: "apple.logo")
                } content: {
                    FruitsListScreen()
                }
            case .person:
                nil   // `.person` is a standalone flow, not a tab
            }
        }
    }
}
```

Then, from one of the tabs, present the standalone flow modally:

```swift
// CatsListScreen.swift
GenericNavigationButton(target: .fullScreenCover(AppDestination.person(.home))) {
    Text("Open the Person flow")
}
```

And inside `PersonScreen`, opt out of the tab lifecycle with `isTabPage: false` so the router is unregistered and the previous flow is restored when the user dismisses it:

```swift
struct PersonScreen: View {
    private let routerManager = AppRouterManager.shared

    var body: some View {
        NavigationStackView(
            routerManager: routerManager,
            flow: .person,
            isTabPage: false
        ) {
            // Person flow root content
        }
    }
}
```

> If every flow in your enum is a tab, use the shortcut `NavigationTabView(routerManager:tab:)` (requires `Tab: CaseIterable`).
>
> If you need full manual control, the legacy `NavigationTabView(selection:content:)` init remains available.

### 7. Navigate from anywhere

Use `GenericNavigationButton` with a `NavigationTarget` to push, present, or full-screen any destination:

```swift
GenericNavigationButton(target: .push(AppDestination.person(.details))) {
    Text("Open person details")
}

GenericNavigationButton(target: .sheet(.medium, AppDestination.person(.home))) {
    Text("Open as medium sheet")
}

GenericNavigationButton(target: .fullScreenCover(AppDestination.person(.home))) {
    Text("Open in full screen")
}
```

To skip the `AppDestination.` prefix at the call-site, define a thin wrapper that concretely binds the destination type:

```swift
struct AppNavigationButton<Label: View>: View {
    let target: NavigationTarget<AppDestination>
    @ViewBuilder let label: () -> Label

    var body: some View {
        GenericNavigationButton(target: target, label: label)
    }
}

// Usage — note the leading-dot syntax works here:
AppNavigationButton(target: .push(.person(.details))) {
    Text("Open person details")
}
```

To close the current screen, drop a `NavigationDismissButton` anywhere — it picks the right behaviour automatically:

```swift
NavigationDismissButton {
    Label("Close", systemImage: "xmark")
}
```

By default (`behavior: .auto`) it pops the navigation stack when the view is pushed, and dismisses the sheet / fullScreenCover when it's the root of a presentation.

---

## API guide

### `NavigationTarget<D>`

A type-safe enum encoding every valid navigation action. Use it with `GenericNavigationButton(target:)` — invalid combinations are caught at compile time.

| Case | Description |
|---|---|
| `.push(D)` | Push a single destination onto the navigation stack. |
| `.pushMany([D])` | Push multiple destinations sequentially. |
| `.sheet(SheetStyle, D, onDismiss: (() -> Void)? = nil)` | Present as a sheet. |
| `.fullScreenCover(D, onDismiss: (() -> Void)? = nil)` | Present as a full-screen cover. |

### `SheetStyle`

| Case | Behaviour |
|---|---|
| `.medium` | Medium detent only. |
| `.large` | Large detent only (default sheet height). |
| `.canFullScreen` | Medium + large detents (user can pull up). |
| `.fitContent(bgColor: Color? = nil)` | Detent matches the intrinsic content height. Optional sheet background colour. |

### `DismissBehavior`

| Case | Behaviour |
|---|---|
| `.auto` *(default)* | Pop the stack if pushed, dismiss the presentation otherwise. |
| `.pop` | Always pop one level. No-op if the stack is empty. |
| `.popToRoot` | Pop to the root of the current stack. |
| `.dismiss` | Always dismiss the current presentation (sheet / fullScreenCover). |

### `Router<Destination>` public methods

| Method / property | Description |
|---|---|
| `navigationPath: [Destination]` | The current push stack. |
| `presentation: RouterPresentation<Destination>?` | The active modal presentation (single source of truth). |
| `push(_:)` | Push a single destination. |
| `push([D])` | Push multiple destinations. |
| `pop()` | Pop one level. |
| `popToRoot()` | Clear the stack and dismiss any presentation. |
| `present(route:_:_:)` | Present a destination as sheet or full screen cover. |
| `dismiss()` | Dismiss the active presentation (or pop if no presentation). |
| `isPagePresented` / `isSheetPresented` / `isFullScreenPresented` | State predicates. |

### `RouterManager<Flow, Destination>` public surface

| Member | Description |
|---|---|
| `selectedFlow: Flow` | The active tab / flow. |
| `currentRouter: Router<Destination>?` | The router of the active flow. |
| `getRouter(for:)` | Returns the router for a given flow — **lazily creates it** if it doesn't exist yet. |
| `navigateToFlow(_:then:)` | Switch flow, then run a closure (e.g., to push a destination inside the target flow). |
| `setCurrentFlow(_:)` / `setPreviousFlow()` | Low-level flow transitions for advanced integrations. |

---

## Modularity

Each feature module owns its destinations end-to-end. A feature exposes a `register…Destination()` method on `NavigationRegistry`, and the host app only needs to know its name:

```swift
// In the Persons module
extension NavigationRegistry {
    public func registerPersonDestination() {
        self.register(PersonDestination.self) { destination in
            switch destination {
            case .home:    PersonScreen()
            case .details: PersonDetailsScreen()
            }
        }
    }
}

// In the host app
NavigationRegistry.shared.registerPersonDestination()
```

The registry uses `ObjectIdentifier` keys, so renames or module-path changes will not silently break lookups. In debug builds, an unresolved destination triggers `assertionFailure` with a clear message; in release builds it logs through `os.Logger` and falls back to a visible diagnostic view.

---

## Advanced

### `isTabPage` — lifecycle cleanup

`NavigationStackView(isTabPage:)` controls how the router cleans up when the view disappears:

- `true` *(default)* — persistent tab; the router stays registered when the tab is left.
- `false` — temporary flow (modal, onboarding, login). On disappear the router is unregistered and the previous flow is restored. Use this whenever you present a complete secondary flow on top of the main tab bar.

### 1 Router = 1 presentation slot — sheet stacking rules

Each `NavigationStackView` owns exactly one presentation slot (a sheet or a fullScreenCover at a time). There is intentionally no internal stack of presentations inside a single router.

**Stacking a sheet on top of another sheet** is achievable by nesting a `NavigationStackView(isTabPage: false)` inside the first sheet's content. SwiftUI then renders the outer `NavigationStack`'s sheet modifier and the inner one independently — stacking them naturally.

```swift
// ✅ Sheet-over-sheet: PersonScreen wraps its content in a NavigationStackView.
// The environment `Router` injected to PersonDetailsScreen is the person router.
// Calling router.present(...) from PersonDetailsScreen triggers the inner stack's
// sheet modifier — SwiftUI stacks a new sheet on top without disturbing the outer one.
struct PersonScreen: View {
    var body: some View {
        NavigationStackView(
            routerManager: AppRouterManager.shared,
            flow: .person,
            isTabPage: false    // <-- critical: non-tab flow
        ) {
            PersonDetailsScreen()
        }
    }
}

struct PersonDetailsScreen: View {
    @Environment(Router<AppDestination>.self) private var router

    var body: some View {
        Button("Open settings") {
            // Uses the person router → stacks a new sheet on top of the person sheet
            router.present(route: .sheet(style: .large), .person(.settings))
        }
    }
}
```

**Override (replace) the current sheet** — if the content of the sheet does *not* wrap itself in a `NavigationStackView`, the `@Environment` router is the parent's router. Calling `present` on it replaces the current sheet rather than stacking a new one.

> **Key rule:** `isTabPage: false` prevents the non-tab flow from writing to `selectedFlow`, so the `TabView` binding (and the host sheet) are never disturbed when the inner `NavigationStackView` appears or disappears.

### Accessing the current router from non-View code

`Routable` is a tiny protocol you adopt on **any** type that needs to trigger navigation — it is intentionally architecture-agnostic (works for MVVM ViewModels, TCA reducers, MVI intents, coordinators, plain services, …):

```swift
import PharosNav

protocol Routable {}

extension Routable {
    @MainActor
    var router: Router<AppDestination>? {
        AppRouterManager.shared.currentRouter
    }
}
```

Adopt it wherever you need to navigate:

```swift
extension HomeScreen.ViewModel: Routable { /* … */ }   // MVVM

struct HomeReducer: Routable { /* … */ }                // TCA
```

Then call `router?.push(...)`, `router?.present(...)`, etc. from anywhere in the conformer. `currentRouter` follows `activeFlow`, so it returns the correct router even from inside a modal flow presented over the tab bar.

### Pitfall — never declare `private let router: Router = .init()` in a View

Always let the `RouterManager` own the `Router` lifetime. Use the convenience init:

```swift
// ✅ Correct — the manager owns the Router, it survives every body rebuild.
struct PersonScreen: View {
    private let routerManager = AppRouterManager.shared

    var body: some View {
        NavigationStackView(
            routerManager: routerManager,
            flow: .person,
            isTabPage: false
        ) {
            // …
        }
    }
}
```

Do **not** write this:

```swift
// ❌ Wrong — a fresh Router is created on every View rebuild.
struct PersonScreen: View {
    private let router: Router<AppDestination> = .init()
    private let routerManager = AppRouterManager.shared

    var body: some View {
        NavigationStackView(
            router: router,
            routerManager: routerManager,
            flow: .person,
            isTabPage: false
        ) { /* … */ }
    }
}
```

**Why it breaks** — SwiftUI may rebuild the `View` struct on any parent re-render. With `private let router = Router()`, a new `Router` instance is allocated each time. `RouterManager.register(_:for:)` keeps the **first** instance and ignores subsequent ones. As a result:

| Reader | Reads… |
|---|---|
| `RouterManager.currentRouter` (used by `Routable.router`) | the **original** registered Router |
| `NavigationStackView` bindings + `.environment(router)` | the **new** local Router |

`Routable`-driven calls like `router?.present(...)` write to a Router nobody observes → nothing happens on screen. In `DEBUG` builds, `RouterManager.register` raises an `assertionFailure` when it detects this split-brain.

The explicit-router init exists for advanced cases (unit tests, custom containers). For normal feature code, always use the convenience init.

### `DismissibleRouter` — building custom dismiss components

If you build your own dismiss control, read the router from the environment instead of subscribing to a typed router:

```swift
@Environment(\.dismissibleRouter) private var router

Button("Back") {
    router?.pop()
}
```

`Router<D>` conforms to `DismissibleRouter` automatically, and `NavigationStackView` injects it into the environment alongside the typed router.

### `AppDestinationProtocol.id`

The default `id` is derived from `hashValue`. Two cases with the same associated values share the same `id` — which is the desired behaviour for SwiftUI's `.sheet(item:)` and `ForEach`. Override `id` only when you need instance identity (rare).

---

## Example app

A fully working sample app is included in `Example/ExampleApp.xcodeproj`. It demonstrates:

- Tab navigation with three flows (`cat`, `fruit`, `person`).
- Push, medium / large / fit-content sheets, and full-screen covers.
- A secondary flow presented on top of the tab bar (`isTabPage: false`).
- Auto-detecting dismiss buttons inside both pushed and presented views.
- Cross-flow navigation via `RouterManager.navigateToFlow(_:then:)`.

Open it from the package root:

```bash
open Example/ExampleApp.xcodeproj
```

---

## Credits

Handmade by **Neopixl**.
