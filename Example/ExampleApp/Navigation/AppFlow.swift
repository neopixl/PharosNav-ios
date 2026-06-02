//
//  AppFlow.swift
//  ExampleApp
//
//  A "flow" is any independent navigation context — a tab, an onboarding stack,
//  or a modal flow presented over the tab bar. Every flow has its own `Router`,
//  lazily created by `AppRouterManager`.
//
//  In this example:
//  - `.home`        → a tab
//  - `.profile`     → a tab
//  - `.advanced`    → a tab (sheet-stacking demo)
//  - `.settings`    → a **standalone** flow, presented modally over the tabs
//                     (intentionally excluded from the `flows:` array).
//  - `.nestedSheet` → a **standalone auxiliary** flow used ONLY to provide a
//                     second presentation slot for the sheet-stacking demo
//                     (also excluded from the `flows:` array).
//
//  Rule of thumb: **1 Router = 1 presentation slot**. To stack a sheet over
//  another sheet you need *another* router → another flow.
//

import PharosNav

enum AppFlow: AppFlowProtocol {
    case home
    case profile
    case advanced
    case settings
    case nestedSheet
}
