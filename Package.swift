// swift-tools-version: 6.3

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "PharosNav",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [
        .library(
            name: "PharosNav",
            targets: ["PharosNav"]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/swiftlang/swift-syntax.git",
            from: "601.0.0"
        )
    ],
    targets: [
        // Macro plugin — runs at compile time on the host (macOS)
        .macro(
            name: "PharosNavMacrosPlugin",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftDiagnostics", package: "swift-syntax")
            ],
            path: "Sources/PharosNavMacrosPlugin"
        ),
        // Public macro declarations — imported by app code
        .target(
            name: "PharosNavMacros",
            dependencies: ["PharosNavMacrosPlugin"],
            path: "Sources/PharosNavMacros"
        ),
        .target(
            name: "PharosNav",
            dependencies: ["PharosNavMacros"],
            path: "Sources",
            exclude: [
                "PharosNavMacrosPlugin",
                "PharosNavMacros"
            ],
            swiftSettings: [
                .defaultIsolation(MainActor.self)
            ]
        ),
        .testTarget(
            name: "PharosNavTests",
            dependencies: [
                "PharosNav"
            ]
        )
    ]
)
