//
//  TaskItem.swift
//  FoundationTasks
//

import Foundation
import SwiftData

@Model
final class TaskItem {
    var id: UUID
    var title: String
    var notes: String
    var isComplete: Bool
    var createdAt: Date

    init(
        id: UUID = UUID(),
        title: String,
        notes: String = "",
        isComplete: Bool = false,
        createdAt: Date = .now
    ) {
        self.id = id
        self.title = title
        self.notes = notes
        self.isComplete = isComplete
        self.createdAt = createdAt
    }

    func toggleCompletion() {
        isComplete.toggle()
    }
}
