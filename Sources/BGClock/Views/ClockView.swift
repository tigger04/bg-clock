// ABOUTME: Top-level clock composition view.
// Combines face, hands, and overlays with TimelineView for smooth animation.

import SwiftUI

struct ClockView: View {
    let config: ClockConfiguration
    let clockSize: CGFloat

    var body: some View {
        TimelineView(.animation) { timeline in
            let time = TimeState(date: timeline.date)

            ZStack {
                ClockFaceView(config: config, clockSize: clockSize)

                ClockHandView(
                    config: config.hourHand,
                    angle: time.hourAngle,
                    clockSize: clockSize
                )

                ClockHandView(
                    config: config.minuteHand,
                    angle: time.minuteAngle,
                    clockSize: clockSize
                )

                ClockHandView(
                    config: config.secondHand,
                    angle: time.secondAngle,
                    clockSize: clockSize
                )
            }
            .frame(width: clockSize, height: clockSize)
        }
    }
}
