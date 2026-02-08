// ABOUTME: Tests for display state calculations and screen layout.
// Validates clock sizing and positioning from percentage-based configuration.

import Foundation
import SwiftUI
import Testing
@testable import BGClock

@Suite("Display state calculations")
struct DisplayStateTests {

    @Test("Clock size is percentage of screen shortest dimension")
    func clockSize_percentageOfShortestDimension() {
        let state = DisplayState(
            screenWidth: 1920,
            screenHeight: 1080,
            sizePercent: 30.0,
            position: Position()
        )
        // 30% of 1080 (shortest dimension)
        #expect(state.clockSize == 324.0)
    }

    @Test("Clock size uses width when height is larger")
    func clockSize_usesWidth_whenPortrait() {
        let state = DisplayState(
            screenWidth: 1080,
            screenHeight: 1920,
            sizePercent: 50.0,
            position: Position()
        )
        // 50% of 1080 (shortest dimension)
        #expect(state.clockSize == 540.0)
    }

    @Test("Clock position x from percentage")
    func clockPosition_xFromPercent() {
        let state = DisplayState(
            screenWidth: 2000,
            screenHeight: 1000,
            sizePercent: 20.0,
            position: Position(xPercent: 50.0, yPercent: 50.0)
        )
        // 50% of 2000
        #expect(state.clockOriginX == 1000.0)
    }

    @Test("Clock position y from percentage")
    func clockPosition_yFromPercent() {
        let state = DisplayState(
            screenWidth: 2000,
            screenHeight: 1000,
            sizePercent: 20.0,
            position: Position(xPercent: 50.0, yPercent: 25.0)
        )
        // 25% of 1000
        #expect(state.clockOriginY == 250.0)
    }

    @Test("Clock size at zero percent returns zero")
    func clockSize_zeroPercent_returnsZero() {
        let state = DisplayState(
            screenWidth: 1920,
            screenHeight: 1080,
            sizePercent: 0.0,
            position: Position()
        )
        #expect(state.clockSize == 0.0)
    }

    @Test("Clock size at 100 percent fills shortest dimension")
    func clockSize_100Percent_fillsShortestDimension() {
        let state = DisplayState(
            screenWidth: 2560,
            screenHeight: 1440,
            sizePercent: 100.0,
            position: Position()
        )
        #expect(state.clockSize == 1440.0)
    }

    @Test("Default position places clock in upper-left area")
    func defaultPosition_upperLeftArea() {
        let position = Position()
        #expect(position.xPercent == 35.0)
        #expect(position.yPercent == 20.0)
    }

    @Test("Display state recalculates with new screen dimensions")
    func displayState_recalculates_withNewDimensions() {
        let state1 = DisplayState(
            screenWidth: 1920,
            screenHeight: 1080,
            sizePercent: 30.0,
            position: Position()
        )
        let state2 = DisplayState(
            screenWidth: 3840,
            screenHeight: 2160,
            sizePercent: 30.0,
            position: Position()
        )
        #expect(state2.clockSize == state1.clockSize * 2)
    }
}
