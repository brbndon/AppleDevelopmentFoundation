@testable import ShapeKit
import SwiftUI
import XCTest

final class ShapeKitTests: XCTestCase {
    func testShapesProduceNonEmptyPaths() {
        let rect = CGRect(x: 0, y: 0, width: 200, height: 160)
        let paths = [
            InfinityShape().path(in: rect),
            DownloadArrowShape(lineWidth: 80).path(in: rect),
            CircleTickShape().path(in: rect),
            WaveFill(curve: 0, curveHeight: 4, curveLength: 3).path(in: rect),
            TriangleShape().path(in: rect),
        ]

        for path in paths {
            XCTAssertFalse(path.isEmpty)
            XCTAssertGreaterThan(path.boundingRect.width, 0)
            XCTAssertGreaterThan(path.boundingRect.height, 0)
        }
    }

    func testDownloadArrowAnimatableDataRoundTrips() {
        var shape = DownloadArrowShape(lineWidth: 80)
        shape.animatableData = AnimatablePair(12, 24)
        XCTAssertEqual(shape.animatableData.first, 12)
        XCTAssertEqual(shape.animatableData.second, 24)
    }

    func testWaveFillAnimatableDataRoundTrips() {
        var shape = WaveFill(curve: 0, curveHeight: 4, curveLength: 3)
        shape.animatableData = 1.25
        XCTAssertEqual(shape.curve, 1.25)
        XCTAssertEqual(shape.animatableData, 1.25)
    }
}
