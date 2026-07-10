import FormKit
import XCTest

final class FormKitTests: XCTestCase {
    func testRequiredRuleRejectsWhitespace() {
        XCTAssertEqual(ValidationRule<String>.required().validate("  "), "This field is required.")
    }

    func testMaximumLengthAllowsEmptyOptionalValueAndRejectsLongValue() {
        let rule = ValidationRule<String>.maximumLength(2)
        XCTAssertNil(rule.validate(""))
        XCTAssertEqual(rule.validate("abc"), "Use at most 2 characters.")
    }

    func testValidationReturnsMultipleFailuresInRuleOrder() {
        let validation = FieldValidation<String>([
            .required(message: "Required"),
            .init(validate: { $0.isEmpty ? "Cannot be empty" : nil }),
        ])
        XCTAssertEqual(validation.errors(for: ""), ["Required", "Cannot be empty"])
        XCTAssertEqual(validation.error(for: ""), "Required")
    }

    func testDecimalParserUsesProvidedLocaleAndRejectsInvalidInput() {
        let locale = Locale(identifier: "fr_FR")
        XCTAssertEqual(DecimalParser.parse("12,50", locale: locale), Decimal(string: "12.50"))
        XCTAssertNil(DecimalParser.parse("", locale: locale))
        XCTAssertNil(DecimalParser.parse("twelve", locale: locale))
    }

    @MainActor func testFormTracksSavesAndDiscardsChangesWithoutFocusState() {
        let state = FormState(values: ["name": "A", "age": ""])
        state.update("B", for: "name")
        XCTAssertTrue(state.isDirty)
        state.markSaved()
        XCTAssertFalse(state.isDirty)
        state.update("C", for: "name")
        state.discardChanges()
        XCTAssertEqual(state.values["name"], "B")
        XCTAssertFalse(state.isDirty)
    }

    @MainActor func testFormLevelValidationReturnsFirstFailureForEachField() {
        let state = FormState(values: ["name": " ", "nickname": "ok"])
        let errors = state.validationErrors(using: [
            "name": .init([.required(message: "Name required")]),
            "nickname": .init([.maximumLength(1, message: "Nickname too long")]),
        ])
        XCTAssertEqual(errors, ["name": "Name required", "nickname": "Nickname too long"])
    }
}
