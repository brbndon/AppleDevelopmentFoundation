//
//  ContentView.swift
//  FoundationTasks
//

import DesignSystem
import FormKit
import NavigationKit
import SwiftData
import SwiftUI

private enum TaskRoute: Hashable {
    case detail(UUID)
    case newTask
}

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \TaskItem.createdAt, order: .reverse) private var tasks: [TaskItem]
    @State private var router = NavigationRouter<TaskRoute>()

    var body: some View {
        NavigationStack(path: $router.path) {
            Group {
                if tasks.isEmpty {
                    StateView(.empty(
                        title: "No tasks yet",
                        message: "Add a task to start your focused list."
                    ))
                } else {
                    List {
                        ForEach(tasks) { task in
                            NavigationLink(value: TaskRoute.detail(task.id)) {
                                TaskRow(task: task)
                            }
                            .swipeActions {
                                Button(task.isComplete ? "Mark Incomplete" : "Mark Complete") {
                                    task.toggleCompletion()
                                }
                                .tint(task.isComplete ? FoundationTokens.ColorRole.warning : FoundationTokens.ColorRole.success)
                            }
                        }
                        .onDelete(perform: deleteTasks)
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("Tasks")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    IconOnlyButton("Add task", systemImage: "plus") {
                        router.presentSheet(.newTask)
                    }
                }
            }
            .navigationDestination(for: TaskRoute.self) { route in
                switch route {
                case .detail(let identifier):
                    if let task = tasks.first(where: { $0.id == identifier }) {
                        TaskDetailView(task: task)
                    } else {
                        StateView(.empty(title: "Task unavailable", message: "This task may have been deleted."))
                    }
                case .newTask:
                    EmptyView()
                }
            }
        }
        .sheet(isPresented: isPresentingNewTask) {
            TaskEditorView { title, notes in
                modelContext.insert(TaskItem(title: title, notes: notes))
                router.dismissSheet()
            }
        }
    }

    private var isPresentingNewTask: Binding<Bool> {
        Binding(
            get: { router.sheet == .newTask },
            set: { isPresented in
                if !isPresented {
                    router.dismissSheet()
                }
            }
        )
    }

    private func deleteTasks(at offsets: IndexSet) {
        for offset in offsets {
            modelContext.delete(tasks[offset])
        }
    }
}

private struct TaskRow: View {
    let task: TaskItem

    var body: some View {
        HStack(spacing: FoundationTokens.Spacing.standard) {
            Image(systemName: task.isComplete ? "checkmark.circle.fill" : "circle")
                .foregroundStyle(task.isComplete ? FoundationTokens.ColorRole.success : .secondary)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 2) {
                Text(task.title)
                    .strikethrough(task.isComplete)
                if !task.notes.isEmpty {
                    Text(task.notes)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(task.isComplete ? "Completed task: \(task.title)" : "Task: \(task.title)")
    }
}

private struct TaskDetailView: View {
    @Bindable var task: TaskItem

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: FoundationTokens.Spacing.roomy) {
                FoundationCard {
                    VStack(alignment: .leading, spacing: FoundationTokens.Spacing.standard) {
                        Text(task.title)
                            .font(.title2.bold())
                        if !task.notes.isEmpty {
                            Text(task.notes)
                        }
                        Toggle("Completed", isOn: $task.isComplete)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Task")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct TaskEditorView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var title = ""
    @State private var notes = ""
    @State private var hasAttemptedSave = false

    private let titleValidation = FieldValidation<String>([
        .required(message: "Enter a task title."),
        .maximumLength(80),
    ])

    let onSave: (String, String) -> Void

    var body: some View {
        NavigationStack {
            Form {
                Section("Task") {
                    ValidatedTextField("Task title", text: $title, validation: titleValidation)
                        .textInputAutocapitalization(.sentences)
                    TextField("Notes", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                }

                if hasAttemptedSave, let error = titleValidation.error(for: title) {
                    FormErrorSummary(messages: [error])
                }

                Section {
                    FoundationButton("Add Task") {
                        save()
                    }
                }
            }
            .navigationTitle("New Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }

    private func save() {
        hasAttemptedSave = true
        guard titleValidation.error(for: title) == nil else { return }
        onSave(title.trimmingCharacters(in: .whitespacesAndNewlines), notes.trimmingCharacters(in: .whitespacesAndNewlines))
    }
}

#Preview {
    ContentView()
        .modelContainer(for: TaskItem.self, inMemory: true)
}
