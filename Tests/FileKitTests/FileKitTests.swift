import FileKit
import TestingSupport
import UniformTypeIdentifiers
import XCTest

final class FileKitTests: XCTestCase {
    func testFilenameRemovesSeparators() throws { XCTAssertEqual(try SafeFilename.make("a/b:c"), "a-b-c") }
    func testPolicyRejectsOversizedFile() throws { let directory = try TemporaryDirectory.make(); let file = directory.appendingPathComponent("sample.txt"); try Data(repeating: 0, count: 2).write(to: file); XCTAssertThrowsError(try FileImportPolicy(allowedTypes: [.plainText], maximumBytes: 1).validate(file)) }
}
