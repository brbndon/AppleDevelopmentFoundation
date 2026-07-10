# Module Boundaries

The definitive graph is in `Package.swift`; README renders the same dependency direction. Products must not import a higher-level product, TestingSupport must not be exposed as a library product, and examples must not contain reusable implementation.

Add a type to an existing module when its responsibility matches the module table in README and it has no new dependency direction. Create a module only for a separately importable concern with a non-empty implementation, test target, public API documentation, example usage, and an updated graph. Do not create `Core`, `Utilities`, or a module that primarily re-exports others.
