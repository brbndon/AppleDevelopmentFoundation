@testable import FormKit
import XCTest

private final class EvaluationCounter: @unchecked Sendable {
    var value = 0
}

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

    func testFirstErrorStopsEvaluatingLaterRules() {
        let counter = EvaluationCounter()
        let validation = FieldValidation<String>([
            .init(validate: { _ in "first" }),
            .init(validate: { _ in counter.value += 1; return "later" }),
        ])
        XCTAssertEqual(validation.error(for: "value"), "first")
        XCTAssertEqual(counter.value, 0)
    }

    func testDecimalParserUsesProvidedLocaleAndRejectsInvalidInput() {
        let locale = Locale(identifier: "fr_FR")
        XCTAssertEqual(DecimalParser.parse("12,50", locale: locale), Decimal(string: "12.50"))
        XCTAssertNil(DecimalParser.parse("", locale: locale))
        XCTAssertNil(DecimalParser.parse("twelve", locale: locale))
    }

    func testDecimalInputClassifiesEditingStatesWithoutOverwritingInvalidValues() {
        let locale = Locale(identifier: "fr_FR")
        XCTAssertEqual(DecimalInputLogic.classify("", locale: locale), .empty)
        XCTAssertEqual(DecimalInputLogic.classify("12,50", locale: locale), .valid(Decimal(string: "12.50")!))
        XCTAssertEqual(DecimalInputLogic.classify("12,", locale: locale), .invalid("12,"))
        XCTAssertEqual(DecimalInputLogic.classify("-", locale: locale), .invalid("-"))
        XCTAssertEqual(DecimalInputLogic.classify("not a number", locale: locale), .invalid("not a number"))
    }

    func testDecimalInputCommitsValidTextUsingTheCurrentLocale() {
        let locale = Locale(identifier: "en_US_POSIX")
        let committed = DecimalInputLogic.committedValueAndText("12.50", locale: locale)
        XCTAssertEqual(committed?.0, Decimal(string: "12.50"))
        XCTAssertEqual(committed?.1, "12.5")
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
