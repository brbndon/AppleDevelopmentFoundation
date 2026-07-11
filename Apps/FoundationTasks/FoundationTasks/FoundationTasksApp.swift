import SwiftData
import SwiftUI

import PersistenceKit

@main
struct FoundationTasksApp: App {
    private let modelContainer: ModelContainer

    init() {
        let schema = Schema([
            TaskItem.self,
        ])

        do {
            modelContainer = try PersistenceContainerFactory.make(
                schema: schema,
                inMemory: ProcessInfo.processInfo.arguments.contains("-inMemory")
            )
        } catch {
            fatalError("Could not create the task store (\(String(describing: type(of: error)))).")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(modelContainer)
    }
}
