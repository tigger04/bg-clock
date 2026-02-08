// ABOUTME: Renders a single clock hand as a rounded rectangle.
// Reusable for hour, minute, and second hands with different parameters.

import SwiftUI

struct ClockHandView<Overlay: View>: View {
    let config: HandConfig
    let angle: Angle
    let clockSize: CGFloat
    let overlay: () -> Overlay

    private var handLength: CGFloat {
        clockSize / 2 * config.lengthPercent / 100.0
    }

    var body: some View {
        RoundedRectangle(cornerRadius: config.width / 2)
            .fill(config.color.color)
            .frame(width: handLength, height: config.width)
            .overlay(alignment: .center) {
                overlay()
            }
            .shadow(color: .black.opacity(0.25), radius: config.width * 0.5)
            .offset(x: handLength / 2 - config.width / 2)
            .rotationEffect(angle)
    }

    init(
        config: HandConfig,
        angle: Angle,
        clockSize: CGFloat,
        @ViewBuilder overlay: @escaping () -> Overlay = { EmptyView() }
    ) {
        self.config = config
        self.angle = angle
        self.clockSize = clockSize
        self.overlay = overlay
    }
}
