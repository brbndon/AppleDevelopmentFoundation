import FileKit
import TestingSupport
import UniformTypeIdentifiers
import XCTest

final class FileKitTests: XCTestCase {
    func testFilenameReplacesSeparatorsAndControlCharacters() throws {
        XCTAssertEqual(try SafeFilename.make("a/b:c\n"), "a-b-c-")
    }

    func testFilenameUsesFallbackForWhitespaceAndRejectsTraversalComponents() throws {
        XCTAssertEqual(try SafeFilename.make("   ", fallback: "export.txt"), "export.txt")
        XCTAssertThrowsError(try SafeFilename.make(".."))
    }

    func testPolicyRejectsOversizedUnsupportedAndNonRegularFiles() throws {
        let directory = try TemporaryDirectory.make()
        defer { try? FileManager.default.removeItem(at: directory) }
        let textFile = directory.appendingPathComponent("sample.txt")
        try Data(repeating: 0, count: 2).write(to: textFile)
        let oversized = FileImportPolicy(allowedTypes: [.plainText], maximumBytes: 1)
        XCTAssertThrowsError(try oversized.validate(textFile)) { error in
            XCTAssertEqual(error as? FileKitError, .fileTooLarge(maximumBytes: 1))
        }
        let unsupported = FileImportPolicy(allowedTypes: [.png], maximumBytes: 10)
        XCTAssertThrowsError(try unsupported.validate(textFile)) { error in
            XCTAssertEqual(error as? FileKitError, .unsupportedType)
        }
        XCTAssertThrowsError(try oversized.validate(directory)) { error in
            XCTAssertEqual(error as? FileKitError, .notARegularFile)
        }
    }

    func testPolicyRejectsNegativeLimitAndNonFileURLs() throws {
        let policy = FileImportPolicy(allowedTypes: [.plainText], maximumBytes: -1)
        XCTAssertThrowsError(try policy.validate(URL(string: "https://example.com/file.txt")!)) { error in
            XCTAssertEqual(error as? FileKitError, .invalidMaximumBytes)
        }
    }

    func testPolicyAndWriterRejectSymbolicLinks() throws {
        let directory = try TemporaryDirectory.make()
        defer { try? FileManager.default.removeItem(at: directory) }
        let source = directory.appendingPathComponent("source.txt")
        let link = directory.appendingPathComponent("link.txt")
        try Data("safe".utf8).write(to: source)
        try FileManager.default.createSymbolicLink(at: link, withDestinationURL: source)
        let policy = FileImportPolicy(allowedTypes: [.plainText], maximumBytes: 100)
        XCTAssertThrowsError(try policy.validate(link)) { error in
            XCTAssertEqual(error as? FileKitError, .unsafeSource)
        }
        XCTAssertThrowsError(try AtomicFileWriter.write(Data("unsafe".utf8), to: link, overwrite: true)) { error in
            XCTAssertEqual(error as? FileKitError, .unsafeDestination)
        }
        XCTAssertEqual(try Data(contentsOf: source), Data("safe".utf8))
    }

    func testTemporaryFileIsSanitizedAndLocatedUnderTemporaryDirectory() throws {
        let url = try FileLocations.temporaryFile(named: "draft/one.txt")
        XCTAssertEqual(url.deletingLastPathComponent(), FileManager.default.temporaryDirectory)
        XCTAssertEqual(url.lastPathComponent, "draft-one.txt")
    }

    func testAtomicWriterCreatesAtomicallyRejectsConflictsAndAllowsExplicitOverwrite() throws {
        let directory = try TemporaryDirectory.make()
        defer { try? FileManager.default.removeItem(at: directory) }
        let destination = directory.appendingPathComponent("export.txt")
        try AtomicFileWriter.write(Data("first".utf8), to: destination)
        XCTAssertEqual(try Data(contentsOf: destination), Data("first".utf8))
        XCTAssertThrowsError(try AtomicFileWriter.write(Data("second".utf8), to: destination)) { error in
            XCTAssertEqual(error as? FileKitError, .destinationExists)
        }
        try AtomicFileWriter.write(Data("second".utf8), to: destination, overwrite: true)
        XCTAssertEqual(try Data(contentsOf: destination), Data("second".utf8))
        XCTAssertThrowsError(try AtomicFileWriter.write(Data(), to: directory)) { error in
            XCTAssertEqual(error as? FileKitError, .notARegularFile)
        }
    }
}
