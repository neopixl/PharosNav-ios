//
//  RecursiveDestinationMacro.swift
//  PharosNavMacrosPlugin
//

import SwiftSyntax
import SwiftSyntaxMacros
import SwiftDiagnostics
import SwiftCompilerPlugin

// MARK: - Diagnostics

private enum RecursiveDestinationDiagnostic: DiagnosticMessage {
    case notAnEnum
    case caseHasNoAssociatedValue(caseName: String)
    case caseHasTooManyAssociatedValues(caseName: String)

    var message: String {
        switch self {
        case .notAnEnum:
            return "@RecursiveDestination can only be applied to an enum"
        case .caseHasNoAssociatedValue(let name):
            return "Enum case '\(name)' must have exactly one associated value conforming to Hashable"
        case .caseHasTooManyAssociatedValues(let name):
            return "Enum case '\(name)' must have exactly one associated value — multiple associated values are not supported"
        }
    }

    var diagnosticID: MessageID {
        MessageID(domain: "PharosNavMacros", id: "\(self)")
    }

    var severity: DiagnosticSeverity { .error }
}

// MARK: - Macro implementation

/// Synthesises `RecursiveDestination` conformance for an enum whose cases each
/// wrap exactly one `Hashable` associated value.
public struct RecursiveDestinationMacro: ExtensionMacro {

    public static func expansion(
        of node: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        providingExtensionsOf type: some TypeSyntaxProtocol,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [ExtensionDeclSyntax] {

        guard let enumDecl = declaration.as(EnumDeclSyntax.self) else {
            context.diagnose(
                Diagnostic(node: declaration, message: RecursiveDestinationDiagnostic.notAnEnum)
            )
            return []
        }

        // Collect all enum cases
        let caseElements: [EnumCaseElementSyntax] = enumDecl.memberBlock.members
            .compactMap { $0.decl.as(EnumCaseDeclSyntax.self) }
            .flatMap { $0.elements }

        // Validate each case has exactly one associated value
        for element in caseElements {
            let params = element.parameterClause?.parameters ?? []
            if params.isEmpty {
                context.diagnose(
                    Diagnostic(
                        node: element,
                        message: RecursiveDestinationDiagnostic.caseHasNoAssociatedValue(caseName: element.name.text)
                    )
                )
                return []
            }
            if params.count > 1 {
                context.diagnose(
                    Diagnostic(
                        node: element,
                        message: RecursiveDestinationDiagnostic.caseHasTooManyAssociatedValues(caseName: element.name.text)
                    )
                )
                return []
            }
        }

        // Build switch cases: `case .foo(let value): return value`
        let switchCases = caseElements.map { element -> String in
            let name = element.name.text
            return "        case .\(name)(let value): return value"
        }.joined(separator: "\n")

        let typeName = type.trimmedDescription

        // Include `: RecursiveDestination` only when the compiler requests the conformance
        // (i.e. protocols is non-empty). When protocols is empty the compiler already
        // knows about the conformance from a prior expansion pass and adding it again
        // would cause a "redundant conformance" error.
        let conformanceClause = protocols.isEmpty ? "" : ": RecursiveDestination"

        let extensionSource = """
        extension \(typeName)\(conformanceClause) {
            public var unwrapped: AnyHashable {
                switch self {
        \(switchCases)
                }
            }
        }
        """

        let declSyntax: DeclSyntax = "\(raw: extensionSource)"
        guard let extensionDecl = declSyntax.as(ExtensionDeclSyntax.self) else {
            return []
        }
        return [extensionDecl]
    }
}

// MARK: - Plugin entry point

@main
struct PharosNavMacrosPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        RecursiveDestinationMacro.self
    ]
}
