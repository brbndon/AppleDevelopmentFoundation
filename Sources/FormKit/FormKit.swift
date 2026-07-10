import AppFoundation
import DesignSystem
import Observation
import SwiftUI

/// A reusable validation rule that returns a user-presentable reason when it fails.
public struct ValidationRule<Value>: Sendable {
    public let validate: @Sendable (Value) -> String?
    public init(validate: @escaping @Sendable (Value) -> String?) { self.validate = validate }
    public static func required(message: String = "This field is required.") -> Self where Value == String { .init { $0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? message : nil } }
    public static func maximumLength(_ count: Int, message: String? = nil) -> Self where Value == String { .init { $0.count > count ? (message ?? "Use at most \(count) characters.") : nil } }
}

public struct FieldValidation<Value>: Sendable {
    public let rules: [ValidationRule<Value>]
    public init(_ rules: [ValidationRule<Value>]) { self.rules = rules }
    public func error(for value: Value) -> String? { rules.lazy.compactMap { $0.validate(value) }.first }
}

public struct ValidatedTextField: View {
    private let title: LocalizedStringKey; @Binding private var text: String; private let validation: FieldValidation<String>; @FocusState private var focused: Bool
    public init(_ title: LocalizedStringKey, text: Binding<String>, validation: FieldValidation<String> = .init([])) { self.title = title; _text = text; self.validation = validation }
    public var body: some View { VStack(alignment: .leading, spacing: 4) { TextField(title, text: $text).textFieldStyle(.roundedBorder).focused($focused).accessibilityHint("Required input is announced when invalid."); if let error = validation.error(for: text), !text.isEmpty { Label(error, systemImage: "exclamationmark.circle.fill").font(.footnote).foregroundStyle(FoundationTokens.ColorRole.danger).accessibilityElement(children: .combine) } } }
}

public struct DecimalInput: View {
    private let title: LocalizedStringKey; @Binding private var value: Decimal?; @State private var text = ""; private let locale: Locale
    public init(_ title: LocalizedStringKey, value: Binding<Decimal?>, locale: Locale = .current) { self.title = title; _value = value; self.locale = locale }
    public var body: some View { TextField(title, text: $text).textFieldStyle(.roundedBorder).onChange(of: text) { value = Decimal(string: text, locale: locale) }.onAppear { if let value { text = value.formatted() } }.accessibilityLabel(title) }
}

@MainActor @Observable public final class FormState {
    public private(set) var initialValues: [String: String]
    public private(set) var values: [String: String]
    public init(values: [String: String] = [:]) { initialValues = values; self.values = values }
    public var isDirty: Bool { values != initialValues }
    public func update(_ value: String, for key: String) { values[key] = value }
    public func markSaved() { initialValues = values }
    public func discardChanges() { values = initialValues }
}

public struct FormErrorSummary: View {
    public let messages: [String]
    public init(messages: [String]) { self.messages = messages }
    public var body: some View { if !messages.isEmpty { FoundationCard { VStack(alignment: .leading) { Label("Please review the following", systemImage: "exclamationmark.triangle.fill").foregroundStyle(FoundationTokens.ColorRole.danger); ForEach(messages, id: \.self) { Text("• \($0)") } } }.accessibilityElement(children: .combine) } }
}
