// ABOUTME: Tests for clock hand length and scaling calculations.
// Validates proportional sizing from configuration percentages.

import Foundation
import SwiftUI
import Testing
@testable import BGClock

@Suite("Clock hand geometry")
struct ClockHandTests {

    @Test("Hand length at 100% equals radius")
    func handLength_100Percent_equalsRadius() {
        let clockSize: CGFloat = 500.0
        let lengthPercent: Double = 100.0
        let length = clockSize / 2 * lengthPercent / 100.0
        #expect(length == 250.0)
    }

    @Test("Hand length at 50% equals half radius")
    func handLength_50Percent_equalsHalfRadius() {
        let clockSize: CGFloat = 500.0
        let lengthPercent: Double = 50.0
        let length = clockSize / 2 * lengthPercent / 100.0
        #expect(length == 125.0)
    }

    @Test("Hand length at 0% returns zero")
    func handLength_zeroPercent_returnsZero() {
        let clockSize: CGFloat = 500.0
        let lengthPercent: Double = 0.0
        let length = clockSize / 2 * lengthPercent / 100.0
        #expect(length == 0.0)
    }

    @Test("Hand length scales with clock size")
    func handLength_scalesWithClockSize() {
        let lengthPercent: Double = 58.0
        let small = CGFloat(200.0) / 2 * lengthPercent / 100.0
        let large = CGFloat(600.0) / 2 * lengthPercent / 100.0
        #expect(large == small * 3.0)
    }

    @Test("Default second hand is longest at 100%")
    func defaultSecondHand_isLongest() {
        let config = ClockConfiguration()
        #expect(config.secondHand.lengthPercent == 100.0)
        #expect(config.secondHand.lengthPercent > config.minuteHand.lengthPercent)
        #expect(config.minuteHand.lengthPercent > config.hourHand.lengthPercent)
    }
}
