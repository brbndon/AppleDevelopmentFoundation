import OnboardingKit
import XCTest

final class OnboardingKitTests: XCTestCase {
    func testProgressionMovesForwardBackwardAndCompletes() {
        var flow = FlowProgression(steps: [.init(id: "one"), .init(id: "two")])
        XCTAssertEqual(flow.currentStep?.id, "one")
        XCTAssertNil(flow.advance())
        XCTAssertEqual(flow.currentStep?.id, "two")
        flow.goBack()
        XCTAssertEqual(flow.currentStep?.id, "one")
        XCTAssertNil(flow.advance())
        XCTAssertNil(flow.advance())
        XCTAssertTrue(flow.isComplete)
        XCTAssertNil(flow.currentStep)
        XCTAssertEqual(flow.progress, 1)
    }

    func testProgressionStopsForRequiredValidation() {
        var flow = FlowProgression(steps: [.init(id: "one", validate: { "Required" })])
        XCTAssertEqual(flow.advance(), "Required")
        XCTAssertEqual(flow.currentStep?.id, "one")
        XCTAssertFalse(flow.isComplete)
    }

    func testOptionalStepDoesNotBlockForValidationMessage() {
        var flow = FlowProgression(steps: [.init(id: "optional", isOptional: true, validate: { "Ignored" })])
        XCTAssertNil(flow.advance())
        XCTAssertTrue(flow.isComplete)
    }

    func testProgressionSkipsExcludedConditionalSteps() {
        let flow = FlowProgression(steps: [
            .init(id: "hidden", isIncluded: { false }),
            .init(id: "visible"),
        ])
        XCTAssertEqual(flow.steps.map(\.id), ["visible"])
        XCTAssertEqual(flow.currentStep?.id, "visible")
    }

    func testRestorationUsesKnownIncludedStepAndUnknownIdentifierFallsBackToStart() {
        let steps: [FlowStep<String>] = [.init(id: "one"), .init(id: "two")]
        XCTAssertEqual(FlowProgression(steps: steps, restoredStepID: "two").currentStep?.id, "two")
        XCTAssertEqual(FlowProgression(steps: steps, restoredStepID: "missing").currentStep?.id, "one")
    }

    func testCancellationStopsProgressionWithoutCompleting() {
        var flow = FlowProgression(steps: [.init(id: "one")])
        flow.cancel()
        XCTAssertTrue(flow.isCancelled)
        XCTAssertFalse(flow.isComplete)
        XCTAssertNil(flow.currentStep)
        XCTAssertNil(flow.advance())
    }
}
