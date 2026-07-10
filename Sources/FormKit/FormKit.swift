import DesignSystem
import Observation
import SwiftUI

/// A reusable validation rule that returns a user-presentable reason when it fails.
public struct ValidationRule<Value>: Sendable {
    /// Evaluates a value and returns a user-presentable failure message, if any.
    public let validate: @Sendable (Value) -> String?

    /// Creates a rule from a Sendable validation closure.
    public init(validate: @escaping @Sendable (Value) -> String?) { self.validate = validate }

    /// Requires a non-whitespace string.
    public static func required(message: String = "This field is required.") -> Self where Value == String {
        .init { $0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? message : nil }
    }

    /// Limits a string to `count` characters.
    public static func maximumLength(_ count: Int, message: String? = nil) -> Self where Value == String {
        .init { $0.count > count ? (message ?? "Use at most \(count) characters.") : nil }
    }
}

/// An ordered collection of validation rules for one value.
public struct FieldValidation<Value>: Sendable {
    /// The validation rules evaluated in order.
    public let rules: [ValidationRule<Value>]

    /// Creates an ordered validation collection.
    public init(_ rules: [ValidationRule<Value>]) { self.rules = rules }

    /// Returns every validation failure in rule order.
    public func errors(for value: Value) -> [String] { rules.compactMap { $0.validate(value) } }

    /// Returns the first validation failure, if any.
    public func error(for value: Value) -> String? { errors(for: value).first }
}

/// Locale-aware decimal parsing used by ``DecimalInput``.
public enum DecimalParser {
    /// Parses a decimal string for `locale`, returning `nil` for an empty or invalid value.
    public static func parse(_ text: String, locale: Locale = .current) -> Decimal? {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }
        return Decimal(string: trimmed, locale: locale)
    }

    /// Formats a decimal for display using `locale`.
    public static func format(_ value: Decimal, locale: Locale = .current) -> String {
        value.formatted(.number.locale(locale))
    }
}

/// A text field that displays binding-driven validation failures.
public struct ValidatedTextField: View {
    private let title: LocalizedStringKey
    @Binding private var text: String
    private let validation: FieldValidation<String>
    @FocusState private var focused: Bool

    /// Creates a text field whose visible error derives solely from the supplied binding and validation.
    public init(
        _ title: LocalizedStringKey,
        text: Binding<String>,
        validation: FieldValidation<String> = .init([])
    ) {
        self.title = title
        _text = text
        self.validation = validation
    }

    /// The text field and its accessible validation message.
    public var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            TextField(title, text: $text)
                .textFieldStyle(.roundedBorder)
                .focused($focused)
            if let error = validation.error(for: text), !text.isEmpty {
                Label(error, systemImage: "exclamationmark.circle.fill")
                    .font(.footnote)
                    .foregroundStyle(FoundationTokens.ColorRole.danger)
                    .accessibilityElement(children: .combine)
            }
        }
    }
}

/// A locale-aware decimal input with an optional decimal binding.
public struct DecimalInput: View {
    private let title: LocalizedStringKey
    @Binding private var value: Decimal?
    @State private var text = ""
    private let locale: Locale

    /// Creates a locale-aware decimal input. Currency formatting is application-owned.
    public init(_ title: LocalizedStringKey, value: Binding<Decimal?>, locale: Locale = .current) {
        self.title = title
        _value = value
        self.locale = locale
    }

    /// The decimal text field.
    public var body: some View {
        TextField(title, text: $text)
            .textFieldStyle(.roundedBorder)
            .onChange(of: text) { _, newText in
                value = DecimalParser.parse(newText, locale: locale)
            }
            .onAppear {
                if let value { text = DecimalParser.format(value, locale: locale) }
            }
            .accessibilityLabel(title)
    }
}

/// Main-actor-owned form values and dirty-state tracking.
@MainActor @Observable public final class FormState {
    /// The values at the last save or initialization point.
    public private(set) var initialValues: [String: String]

    /// The current field values.
    public private(set) var values: [String: String]

    /// Creates state initialized with field values.
    public init(values: [String: String] = [:]) {
        initialValues = values
        self.values = values
    }

    /// Whether any current value differs from the last saved values.
    public var isDirty: Bool { values != initialValues }

    /// Updates a field value independently of SwiftUI focus state.
    public func update(_ value: String, for key: String) { values[key] = value }

    /// Applies field validations and returns first failures by field key.
    public func validationErrors(using fields: [String: FieldValidation<String>]) -> [String: String] {
        fields.reduce(into: [:]) { errors, field in
            if let error = field.value.error(for: values[field.key] ?? "") {
                errors[field.key] = error
            }
        }
    }

    /// Marks the current values as saved.
    public func markSaved() { initialValues = values }

    /// Restores every field to its last saved value.
    public func discardChanges() { values = initialValues }
}

/// An accessible summary of multiple validation failures.
public struct FormErrorSummary: View {
    /// The validation messages to present.
    public let messages: [String]

    /// Creates an accessible summary of one or more validation messages.
    public init(messages: [String]) { self.messages = messages }

    /// The validation summary, omitted when there are no messages.
    public var body: some View {
        if !messages.isEmpty {
            FoundationCard {
                VStack(alignment: .leading) {
                    Label("Please review the following", systemImage: "exclamationmark.triangle.fill")
                        .foregroundStyle(FoundationTokens.ColorRole.danger)
                    ForEach(messages, id: \.self) { Text("• \($0)") }
                }
            }
            .accessibilityElement(children: .combine)
        }
    }
}
