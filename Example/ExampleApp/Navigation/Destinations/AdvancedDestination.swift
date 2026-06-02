//
//  AdvancedDestination.swift
//  ExampleApp
//
//  Destinations used by the **sheet-stacking** demo flow.
//
//  - `.firstSheetRoot`   → root of the first (outer) sheet, presented from the
//                           Advanced tab.
//  - `.firstSheetPushed` → pushed inside the first sheet's *nested* stack.
//  - `.stackedSheetRoot` → root of the second sheet, presented from
//                           `.firstSheetPushed`, **stacked on top** of the
//                           first sheet (made possible by the nested router).
//

import PharosNav

enum AdvancedDestination: DestinationItem {
    case firstSheetRoot
    case firstSheetPushed
    case stackedSheetRoot
}
