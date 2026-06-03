//
//  AdvancedDestination.swift
//  ExampleApp
//
//  Destinations used by the Advanced tab — two distinct scenarios:
//
//  Scenario A — **Sheet stacking** (two sheets on screen at once):
//   - `.firstSheetRoot`   → root of the outer sheet, presented from the tab
//   - `.firstSheetPushed` → pushed inside the outer sheet's nested stack
//   - `.stackedSheetRoot` → root of the second sheet, stacked on top
//
//  Scenario B — **Push → Modal → Push** (mixed navigation chain):
//   - `.chainPushed`        → pushed on the Advanced tab's stack
//   - `.chainModalRoot`     → root of a sheet, presented from `.chainPushed`
//   - `.chainModalPushed`   → pushed inside the modal's own nested stack
//

import PharosNav

enum AdvancedDestination: DestinationItem {
    // Scenario A — sheet stacking
    case firstSheetRoot
    case firstSheetPushed
    case stackedSheetRoot

    // Scenario B — push → modal → push
    case chainPushed
    case chainModalRoot
    case chainModalPushed
}
