//
//  FoundationTasksApp.swift
//  FoundationTasks
//
//  Created by brandon on 7/10/26.
//

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
            modelContainer = try PersistenceContainerFactory.make(schema: schema)
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(modelContainer)
    }
}
