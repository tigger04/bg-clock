// ABOUTME: Tests for TimeState hand angle and date string computation.
// Uses injected dates and a fixed UTC calendar for deterministic results.

import Foundation
import SwiftUI
import Testing
@testable import BGClock

@Suite("TimeState computation")
struct TimeStateTests {

    /// Fixed Gregorian calendar in UTC for deterministic tests.
    private var calendar: Calendar {
        var cal = Calendar(identifier: .gregorian)
        cal.timeZone = TimeZone(identifier: "UTC")!
        cal.locale = Locale(identifier: "en_US")
        return cal
    }

    /// Create a Date from components in the fixed calendar.
    private func makeDate(
        year: Int = 2026, month: Int = 2, day: Int = 8,
        hour: Int = 0, minute: Int = 0, second: Int = 0
    ) -> Date {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        components.hour = hour
        components.minute = minute
        components.second = second
        components.nanosecond = 0
        return calendar.date(from: components)!
    }

    @Test("Midnight — all hands at zero degrees")
    func timeState_midnight_allAnglesZero() {
        let date = makeDate(hour: 0, minute: 0, second: 0)
        let state = TimeState(date: date, calendar: calendar)
        #expect(state.hourAngle.degrees == 0.0)
        #expect(state.minuteAngle.degrees == 0.0)
        #expect(state.secondAngle.degrees == 0.0)
    }

    @Test("3:00:00 — hour at 90, minute at 0, second at 0")
    func timeState_threeOClock_hourAt90() {
        let date = makeDate(hour: 3, minute: 0, second: 0)
        let state = TimeState(date: date, calendar: calendar)
        #expect(state.hourAngle.degrees == 90.0)
        #expect(state.minuteAngle.degrees == 0.0)
        #expect(state.secondAngle.degrees == 0.0)
    }

    @Test("6:30:00 — hour at 195, minute at 180")
    func timeState_sixThirty_hourAt195() {
        let date = makeDate(hour: 6, minute: 30, second: 0)
        let state = TimeState(date: date, calendar: calendar)
        #expect(state.hourAngle.degrees == 195.0)
        #expect(state.minuteAngle.degrees == 180.0)
    }

    @Test("12:00:00 — hour wraps to 360 (equivalent to 0)")
    func timeState_noon_hourAt360() {
        let date = makeDate(hour: 12, minute: 0, second: 0)
        let state = TimeState(date: date, calendar: calendar)
        #expect(state.hourAngle.degrees == 360.0)
    }

    @Test("9:45:00 — hour at 292.5, minute at 270")
    func timeState_nineFortyFive_correctAngles() {
        let date = makeDate(hour: 9, minute: 45, second: 0)
        let state = TimeState(date: date, calendar: calendar)
        #expect(state.hourAngle.degrees == 292.5)
        #expect(state.minuteAngle.degrees == 270.0)
    }

    @Test("Date string returns correct day of month")
    func timeState_dateString_returnsDay() {
        let date = makeDate(day: 15)
        let state = TimeState(date: date, calendar: calendar)
        #expect(state.dateString == "15")
    }

    @Test("Day of week string is uppercase")
    func timeState_dayOfWeek_uppercase() {
        // 2026-02-08 is a Sunday
        let date = makeDate(year: 2026, month: 2, day: 8)
        let state = TimeState(date: date, calendar: calendar)
        #expect(state.dayOfWeekString == "SUNDAY")
    }

    @Test("Month string is uppercase")
    func timeState_month_uppercase() {
        let date = makeDate(month: 2)
        let state = TimeState(date: date, calendar: calendar)
        #expect(state.monthString == "FEBRUARY")
    }

    @Test("Second hand at 30 seconds is at 180 degrees")
    func timeState_thirtySeconds_secondAt180() {
        let date = makeDate(hour: 0, minute: 0, second: 30)
        let state = TimeState(date: date, calendar: calendar)
        #expect(state.secondAngle.degrees == 180.0)
    }
}
