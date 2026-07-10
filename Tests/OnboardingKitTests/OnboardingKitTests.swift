import OnboardingKit
import XCTest

final class OnboardingKitTests: XCTestCase {
    func testProgressionStopsForRequiredValidation() { var flow = FlowProgression(steps: [.init(id: "one", validate: { "Required" })]); XCTAssertEqual(flow.advance(), "Required"); XCTAssertEqual(flow.currentStep?.id, "one") }
    func testProgressionSkipsExcludedSteps() { let flow = FlowProgression(steps: [.init(id: "hidden", isIncluded: { false }), .init(id: "visible")]); XCTAssertEqual(flow.currentStep?.id, "visible") }
}
