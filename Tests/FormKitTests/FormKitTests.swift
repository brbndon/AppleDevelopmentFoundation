import FormKit
import XCTest

final class FormKitTests: XCTestCase {
    func testRequiredRuleRejectsWhitespace() { XCTAssertEqual(ValidationRule<String>.required().validate("  "), "This field is required.") }
    func testFormTracksAndDiscardsChanges() async { let state = await FormState(values: ["name": "A"]); await state.update("B", for: "name"); let changed = await state.isDirty; XCTAssertTrue(changed); await state.discardChanges(); let restored = await state.isDirty; XCTAssertFalse(restored) }
}
