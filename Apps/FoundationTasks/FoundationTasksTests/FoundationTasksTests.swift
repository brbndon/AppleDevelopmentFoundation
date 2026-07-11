import Testing
@testable import FoundationTasks

struct FoundationTasksTests {
    @Test @MainActor func taskStartsIncompleteAndTogglesCompletion() {
        let task = TaskItem(title: "Prepare demo", notes: "Use local package modules.")

        #expect(task.isComplete == false)
        #expect(task.title == "Prepare demo")

        task.toggleCompletion()

        #expect(task.isComplete == true)
    }
}
