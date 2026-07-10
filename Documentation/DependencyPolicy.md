# Dependency Policy

The initial package uses only Swift, SwiftUI, Foundation, SwiftData, UniformTypeIdentifiers, and OSLog. Before proposing a production dependency, document the unsolved Apple-API problem, maintenance/security cost, narrow interface, removal plan, and obtain explicit approval. Test-only utilities remain target-local. A third party must never become an accidental dependency of all modules.
