// ABOUTME: Top-level clock composition view.
// Combines face, hands, and overlays with TimelineView for smooth animation.

import SwiftUI

struct ClockView: View {
    let config: ClockConfiguration
    let clockSize: CGFloat

    private func handLength(for hand: HandConfig) -> CGFloat {
        clockSize / 2 * hand.lengthPercent / 100.0
    }

    var body: some View {
        TimelineView(.animation) { timeline in
            let time = TimeState(date: timeline.date)

            ZStack {
                ClockFaceView(config: config, clockSize: clockSize)

                ClockHandView(
                    config: config.hourHand,
                    angle: time.hourAngle,
                    clockSize: clockSize
                ) {
                    HandLabelView(
                        text: time.monthString,
                        config: config.monthOnHour,
                        handLength: handLength(for: config.hourHand)
                    )
                }

                ClockHandView(
                    config: config.minuteHand,
                    angle: time.minuteAngle,
                    clockSize: clockSize
                ) {
                    HandLabelView(
                        text: time.dayOfWeekString,
                        config: config.dayOnMinute,
                        handLength: handLength(for: config.minuteHand)
                    )
                }

                ClockHandView(
                    config: config.secondHand,
                    angle: time.secondAngle,
                    clockSize: clockSize
                )

                DateCenterView(
                    config: config.dateCenter,
                    clockSize: clockSize,
                    dateString: time.dateString
                )
            }
            .frame(width: clockSize, height: clockSize)
        }
    }
}
