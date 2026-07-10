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
}

private enum TaskSheet: Hashable {
    case newTask
}

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \TaskItem.createdAt, order: .reverse) private var tasks: [TaskItem]
    @State private var sheetRouter = NavigationRouter<TaskSheet>()

    var body: some View {
        TabView {
            TaskListView(
                title: "Tasks",
                emptyTitle: "No tasks yet",
                emptyMessage: "Add a task to start your focused list.",
                tasks: tasks.filter { !$0.isComplete },
                showAddButton: true,
                addTask: { sheetRouter.presentSheet(.newTask) }
            )
            .tabItem {
                Label("Tasks", systemImage: "checklist")
            }

            TaskListView(
                title: "Completed",
                emptyTitle: "No completed tasks",
                emptyMessage: "Completed tasks will appear here.",
                tasks: tasks.filter(\.isComplete),
                showAddButton: false,
                addTask: {}
            )
            .tabItem {
                Label("Completed", systemImage: "checkmark.circle")
            }
        }
        .sheet(isPresented: isPresentingNewTask) {
            TaskEditorView { title, notes in
                modelContext.insert(TaskItem(title: title, notes: notes))
                sheetRouter.dismissSheet()
            }
        }
    }

    private var isPresentingNewTask: Binding<Bool> {
        Binding(
            get: { sheetRouter.sheet == .newTask },
            set: { isPresented in
                if !isPresented {
                    sheetRouter.dismissSheet()
                }
            }
        )
    }
}

private struct TaskListView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var router = NavigationRouter<TaskRoute>()

    let title: LocalizedStringKey
    let emptyTitle: LocalizedStringKey
    let emptyMessage: LocalizedStringKey
    let tasks: [TaskItem]
    let showAddButton: Bool
    let addTask: () -> Void

    var body: some View {
        NavigationStack(path: $router.path) {
            Group {
                if tasks.isEmpty {
                    StateView(.empty(title: emptyTitle, message: emptyMessage))
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
            .navigationTitle(title)
            .toolbar {
                if showAddButton {
                    ToolbarItem(placement: .topBarTrailing) {
                        LiquidGlassIconButton(label: "Add task", systemImage: "plus", action: addTask)
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
                }
            }
        }
    }

    private func deleteTasks(at offsets: IndexSet) {
        for offset in offsets {
            modelContext.delete(tasks[offset])
        }
    }
}

private struct LiquidGlassIconButton: View {
    let label: LocalizedStringKey
    let systemImage: String
    let action: () -> Void

    var body: some View {
        if #available(iOS 26.0, *) {
            Button(action: action) {
                Image(systemName: systemImage)
                    .frame(minWidth: 44, minHeight: 44)
            }
            .buttonStyle(.glass)
            .accessibilityLabel(label)
        } else {
            IconOnlyButton(label, systemImage: systemImage, action: action)
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
                    LiquidGlassActionButton(title: "Add Task", action: save)
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

private struct LiquidGlassActionButton: View {
    let title: LocalizedStringKey
    let action: () -> Void

    var body: some View {
        if #available(iOS 26.0, *) {
            Button(title, action: action)
                .buttonStyle(.glass)
                .controlSize(.large)
        } else {
            FoundationButton(title, action: action)
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: TaskItem.self, inMemory: true)
}
