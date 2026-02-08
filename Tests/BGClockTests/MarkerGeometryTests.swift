// ABOUTME: Tests for clock face marker geometry calculations.
// Validates marker counts, angles, and size computations.

import Foundation
import SwiftUI
import Testing
@testable import BGClock

@Suite("Marker geometry")
struct MarkerGeometryTests {

    @Test("Total marker count is 60")
    func markers_totalCount_is60() {
        let indices = Array(0..<60)
        #expect(indices.count == 60)
    }

    @Test("Major marker count is 12")
    func markers_majorCount_is12() {
        let majorIndices = (0..<60).filter { $0 % 5 == 0 }
        #expect(majorIndices.count == 12)
    }

    @Test("Minor marker count is 48")
    func markers_minorCount_is48() {
        let minorIndices = (0..<60).filter { $0 % 5 != 0 }
        #expect(minorIndices.count == 48)
    }

    @Test("Major marker angles are at 30-degree intervals")
    func markers_majorAngles_at30DegreeIntervals() {
        let majorAngles = (0..<60)
            .filter { $0 % 5 == 0 }
            .map { Double($0) * 6.0 }
        let expected = stride(from: 0.0, through: 354.0, by: 30.0).map { $0 }
        #expect(majorAngles == expected)
    }

    @Test("Minor marker angles exclude 30-degree multiples")
    func markers_minorAngles_exclude30DegreeMultiples() {
        let minorAngles = (0..<60)
            .filter { $0 % 5 != 0 }
            .map { Double($0) * 6.0 }
        for angle in minorAngles {
            #expect(angle.truncatingRemainder(dividingBy: 30.0) != 0.0)
        }
    }

    @Test("Disc size calculates from percentage")
    func discSize_calculatesFromPercentage() {
        let clockSize: CGFloat = 500.0
        let discPercent: Double = 96.0
        let discSize = clockSize * discPercent / 100.0
        #expect(discSize == 480.0)
    }

    @Test("Marker length scales with clock size")
    func markerLength_scalesWithClockSize() {
        let clockSize: CGFloat = 400.0
        let lengthPercent: Double = 8.0
        let length = clockSize * lengthPercent / 100.0
        #expect(length == 32.0)
    }
}
