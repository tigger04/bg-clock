// ABOUTME: Computes clock hand angles and date strings from a given Date.
// Pure value type with injected Date and Calendar for deterministic testing.

import SwiftUI

struct TimeState: Sendable {
    let hourAngle: Angle
    let minuteAngle: Angle
    let secondAngle: Angle
    let dateString: String
    let dayOfWeekString: String
    let monthString: String

    /// Create a TimeState from a date, using the given calendar.
    /// Angles are continuous: 12 o'clock = 0 degrees, clockwise positive.
    /// The hour hand moves smoothly between hours (not snapping).
    init(date: Date = .now, calendar: Calendar = .current) {
        let components = calendar.dateComponents(
            [.hour, .minute, .second, .nanosecond, .day, .weekday, .month],
            from: date
        )

        let hour = Double(components.hour ?? 0)
        let minute = Double(components.minute ?? 0)
        let second = Double(components.second ?? 0)
        let nano = Double(components.nanosecond ?? 0) / 1_000_000_000

        let totalSeconds = second + nano
        let totalMinutes = minute + totalSeconds / 60.0
        let totalHours = hour + totalMinutes / 60.0

        self.secondAngle = Angle.degrees(totalSeconds / 60.0 * 360.0)
        self.minuteAngle = Angle.degrees(totalMinutes / 60.0 * 360.0)
        self.hourAngle = Angle.degrees(totalHours / 12.0 * 360.0)

        self.dateString = "\(components.day ?? 1)"

        let weekdaySymbols = calendar.weekdaySymbols
        let weekdayIndex = (components.weekday ?? 1) - 1
        self.dayOfWeekString = weekdaySymbols[weekdayIndex].uppercased()

        let monthSymbols = calendar.monthSymbols
        let monthIndex = (components.month ?? 1) - 1
        self.monthString = monthSymbols[monthIndex].uppercased()
    }
}
